import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/widgets/job_list_item.dart';

class JobList extends StatelessWidget {
  final List<JobCardModel> jobs;
  final Map<int, bool> selectedJobs;
  final Function(JobCardModel)? onJobRemoved;
  final Function(JobCardModel, bool)? onSelectionChanged;
  final Function(JobCardModel)? onJobTapped;
  final Function(int)? onLongPress;
  final int? longPressedJobId;
  final Database database;

  const JobList({
    super.key,
    required this.database,
    required this.jobs,
    required this.selectedJobs,
    this.onJobRemoved,
    this.onSelectionChanged,
    this.onJobTapped,
    this.onLongPress,
    this.longPressedJobId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: jobs.length,
      itemBuilder: _buildJobListItem,
    );
  }

  Widget _buildJobListItem(BuildContext context, int index) {
    final job = jobs[index];
    final bool isSelected = selectedJobs[job.id] ?? false;
    final bool isLongPressed = job.id == longPressedJobId;
    final bool isBlurred = longPressedJobId != null && !isLongPressed;
    
    return AbsorbPointer(
      absorbing: isBlurred,
      child: JobListItem(
        job: job,
        isSelected: isSelected,
        isLongPressed: isLongPressed,
        isBlurred: isBlurred,
        onChanged: (selected) {
          if (onSelectionChanged != null) {
            onSelectionChanged!(job, selected);
          }
          if (onJobTapped != null) {
            onJobTapped!(job);
          }
        },
        onLongPress: () {
          if (onLongPress != null) {
            onLongPress!(job.id);
          }
        },
        onRemove: () {
          if (onJobRemoved != null) {
            onJobRemoved!(job);
          }
        },
      ),
    );
  }
}