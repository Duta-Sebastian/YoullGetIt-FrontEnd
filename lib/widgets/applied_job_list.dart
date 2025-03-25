import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';

class ToApplyJobList extends StatelessWidget {
  final List<JobCardModel> toApplyJobs;

  const ToApplyJobList({
    super.key,
    required this.toApplyJobs,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: toApplyJobs.length,
      itemBuilder: itemBuilder,
       separatorBuilder: (context, index) => const SizedBox(height: 1.5),
    );
  }
}