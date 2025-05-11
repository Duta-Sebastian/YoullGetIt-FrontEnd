// lib/widgets/jobs/search_job_list_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // You'll need to add this package
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/widgets/jobs/job_details_page.dart';

class SearchJobListItem extends StatelessWidget {
  final JobCardModel job;
  final Function(JobCardModel)? onAddToLiked;

  const SearchJobListItem({
    super.key,
    required this.job,
    this.onAddToLiked,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      // Slidable configuration with smaller width
      endActionPane: ActionPane(
        extentRatio: 0.25, // Reduce the width of the slidable area
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              if (onAddToLiked != null) {
                onAddToLiked!(job);
              }
            },
            backgroundColor: Colors.amber.shade500,
            foregroundColor: Colors.white,
            icon: Icons.add_shopping_cart, // Changed to shopping cart icon
            label: 'Add', // Shortened label
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => _navigateToJobDetailPage(context, job),
        child: _buildJobCard(context),
      ),
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
          color: Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with title and company
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
                      
                      // Location badge in top-right
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: Colors.blue.shade800,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              job.location,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Work mode and job type
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.work_outline, 
                        job.workMode, 
                        Colors.purple.shade100, 
                        Colors.purple.shade800
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        Icons.access_time, 
                        job.jobType, 
                        Colors.teal.shade100, 
                        Colors.teal.shade800
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
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
                  
                  // Skills
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...job.hardSkills.take(3).map((skill) => _buildSkillChip(skill)),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // View details button
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      onPressed: () => _navigateToJobDetailPage(context, job),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        skill,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade800,
        ),
      ),
    );
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

  void _navigateToJobDetailPage(BuildContext context, JobCardModel job) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobDetailPage(job: job),
      ),
    );
  }
}