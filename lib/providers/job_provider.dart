import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/models/job_feedback.dart';
import 'package:youllgetit_flutter/models/jobs_state.dart';
import 'package:youllgetit_flutter/providers/connectivity_provider.dart';
import 'package:youllgetit_flutter/services/job_api.dart';

// ACTIVE JOBS NOTIFIER
class ActiveJobsNotifier extends StateNotifier<JobsState> {
  final Ref _ref;
  StreamSubscription<bool>? _connectivitySubscription;
  bool _hasPendingFetch = false;
  
  ActiveJobsNotifier(this._ref) : super(const JobsState(jobs: [], isLoading: true)) {
    // Listen to connectivity changes
    _connectivitySubscription = _ref.read(connectivityServiceProvider)
        .onConnectivityChanged
        .listen(_handleConnectivityChange);
    
    _initializeJobs();
  }

  void _handleConnectivityChange(bool isConnected) {
    if (isConnected) {
      if (_hasPendingFetch || state.errorMessage != null) {
        debugPrint('Network restored, retrying job fetch');
        _hasPendingFetch = false;
        
        if (state.jobs.isEmpty) {
          _initializeJobs();
        } else {
          fetchJobs();
        }
      }
    }
  }

  Future<void> _initializeJobs() async {
    final isConnected = _ref.read(connectivityServiceProvider).isConnected;
    
    if (!isConnected) {
      _hasPendingFetch = true;
      state = const JobsState(
        jobs: [],
        isLoading: false,
        errorMessage: 'No internet connection. Will retry when online.'
      );
      return;
    }
    
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final jobs = await JobApi.fetchJobs();
      
      state = JobsState(jobs: jobs, isLoading: false);
    } catch (e) {
      debugPrint('Error initializing jobs: $e');
      state = JobsState(
        jobs: [], 
        isLoading: false, 
        errorMessage: 'Failed to load job recommendations after multiple attempts'
      );
    }
  }

  Future<void> fetchJobs() async {
    final isConnected = _ref.read(connectivityServiceProvider).isConnected;
    
    if (!isConnected) {
      _hasPendingFetch = true;
      if (state.jobs.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'No internet connection. Will retry when online.'
        );
      }
      return;
    }
    
    state = state.copyWith(isLoading: state.jobs.isEmpty, errorMessage: null);
    
    try {
      final jobs = await JobApi.fetchJobs();
      state = state.copyWith(
        jobs: [...state.jobs, ...jobs],
        isLoading: false,
        errorMessage: null
      );
    } catch (e) {
      debugPrint('Error fetching additional jobs: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load more job recommendations'
      );
    }
  }

  void removeJob(int index) {
    if (index < 0 || index >= state.jobs.length) return;
    
    final newJobs = [...state.jobs];
    newJobs.removeAt(index);
    state = state.copyWith(jobs: newJobs);
  }

  void resetJobs() {
    state = const JobsState(jobs: [], isLoading: true);
    _initializeJobs();
  }
  
  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
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
  final Ref _ref;
  bool _isSending = false;
  StreamSubscription<bool>? _connectivitySubscription;
  
  FeedbackNotifier(this._ref) : super([]) {
    _connectivitySubscription = _ref.read(connectivityServiceProvider)
        .onConnectivityChanged
        .listen(_handleConnectivityChange);
  }

  void _handleConnectivityChange(bool isConnected) {
    if (isConnected && state.isNotEmpty && !_isSending) {
      debugPrint('Connection restored, attempting to send pending feedback');
      _sendBatchedFeedback();
    }
  }

  void addFeedback(JobFeedback feedback) {
    state = [...state, feedback];
    
    final isConnected = _ref.read(connectivityServiceProvider).isConnected;
    
    if (isConnected && !_isSending) {
      _sendBatchedFeedback();
    } else if (!isConnected) {
      debugPrint('No connectivity, storing feedback for later');
    }
  }

  Future<void> _sendBatchedFeedback() async {
    if (state.isEmpty || _isSending) return;

    _isSending = true;
    try {
      final currentFeedback = [...state];
      
      await JobApi.postFeedback(currentFeedback);
      
      state = state.where((feedback) => 
        !currentFeedback.any((sent) => sent.jobId == feedback.jobId && sent.liked == feedback.liked)
      ).toList();
      
      debugPrint('Successfully sent ${currentFeedback.length} feedback items');
    } 
    catch (e) {
      debugPrint('Error sending feedback: $e');
    }
    finally {
      _isSending = false;
      
      if (state.isNotEmpty && _ref.read(connectivityServiceProvider).isConnected && !_isSending) {
        _isSending = true;
        _sendBatchedFeedback();
      }
    }
  }

  Future<void> flushPendingFeedback() async {
    if (state.isNotEmpty && _ref.read(connectivityServiceProvider).isConnected) {
      await _sendBatchedFeedback();
    }
  }

  void resetJobs() {
    state = [];
  }
  
  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}

class JobCoordinator {
  final Ref _ref;
  
  JobCoordinator(this._ref);

  Future<void> handleSwipe(int index, bool liked) async {
    final activeJobs = _ref.read(activeJobsProvider).jobs;
    
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

final activeJobsProvider = StateNotifierProvider<ActiveJobsNotifier, JobsState>((ref) {
  return ActiveJobsNotifier(ref);
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

final jobsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(activeJobsProvider).isLoading;
});

final jobsErrorProvider = Provider<String?>((ref) {
  return ref.watch(activeJobsProvider).errorMessage;
});

final jobsListProvider = Provider<List<JobCardModel>>((ref) {
  return ref.watch(activeJobsProvider).jobs;
});

final jobCoordinatorProvider = Provider<JobCoordinator>((ref) {
  return JobCoordinator(ref);
});