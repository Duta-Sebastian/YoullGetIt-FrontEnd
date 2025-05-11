import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/models/job_feedback.dart';
import 'package:youllgetit_flutter/models/jobs_state.dart';
import 'package:youllgetit_flutter/providers/connectivity_provider.dart';
import 'package:youllgetit_flutter/services/job_api.dart';

class ActiveJobsNotifier extends StateNotifier<JobsState> {
  final Ref _ref;
  StreamSubscription<bool>? _connectivitySubscription;
  bool _hasPendingFetch = false;
  
  ActiveJobsNotifier(this._ref) : super(const JobsState(jobs: [], isLoading: true)) {
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
    debugPrint('Initializing Jobs');
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
    debugPrint('Fetching Jobs');
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
  static const String _storedFeedbackKey = 'stored_pending_feedback';
  
  final Ref _ref;
  final Map<String, Future<void>> _activeRequests = {};
  StreamSubscription<bool>? _connectivitySubscription;
  
  FeedbackNotifier(this._ref) : super([]) {
    _connectivitySubscription = _ref.read(connectivityServiceProvider)
        .onConnectivityChanged
        .listen(_handleConnectivityChange);
    
    _loadStoredFeedback();
  }

  Future<void> _loadStoredFeedback() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedFeedbackJson = prefs.getStringList(_storedFeedbackKey) ?? [];
      
      if (storedFeedbackJson.isEmpty) return;
      
      debugPrint('Found ${storedFeedbackJson.length} stored feedback items from previous session');
      
      final storedFeedback = storedFeedbackJson.map((jsonStr) {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        return JobFeedback(
          jobId: map['jobId'] as String,
          liked: map['liked'] as bool,
        );
      }).toList();
      
      state = [...state, ...storedFeedback];
      
      await prefs.remove(_storedFeedbackKey);
      
      if (_ref.read(connectivityServiceProvider).isConnected) {
        for (final feedback in storedFeedback) {
          _sendSingleFeedback(feedback);
        }
      }
    } catch (e) {
      debugPrint('Error loading stored feedback: $e');
    }
  }
  
  Future<void> _saveToLocalStorage() async {
    if (state.isEmpty) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final feedbackJsonList = state.map((feedback) => 
        jsonEncode({
          'jobId': feedback.jobId,
          'liked': feedback.liked,
          'timestamp': DateTime.now().toIso8601String(),
        })
      ).toList();
      
      await prefs.setStringList(_storedFeedbackKey, feedbackJsonList);
      debugPrint('Saved ${feedbackJsonList.length} feedback items to local storage');
    } catch (e) {
      debugPrint('Error saving feedback to local storage: $e');
    }
  }

  void _handleConnectivityChange(bool isConnected) {
    if (isConnected && state.isNotEmpty) {
      debugPrint('Connection restored, attempting to send pending feedback');
      
      final pendingFeedback = List<JobFeedback>.from(state);
      for (final feedback in pendingFeedback) {
        if (!_activeRequests.containsKey(feedback.jobId)) {
          _sendSingleFeedback(feedback);
        }
      }
    }
  }

  Future<void> addFeedback(JobFeedback feedback) {
    state = [...state, feedback];
    
    return _sendSingleFeedback(feedback);
  }

  Future<void> _sendSingleFeedback(JobFeedback feedback) async {
    if (_activeRequests.containsKey(feedback.jobId)) {
      return _activeRequests[feedback.jobId]!;
    }
    
    final requestFuture = _processFeedback(feedback);
    _activeRequests[feedback.jobId] = requestFuture;
    
    requestFuture.whenComplete(() {
      _activeRequests.remove(feedback.jobId);
    });
    
    return requestFuture;
  }
  
  Future<void> _processFeedback(JobFeedback feedback) async {
    final isConnected = _ref.read(connectivityServiceProvider).isConnected;
    if (!isConnected) {
      debugPrint('No connectivity, storing feedback for later: ${feedback.jobId}');
      final completer = Completer<void>();      
      return completer.future;
    }

    try {
      final feedbackList = [feedback];
      await JobApi.postFeedback(feedbackList);
      
      state = state.where((item) => item.jobId != feedback.jobId).toList();
      
      debugPrint('Successfully sent feedback for job: ${feedback.jobId}');
    } catch (e) {
      debugPrint('Error sending feedback for job ${feedback.jobId}: $e');
      rethrow;
    }
  }

  Future<void> waitForPendingFeedback() async {
    if (_activeRequests.isEmpty && state.isEmpty) return;
    
    if (_activeRequests.isNotEmpty) {
      final futures = _activeRequests.values.toList();
      try {
        await Future.wait(futures);
      } catch (e) {
        debugPrint('Error waiting for pending feedback: $e');
      }
    }
    
    if (state.isNotEmpty && _ref.read(connectivityServiceProvider).isConnected) {
      final pendingFeedbacks = List<JobFeedback>.from(state);
      final futures = <Future<void>>[];
      
      for (final feedback in pendingFeedbacks) {
        futures.add(_sendSingleFeedback(feedback));
      }
      
      try {
        await Future.wait(futures);
      } catch (e) {
        debugPrint('Error sending remaining feedback: $e');
      }
    }
  }

  Future<void> flushPendingFeedback() async {
    await waitForPendingFeedback();
    
    if (state.isNotEmpty) {
      await _saveToLocalStorage();
    }
  }

  void resetJobs() {
    _activeRequests.clear();
    state = [];
  }
  
  @override
  void dispose() {
    flushPendingFeedback();
    
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}

class JobCoordinator {
  final Ref _ref;
  bool _initialFeedbackProcessed = false;
  
  JobCoordinator(this._ref);

  Future<void> initialize() async {
    if (!_initialFeedbackProcessed) {
      await _ref.read(feedbackProvider.notifier).waitForPendingFeedback();
      _initialFeedbackProcessed = true;
    }
  }

  Future<void> handleSwipe(int index, bool liked) async {
    final activeJobs = _ref.read(activeJobsProvider).jobs;
    
    if (index < 0 || index >= activeJobs.length) return;
    
    final job = activeJobs[index];
    
    _ref.read(feedbackProvider.notifier).addFeedback(
      JobFeedback(jobId: job.id, liked: liked)
    );
    
    _ref.read(swipedJobsProvider.notifier).addSwipedJob(job);
    _ref.read(activeJobsProvider.notifier).removeJob(index);
    
    if (activeJobs.length == 1) {
      await _ref.read(feedbackProvider.notifier).waitForPendingFeedback();
      _ref.read(activeJobsProvider.notifier).fetchJobs();
    }
  }

  Future<void> resetJobState() async {
    await _ref.read(feedbackProvider.notifier).flushPendingFeedback();
    
    _ref.read(activeJobsProvider.notifier).resetJobs();
    _ref.read(swipedJobsProvider.notifier).resetJobs();
    _ref.read(feedbackProvider.notifier).resetJobs();
  }

  Future<void> handleManualSearchAdd(JobCardModel job) async {
    await _ref.read(feedbackProvider.notifier).addFeedback(
      JobFeedback(jobId: job.id, liked: true)
    );
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

final appInitializationProvider = FutureProvider<void>((ref) async {
  final coordinator = ref.read(jobCoordinatorProvider);
  await coordinator.initialize();
  
  ref.read(activeJobsProvider.notifier)._initializeJobs();
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