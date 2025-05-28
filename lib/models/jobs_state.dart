import 'package:youllgetit_flutter/models/job_card/job_card_model.dart';

class JobsState {
  final List<JobCardModel> jobs;
  final bool isLoading;
  final String? errorMessage;

  const JobsState({
    required this.jobs, 
    this.isLoading = false, 
    this.errorMessage
  });

  JobsState copyWith({
    List<JobCardModel>? jobs,
    bool? isLoading,
    String? errorMessage,
  }) {
    return JobsState(
      jobs: jobs ?? this.jobs,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}