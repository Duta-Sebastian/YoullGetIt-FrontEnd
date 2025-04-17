import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/services/job_api.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';

class JobState {
  final List<JobCardModel> activeJobs;
  final List<JobCardModel> swipedJobs;
  
  JobState({
    required this.activeJobs,
    required this.swipedJobs,
  });
  
  JobState copyWith({
    List<JobCardModel>? activeJobs,
    List<JobCardModel>? swipedJobs,
  }) {
    return JobState(
      activeJobs: activeJobs ?? this.activeJobs,
      swipedJobs: swipedJobs ?? this.swipedJobs,
    );
  }
}

class JobProvider extends StateNotifier<JobState> {
  JobProvider() 
      : super(JobState(activeJobs: [], swipedJobs: [])) {
    fetchJobs(10);
  }

  Future<void> fetchJobs(int count) async {
    final jobs = await JobApi.fetchJobs(count);
    state = state.copyWith(
      activeJobs: [...state.activeJobs, ...jobs]
    );
  }

  Future<int> swipeJob(int index, bool liked) async {
    if (index < 0 || index >= state.activeJobs.length) return -1;
    
    final job = state.activeJobs[index];
    
    // Send feedback to API
    await JobApi.postFeedback(job, liked);
    
    if (liked) {
      DatabaseManager.insertJobCard(job);
    }

    final newActiveJobs = [...state.activeJobs];
    newActiveJobs.removeAt(index);
    
    state = state.copyWith(
      activeJobs: newActiveJobs,
      swipedJobs: [...state.swipedJobs, job]
    );
    return 0;
  }
}

// Create the provider
final jobProvider = StateNotifierProvider<JobProvider, JobState>((ref) {
  return JobProvider();
});