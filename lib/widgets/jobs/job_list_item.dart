import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/models/job_status.dart';
import 'package:youllgetit_flutter/widgets/jobs/job_details_page.dart';

class JobListItem extends StatelessWidget {
  final JobCardModel job;
  final JobStatus jobStatus;
  final bool isLongPressed;
  final bool isBlurred;
  final Function(JobStatus) onStatusChanged;
  final VoidCallback onLongPress;
  final VoidCallback onRemove;

  const JobListItem({
    super.key,
    required this.job,
    required this.jobStatus,
    required this.isLongPressed,
    required this.isBlurred,
    required this.onStatusChanged,
    required this.onLongPress,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToJobDetailPage(context, job),
      onLongPress: onLongPress,
      child: Stack(
        children: [
          _buildJobCard(),
          _buildStatusIcons(),
          if (isBlurred) _buildBlurOverlay(),
          if (isLongPressed) _buildRemoveButton(),
        ],
      ),
    );
  }

  Widget _buildJobCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: _getBorderColor(),
          width: 1,
        ),
      ),
      elevation: 3,
      shadowColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 60.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              job.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  job.company,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  ' ®',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getBorderColor() {
    switch (jobStatus) {
      case JobStatus.liked:
        return Colors.black;
      case JobStatus.toApply:
        return Colors.blue;
      case JobStatus.applied:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatusIcons() {
    return Positioned(
      right: 40,
      bottom: 30,
      child: Row(
        children: [
          if (jobStatus != JobStatus.liked) 
            GestureDetector(
              onTap: () {
                switch (jobStatus) {
                  case JobStatus.toApply:
                    onStatusChanged(JobStatus.liked);
                    break;
                  case JobStatus.applied:
                    onStatusChanged(JobStatus.toApply);
                    break;
                  default:
                    break;
                }
              },
              child: Icon(
                Icons.close,
                color: Colors.red,
                size: 20,
              ),
            ),
          
          if (jobStatus != JobStatus.applied)
            SizedBox(width: 10),
          
          if (jobStatus != JobStatus.applied)
            GestureDetector(
              onTap: () {
                switch (jobStatus) {
                  case JobStatus.liked:
                    onStatusChanged(JobStatus.toApply);
                    break;
                  case JobStatus.toApply:
                    onStatusChanged(JobStatus.applied);
                    break;
                  default:
                    break;
                }
              },
              child: Icon(
                Icons.check,
                color: jobStatus == JobStatus.liked ? Colors.grey : Colors.green,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBlurOverlay() {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.2 * 255).toInt()),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRemoveButton() {
    return Positioned(
      right: 26,
      bottom: 18,
      child: ElevatedButton.icon(
        onPressed: onRemove,
        icon: const Icon(Icons.delete_outline, size: 18),
        label: const Text('Remove'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade400,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  void _navigateToJobDetailPage(BuildContext context, JobCardModel job) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobDetailPage(job: job),
      ),
    );
  }
}