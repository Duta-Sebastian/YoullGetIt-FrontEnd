import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/models/job_feedback.dart';
import 'package:youllgetit_flutter/providers/auth_provider.dart';
import 'package:youllgetit_flutter/utils/cv_to_base64.dart';
import 'package:youllgetit_flutter/utils/unique_id.dart';

class JobApi {
  static ProviderContainer? _container;

  static void initialize(ProviderContainer container) {
    _container = container;
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
      final uri = Uri.parse('https://api2.youllgetit.eu/upload_cv_and_questions');
      
      final request = http.MultipartRequest('POST', uri)
        ..fields['cv_byte_str_repr'] = cvAsBase64 ?? ''
        ..fields['answers_to_questions_str'] = answersJson ?? ''
        ..fields['guest_id'] = uniqueId
        ..fields['auth_id'] = authId ?? '';

      final response = await request.send();
      
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final String taskId = jsonDecode(responseBody);
        await pollForCompletion(taskId);
      } else {
        throw Exception('Failed to upload data: ${response.statusCode}');
      }
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
        final response = await http.post(
          Uri.parse('https://api2.youllgetit.eu/is_cv_ready?task_id=$taskId'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({}),
        );
        
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          
          if (data['status'] == 'completed') {
            isComplete = true;
            return true;
          }
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

      debugPrint('JobApi: uniqueId: $uniqueId');

      final formData = {
        'guest_id': uniqueId,
        'auth_id': authId ?? '',
      };
      final response = await http.post(
        Uri.parse('https://api2.youllgetit.eu/recommend'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: formData,
      );
      if (response.statusCode == 200) {
        final List<dynamic> jobsData = jsonDecode(response.body);
        return jobsData.map((job) {
          final jobData = job[0];
          final double matchScore = job[1];
          jobData['match_score'] = matchScore;
          return JobCardModel.fromJson(jobData);
        }).toList().reversed.toList();
      } else if (response.statusCode == 404) {
        throw Exception('No recommendations found for this user');
      } else {
        throw Exception('Failed to load recommended jobs: ${response.statusCode}');
      }
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

      final formData = {
        'guest_id': uniqueId,
        'auth_id': authId ?? '',
        'job_feedbacks': jobFeedbacks.map((feedback) {
          return {
            'job_id': feedback.jobId,
            'feedback': feedback.wasLiked,
          };
        }).toList(),
      };

      final response = await http.post(
        Uri.parse('https://api2.youllgetit.eu/upload_feedback'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(formData),
      );

      if (response.statusCode == 200) {
        debugPrint('Feedback posted successfully');
      } else {
        debugPrint('Failed to post feedback: ${response.statusCode}');
        throw Exception('Failed to post feedback: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error posting feedback: $e');
    }
  }
}