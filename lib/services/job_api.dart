import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/models/job_feedback.dart';
import 'package:youllgetit_flutter/providers/auth_provider.dart';
import 'package:youllgetit_flutter/utils/cv_to_base64.dart';
import 'package:youllgetit_flutter/utils/unique_id.dart';
import 'package:youllgetit_flutter/utils/job_api_encryption_manager.dart';

class JobApi {
  static ProviderContainer? _container;
  static JobApiEncryptionManager? _encryptionManager;

  static void initialize(ProviderContainer container) {
    _container = container;
    _encryptionManager = JobApiEncryptionManager();
    _encryptionManager!.initialize();
  }

  static Future<int> uploadUserInformation(bool? withCv, Map<String, dynamic>? answers) async {
    final authState = _container!.read(authProvider);
    final String? authId = authState.isLoggedIn ? authState.credentials?.user.sub : null;

    final Future<String> uniqueIdFuture = getUniqueId();
    final Future<String?>? cvFuture = (withCv == true) ? encodeCvFile() : null;

    final Future<String?> answersJsonFuture = answers != null 
        ? compute<Map<String, dynamic>, String>(
            (data) => jsonEncode(data), 
            answers
          )
        : Future.value(null);

    final results = await Future.wait<dynamic>([
      uniqueIdFuture,
      answersJsonFuture,
      if (cvFuture != null) cvFuture,
    ]);

    final String uniqueId = results[0] as String;
    final String? answersJson = results[1] as String?;

    final String? cvAsBase64 = cvFuture != null ? results[2] as String? : null;

    try {
      final Map<String, dynamic> userData = {
        'cv_byte_str_repr': cvAsBase64 ?? '',
        'answers_to_questions': answersJson ?? '',
        'guest_id': uniqueId,
        'auth_id': authId ?? '',
      };

      final String taskId = await _encryptionManager!.encryptedPost<String>(
        '/upload_cv_and_questions',
        userData,
        (responseJson) => jsonDecode(responseJson)
      );
      
      await pollForCompletion(taskId);
    } catch (e) {
      debugPrint('API call failed: $e');
      return 0;
    }
    return 1;
  }

  static Future<bool> pollForCompletion(String taskId) async {
    bool isComplete = false;
    int attempts = 0;
    
    while (!isComplete && attempts < 40) {
      try {
        final Map<String, dynamic> requestData = {
          'task_id': taskId,
        };
        
        final statusResponse = await _encryptionManager!.encryptedPost<Map<String, dynamic>>(
          '/is_cv_ready',
          requestData,
          (responseJson) => jsonDecode(responseJson)
        );
        
        if (statusResponse.containsKey('status') && statusResponse['status'] == 'completed') {
          isComplete = true;
          return true;
        }  
      } catch (e) {
        throw Exception('Error checking status: $e');
      }
      await Future.delayed(const Duration(seconds: 3));
      attempts++;
    }
    
    if (!isComplete) {
      throw Exception('Processing timed out');
    }
    
    return isComplete;
  }

  static Future<List<JobCardModel>> fetchJobs(int count) async {
    try {
      final authState = _container!.read(authProvider);
      final String? authId = authState.isLoggedIn ? authState.credentials?.user.sub : null;

      final String uniqueId = await getUniqueId();

      final Map<String, dynamic> requestData = {
        'guest_id': uniqueId,
        'auth_id': authId ?? '',
      };

      final List<dynamic> jobsData = await _encryptionManager!.encryptedPost<List<dynamic>>(
        '/recommend',
        requestData,
        (responseJson) => jsonDecode(responseJson)
      );

      return jobsData.map((job) {
        final jobData = job["internship"];
        final double matchScore = job["score"];
        jobData['match_score'] = matchScore;
        return JobCardModel.fromJson(jobData);
      }).toList().reversed.toList();
    } catch (e) {
      debugPrint('Error fetching recommendations: $e');
      return [];
    }
  }

  static Future<void> postFeedback(List<JobFeedback> jobFeedbacks) async {
    try {
      final authState = _container!.read(authProvider);
      final String? authId = authState.isLoggedIn ? authState.credentials?.user.sub : null;

      final String uniqueId = await getUniqueId();

      final Map<String, dynamic> requestData = {
        'guest_id': uniqueId,
        'auth_id': authId ?? '',
        'job_feedbacks': jobFeedbacks.map((feedback) {
          return {
            'job_id': feedback.jobId,
            'feedback': feedback.liked,
          };
        }).toList(),
      };

      await _encryptionManager!.encryptedPost<dynamic>(
        '/upload_feedback',
        requestData,
        (responseJson) => null
      );

      debugPrint('Feedback posted successfully');
    } catch (e) {
      debugPrint('Error posting feedback: $e');
    }
  }

  static void dispose() {
    _encryptionManager?.dispose();
  }
}