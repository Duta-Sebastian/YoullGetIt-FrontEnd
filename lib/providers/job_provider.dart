import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/services/job_api.dart';

final jobProvider = StateNotifierProvider<JobNotifier, List<JobCardModel>>((ref) {
  return JobNotifier();
});

class JobNotifier extends StateNotifier<List<JobCardModel>> {
  JobNotifier() : super([]);

  Future<void> fetchJobs(int jobNumber) async {
    final newJobs = await JobApi.fetchJobs(jobNumber);
    state = [...state, ...newJobs]; 
  }

  // void removeJob(int index) {
  //   state = [...state]..removeAt(index);
  // }
}
