import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/models/job_status.dart';

class JobCardStatusModel {
  final JobCardModel jobCard;
  final JobStatus status;

  JobCardStatusModel({
    required this.jobCard,
    required this.status,
  });
}