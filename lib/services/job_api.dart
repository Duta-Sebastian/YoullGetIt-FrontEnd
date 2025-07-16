import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:youllgetit_flutter/models/job_card/job_card_model.dart';
import 'package:youllgetit_flutter/models/job_feedback.dart';
import 'package:youllgetit_flutter/providers/auth_provider.dart';
import 'package:youllgetit_flutter/utils/cv_to_base64.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
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

  static Future<int> uploadUserInformation(bool? withCv, Map<String, dynamic>? answers, {bool? skipCvAndAnswers}) async {
    Map<String, dynamic> finalAnswers = {};
    if (answers == null) {
      final savedAnswers = await DatabaseManager.getQuestionAnswersMap();
      if (savedAnswers != null) {
        finalAnswers = savedAnswers;
      } else {
        debugPrint('JobAPI: No answers found in SharedPreferences');
        return -1;
      }
    } else {
      finalAnswers = answers;
    }
    final authState = _container!.read(authProvider);
    final String? authId = authState.isLoggedIn ? authState.credentials?.user.sub : null;

    final Future<String> uniqueIdFuture = getUniqueId();
    final Future<String?>? cvFuture = (withCv == true) ? encodeCvFile() : null;

    final Future<String?> answersJsonFuture = compute<Map<String, dynamic>, String>(
            (data) => jsonEncode(data), 
            finalAnswers
          );

    final results = await Future.wait<dynamic>([
      uniqueIdFuture,
      answersJsonFuture,
      if (cvFuture != null) cvFuture,
    ]);

    final String uniqueId = results[0] as String;
    final String? answersJson = results[1] as String?;

    final String? cvAsBase64 = cvFuture != null ? results[2] as String? : null;

    int attempts = 1;
    while (attempts <= 3)
    {
      try {
        Map<String, dynamic> userData;
        if ((skipCvAndAnswers ?? false) == false){
          userData= {
            'cv_byte_str_repr': cvAsBase64 ?? '',
            'answers_to_questions_str': answersJson ?? '',
            'guest_id': uniqueId,
            'auth_id': authId ?? '',
          };
        }
        else {
          userData = {
            'guest_id': uniqueId,
            'auth_id': authId ?? '',
            'cv_byte_str_repr': null,
            'answers_to_questions_str': null,
          };
        }
        debugPrint('JobAPI: Uploading user information with data: $userData');

        final String taskId = await _encryptionManager!.encryptedPost<String>(
          '/upload_cv_and_questions',
          userData,
          (responseJson) => jsonDecode(responseJson)
        );
        
        await pollForCompletion(taskId);
        return 1;
      } catch (e) {
        debugPrint('JobAPI: Upload user information API call failed, attempt $attempts / 3, with the error : $e');
        attempts += 1;
      }
    }
    throw Exception("JobAPI: Upload user information API calls failed, maximum retry attempts excedeed!");
  }

  static Future<void> pollForCompletion(String taskId) async {
    int attempts = 0;
    
    while (attempts < 40) {
      try {
        final Map<String, dynamic> requestData = {
          'task_id': taskId,
        };
        
        final statusResponse = await _encryptionManager!.encryptedPost<Map<String, dynamic>>(
          '/is_cv_ready',
          requestData,
          (responseJson) => jsonDecode(responseJson)
        );
        
        if (statusResponse.containsKey('status')) {
          if (statusResponse['status'] == 'error ') {
            throw ('Processing failed');
          }
          if (statusResponse['status'] == 'completed') {
            return ;
          }
        }
      } catch (e) {
        throw Exception("There was an error with the task, please try again later.");

      }
      await Future.delayed(const Duration(seconds: 3));
      attempts++;
    }
    
    throw Exception('Processing timed out');
  }

  static Future<List<JobCardModel>> fetchJobs() async {
    final authState = _container!.read(authProvider);
    final String? authId = authState.isLoggedIn ? authState.credentials?.user.sub : null;

    final String uniqueId = await getUniqueId();

    final Map<String, dynamic> requestData = {
      'guest_id': uniqueId,
      'auth_id': authId ?? '',
    };

    int attempts = 1;
    while (attempts <= 3) 
    {
      try {
        final List<dynamic> jobsData = await _encryptionManager!.encryptedPost<List<dynamic>>(
          '/recommend',
          requestData,
          (responseJson) => jsonDecode(responseJson)
        );

        if (jobsData.isEmpty) {
          return [];
        }
        return JobCardModel.jobCardModelListFactory(jobsData);
      } catch (e) {
        debugPrint('JobAPI: Error fetching recommendations, attempt $attempts / 3, with message : $e');
        attempts += 1;
      }
    }
    throw Exception('JobAPI: Error fetching recommendations, retries exceeded!');
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

  static Future<bool> markJobWithResult(String jobId) async {
    try {
      final String baseUrl = 'https://api2.youllgetit.eu/mark_by_user';
      
      final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
        'job_id': jobId,
      });
      
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('Failed to mark job: ${response.statusCode}');
        return false;
      }
      
    } catch (e) {
      debugPrint('Error marking job: $e');
      return false;
    }
  }

  static Future<void> deleteUserData() async {
    try{
      final AuthState authState = _container!.read(authProvider);
      final String? authId = authState.isLoggedIn ? authState.credentials?.user.sub : null;
      final String uniqueId = await getUniqueId();

      final Map<String, dynamic> requestData = {
        'guest_id': uniqueId,
        'auth_id': authId ?? '',
      };

      await _encryptionManager!.encryptedPost<dynamic>(
        '/delete_user_data',
        requestData,
        (responseJson) => null
      );
    }
    catch (e) {
      debugPrint('Error deleting user data: $e');
    }
  }

  static void dispose() {
    _encryptionManager?.dispose();
  }
}