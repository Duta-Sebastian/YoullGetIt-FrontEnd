import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/models/job_status.dart';
import 'package:youllgetit_flutter/widgets/jobs/job_list_item.dart';

class JobList extends StatelessWidget {
  final List<JobCardModel> jobs;
  final Map<String, JobStatus> jobStatuses;
  final Function(JobCardModel)? onJobRemoved;
  final Function(JobCardModel, JobStatus)? onStatusChanged;
  final Function(JobCardModel)? onJobTapped;
  final Function(String)? onLongPress;
  final String? longPressedJobId;

  const JobList({
    super.key,
    required this.jobs,
    required this.jobStatuses,
    this.onJobRemoved,
    this.onStatusChanged,
    this.onJobTapped,
    this.onLongPress,
    this.longPressedJobId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: jobs.length,
      itemBuilder: _buildJobListItem,
      separatorBuilder: (context, index) => const SizedBox(height: 1.5),
    );
  }

  Widget _buildJobListItem(BuildContext context, int index) {
    final job = jobs[index];
    final jobStatus = jobStatuses[job.id] ?? JobStatus.liked;
    final bool isLongPressed = job.id == longPressedJobId;
    final bool isBlurred = longPressedJobId != null && !isLongPressed;
    
    return AbsorbPointer(
      absorbing: isBlurred,
      child: JobListItem(
        job: job,
        jobStatus: jobStatus,
        isLongPressed: isLongPressed,
        isBlurred: isBlurred,
        onStatusChanged: (newStatus) {
          if (onStatusChanged != null) {
            onStatusChanged!(job, newStatus);
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