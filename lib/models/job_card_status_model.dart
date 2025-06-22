import 'dart:convert';

import 'package:youllgetit_flutter/models/job_card/job_card_model.dart';
import 'package:youllgetit_flutter/models/job_status.dart';

class JobCardStatusModel {
  final String feedbackId;
  final JobCardModel jobCard;
  final JobStatus status;
  final DateTime? lastChanged;
  final bool isDeleted;

  JobCardStatusModel({
    required this.feedbackId,
    required this.jobCard,
    required this.status,
    this.lastChanged,
    this.isDeleted = false,
  });

  factory JobCardStatusModel.fromJson(Map<String, dynamic> json) {
    final String jobDataStr = json['job_data'];
    final Map<String, dynamic> jobData = jsonDecode(jobDataStr);
    final JobCardModel jobCardObj = JobCardModel.fromJson(jobData);
    return JobCardStatusModel(
      feedbackId: json['feedback_id'],
      jobCard: jobCardObj,
      status: JobStatusExtension.fromString(json['status']),
      lastChanged: json['last_changed'] != null 
          ? DateTime.parse(json['last_changed'])
          : null,
      isDeleted: json['is_deleted'] ?? false,
    );
  }

  static List<JobCardStatusModel> listFromJson(List<dynamic> jsonArray) {
    if (jsonArray.isEmpty) {
      throw Exception("Empty response array");
    }
    
    List<JobCardStatusModel> jobCards = [];
    for (var json in jsonArray) {
      jobCards.add(JobCardStatusModel.fromJson(json));
    }
    return jobCards;
  }

  static String encodeJobCartToJson(List<JobCardStatusModel> jobCart) {
    List<Map<String, dynamic>> jobRecords = jobCart.map((job) => {
      'id': job.jobCard.feedbackId,
      'job_data': jsonEncode(job.jobCard.toJson()),
      'last_changed': job.lastChanged?.toUtc().toIso8601String() ?? DateTime.now().toUtc().toIso8601String(),
      'status': job.status.name,
      'is_deleted': job.isDeleted,
    }).toList();
    
    return jsonEncode(jobRecords);
  }
}