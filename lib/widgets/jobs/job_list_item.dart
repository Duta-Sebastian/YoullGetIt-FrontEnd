import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/models/job_status.dart';
import 'package:youllgetit_flutter/widgets/jobs/job_details_page.dart';

class JobListItem extends StatelessWidget {
  final JobCardModel job;
  final JobStatus jobStatus;
  final Function(JobStatus) onStatusChanged;

  const JobListItem({
    super.key,
    required this.job,
    required this.jobStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToJobDetailPage(context, job),
      child: _buildJobCard(context),
    );
  }

  Widget _buildJobCard(BuildContext context) {
    // Get match score (for demonstration purposes)
    final int matchScore = (job.matchScore * 100).toInt();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.08).round()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _getBorderColor().withAlpha((255 * 0.5).round()),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Subtle gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _getGradientColor().withAlpha((255 * 0.05).round()),
                      _getGradientColor().withAlpha((255 * 0.02).round()),
                    ],
                  ),
                ),
              ),
            ),
            
            // Status indicator on left side
            Positioned(
              left: 0,
              top: 16,
              bottom: 16,
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with title and status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title area
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            // Company info
                            Row(
                              children: [
                                Icon(
                                  Icons.business_center_outlined,
                                  size: 14,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    job.company,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Status badge in top-right
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getStatusIcon(),
                              size: 14,
                              color: _getStatusTextColor(),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getStatusText(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _getStatusTextColor(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Match score badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getScoreColor(matchScore),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.bolt,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Match Score: $matchScore%",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  
                  _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton.icon(
          onPressed: () {
            // View details action
            _navigateToJobDetailPage(context, job);
          },
          icon: const Icon(Icons.visibility_outlined, size: 16),
          label: const Text('View Details'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey.shade700,
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        _buildStatusControlButtons(),
      ],
    );
  }

  Widget _buildStatusControlButtons() {
    return Row(
      children: [
        if (jobStatus != JobStatus.liked) 
          IconButton(
            onPressed: () {
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
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              foregroundColor: Colors.grey.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.zero,
              minimumSize: const Size(36, 36),
            ),
            tooltip: 'Move back',
          ),
        
        if (jobStatus != JobStatus.applied)
          const SizedBox(width: 8),
        
        if (jobStatus != JobStatus.applied)
          IconButton(
            onPressed: () {
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
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
            style: IconButton.styleFrom(
              backgroundColor: _getActionButtonColor(),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.zero,
              minimumSize: const Size(36, 36),
            ),
            tooltip: 'Move forward',
          ),
      ],
    );
  }

  Color _getBorderColor() {
    switch (jobStatus) {
      case JobStatus.liked:
        return Colors.amber.shade300;
      case JobStatus.toApply:
        return Colors.blue.shade300;
      case JobStatus.applied:
        return Colors.green.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  Color _getGradientColor() {
    switch (jobStatus) {
      case JobStatus.liked:
        return Colors.amber;
      case JobStatus.toApply:
        return Colors.blue;
      case JobStatus.applied:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getActionButtonColor() {
    switch (jobStatus) {
      case JobStatus.liked:
        return Colors.blue;
      case JobStatus.toApply:
        return Colors.green;
      case JobStatus.applied:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 90) {
      return Colors.green.shade600;
    } else if (score >= 80) {
      return Colors.teal.shade500;
    } else if (score >= 70) {
      return Colors.amber.shade600;
    } else {
      return Colors.grey.shade500;
    }
  }

  Color _getStatusColor() {
    switch (jobStatus) {
      case JobStatus.liked:
        return Colors.amber.shade500;
      case JobStatus.toApply:
        return Colors.blue.shade500;
      case JobStatus.applied:
        return Colors.green.shade500;
      default:
        return Colors.grey.shade500;
    }
  }

  Color _getStatusTextColor() {
    return Colors.white;
  }

  String _getStatusText() {
    switch (jobStatus) {
      case JobStatus.liked:
        return "Liked";
      case JobStatus.toApply:
        return "To Apply";
      case JobStatus.applied:
        return "Applied";
      default:
        return "";
    }
  }

  IconData _getStatusIcon() {
    switch (jobStatus) {
      case JobStatus.liked:
        return Icons.thumb_up_outlined;
      case JobStatus.toApply:
        return Icons.edit_document;
      case JobStatus.applied:
        return Icons.check_circle_outline;
      default:
        return Icons.circle_outlined;
    }
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