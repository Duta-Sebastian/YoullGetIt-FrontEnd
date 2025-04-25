import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/models/job_feedback.dart';
import 'package:youllgetit_flutter/services/job_api.dart';

class ActiveJobsNotifier extends StateNotifier<List<JobCardModel>> {
  ActiveJobsNotifier() : super([]) {
    _initializeJobs();
  }

  Future<void> _initializeJobs() async {
    final jobs = await JobApi.fetchJobs();
    state = jobs;
  }

  Future<void> fetchJobs() async {
    final jobs = await JobApi.fetchJobs();
    state = [...state, ...jobs];
  }

  void removeJob(int index) {
    if (index < 0 || index >= state.length) return;
    
    final newJobs = [...state];
    newJobs.removeAt(index);
    state = newJobs;
  }

  void resetJobs() {
    state = [];
  }
}

class SwipedJobsNotifier extends StateNotifier<List<JobCardModel>> {
  SwipedJobsNotifier() : super([]);

  void addSwipedJob(JobCardModel job) {
    final updatedJobs = [...state, job];

    if (updatedJobs.length > 5) {
      state = updatedJobs.sublist(updatedJobs.length - 5);
    } else {
      state = updatedJobs;
    }
  }

  void resetJobs() {
    state = [];
  }
}

class FeedbackNotifier extends StateNotifier<List<JobFeedback>> {
  final Ref ref;
  
  FeedbackNotifier(this.ref) : super([]);

  void addFeedback(JobFeedback feedback) {
    state = [...state, feedback];
    
    if (state.isNotEmpty) {
      _sendBatchedFeedback();
    }
  }

  Future<void> _sendBatchedFeedback() async {
    if (state.isEmpty) return;

    try {
      await JobApi.postFeedback([...state]);
      state = [];
    } 
    catch (e) {}
  }

  Future<void> flushPendingFeedback() async {
    if (state.isNotEmpty) {
      await _sendBatchedFeedback();
    }
  }

  void resetJobs() {
    state = [];
  }
}

final activeJobsProvider = StateNotifierProvider<ActiveJobsNotifier, List<JobCardModel>>((ref) {
  return ActiveJobsNotifier();
});

final swipedJobsProvider = StateNotifierProvider<SwipedJobsNotifier, List<JobCardModel>>((ref) {
  return SwipedJobsNotifier();
});

final feedbackProvider = StateNotifierProvider<FeedbackNotifier, List<JobFeedback>>((ref) {
  final notifier = FeedbackNotifier(ref);
  ref.onDispose(() {
    notifier.flushPendingFeedback();
  });
  return notifier;
});

class JobCoordinator {
  final Ref _ref;
  
  JobCoordinator(this._ref);

  Future<void> handleSwipe(int index, bool liked) async {
    final activeJobs = _ref.read(activeJobsProvider);
    
    if (index < 0 || index >= activeJobs.length) return;
    
    final job = activeJobs[index];
    
    _ref.read(feedbackProvider.notifier).addFeedback(
      JobFeedback(jobId: job.id, liked: liked)
    );
    
    _ref.read(swipedJobsProvider.notifier).addSwipedJob(job);
    
    _ref.read(activeJobsProvider.notifier).removeJob(index);
    
    if (activeJobs.length - 1 <= 8) {
      _ref.read(activeJobsProvider.notifier).fetchJobs();
    }
  }

  Future<void> resetJobState() async {
    _ref.read(activeJobsProvider.notifier).resetJobs();
    _ref.read(swipedJobsProvider.notifier).resetJobs();
    _ref.read(feedbackProvider.notifier).resetJobs();
  }
}

final jobCoordinatorProvider = Provider<JobCoordinator>((ref) {
  return JobCoordinator(ref);
});