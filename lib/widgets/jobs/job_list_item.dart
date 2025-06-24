import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/models/job_card/job_card_model.dart';
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
                              job.roleName,
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
                                const Icon(
                                  Icons.business_center_outlined,
                                  size: 14,
                                  color: Color(0xFF6B7280),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    job.companyName,
                                    style: const TextStyle(
                                      color: Color(0xFF6B7280),
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
                              _getStatusText(context),
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
    final localizations = AppLocalizations.of(context)!;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton.icon(
          onPressed: () {
            // View details action
            _navigateToJobDetailPage(context, job);
          },
          icon: const Icon(Icons.visibility_outlined, size: 16),
          label: Text(localizations.jobCartViewDetails),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF6B7280),
            side: const BorderSide(color: Color(0xFFD1D5DB)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        _buildStatusControlButtons(context),
      ],
    );
  }

  Widget _buildStatusControlButtons(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
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
              backgroundColor: const Color(0xFFF3F4F6),
              foregroundColor: const Color(0xFF6B7280),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.zero,
              minimumSize: const Size(36, 36),
            ),
            tooltip: localizations.jobCartMoveBack,
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
            tooltip: localizations.jobCartMoveForward,
          ),
      ],
    );
  }

  Color _getBorderColor() {
    switch (jobStatus) {
      case JobStatus.liked:
        return const Color(0xFFFBBF24);
      case JobStatus.toApply:
        return const Color(0xFF3B82F6);
      case JobStatus.applied:
        return const Color(0xFF22C55E);
      default:
        return const Color(0xFFD1D5DB);
    }
  }

  Color _getGradientColor() {
    switch (jobStatus) {
      case JobStatus.liked:
        return const Color(0xFFFBBF24);
      case JobStatus.toApply:
        return const Color(0xFF3B82F6);
      case JobStatus.applied:
        return const Color(0xFF22C55E);
      default:
        return const Color(0xFFD1D5DB);
    }
  }

  Color _getActionButtonColor() {
    switch (jobStatus) {
      case JobStatus.liked:
        return const Color(0xFF3B82F6);
      case JobStatus.toApply:
        return const Color(0xFF22C55E);
      case JobStatus.applied:
        return const Color(0xFFD1D5DB);
      default:
        return const Color(0xFFD1D5DB);
    }
  }

  Color _getStatusColor() {
    switch (jobStatus) {
      case JobStatus.liked:
        return const Color(0xFFFBBF24);
      case JobStatus.toApply:
        return const Color(0xFF3B82F6);
      case JobStatus.applied:
        return const Color(0xFF22C55E);
      default:
        return const Color(0xFFD1D5DB);
    }
  }

  Color _getStatusTextColor() {
    return Colors.white;
  }

  String _getStatusText(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    switch (jobStatus) {
      case JobStatus.liked:
        return localizations.jobCartTabLiked;
      case JobStatus.toApply:
        return localizations.jobCartTabToApply;
      case JobStatus.applied:
        return localizations.jobCartTabApplied;
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