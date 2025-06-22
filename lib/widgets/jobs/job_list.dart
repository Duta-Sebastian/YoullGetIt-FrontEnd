import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/models/job_card/job_card_model.dart';
import 'package:youllgetit_flutter/models/job_status.dart';
import 'package:youllgetit_flutter/widgets/jobs/job_list_item.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class JobList extends StatelessWidget {
  final List<JobCardModel> jobs;
  final Map<String, JobStatus> jobStatuses;
  final Function(JobCardModel, JobStatus)? onJobRemoved;
  final Function(JobCardModel, JobStatus)? onStatusChanged;

  const JobList({
    super.key,
    required this.jobs,
    required this.jobStatuses,
    this.onJobRemoved,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: jobs.length,
      itemBuilder: _buildJobListItem,
      padding: const EdgeInsets.symmetric(vertical: 8),
      physics: const ClampingScrollPhysics(),
    );
  }

  Widget _buildJobListItem(BuildContext context, int index) {
    final job = jobs[index];
    final jobStatus = jobStatuses[job.feedbackId] ?? JobStatus.liked;
    
    return Slidable(
      key: Key(job.feedbackId),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.25,
        dismissible: null,
        children: [
          CustomSlidableAction(
            onPressed: (context) async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Text('Remove Job'),
                    content: const Text('Are you sure you want to remove this job from your list?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Remove'),
                      ),
                    ],
                  );
                },
              ) ?? false;
              
              if (confirm && onJobRemoved != null) {
                onJobRemoved!(job, jobStatus);
              }
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            borderRadius: BorderRadius.circular(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.delete_outlined, size: 24),
                SizedBox(height: 4),
                Text(
                  'Remove',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      child: JobListItem(
        job: job,
        jobStatus: jobStatus,
        onStatusChanged: (newStatus) {
          if (onStatusChanged != null) {
            onStatusChanged!(job, newStatus);
          }
        },
      ),
    );
  }
}