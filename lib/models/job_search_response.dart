import 'package:youllgetit_flutter/models/job_card/job_card_model.dart';

class JobSearchResponse {
  final List<JobCardModel> jobs;
  final int totalCount;
  final int currentPage;
  final bool hasMorePages;

  JobSearchResponse({
    required this.jobs,
    required this.totalCount,
    required this.currentPage,
    this.hasMorePages = false,
  });
}