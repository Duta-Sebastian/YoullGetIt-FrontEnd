import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/models/job_card/job_card_model.dart';
import 'package:youllgetit_flutter/models/job_card/job_deadline_model.dart';
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
    final localizations = AppLocalizations.of(context)!;
    
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              if (onAddToLiked != null) {
                onAddToLiked!(job);
              }
            },
            backgroundColor: const Color(0xFF22C55E),
            foregroundColor: Colors.white,
            icon: Icons.favorite_rounded,
            label: localizations.jobListItemSave,
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => _navigateToJobDetailPage(context, job),
        child: _buildJobCard(context, localizations),
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, AppLocalizations localizations) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFFFF9E6)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with title, company, and match score
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.roleName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                            letterSpacing: -0.2,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.business_rounded,
                              size: 16,
                              color: const Color(0xFF6B7280),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                job.companyName,
                                style: TextStyle(
                                  color: const Color(0xFF6B7280),
                                  fontSize: 15,
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
                  
                  // Match score badge
                  if (job.matchScore != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      // decoration: BoxDecoration(
                      //   color: _getMatchScoreColor(job.matchScore!),
                      //   borderRadius: BorderRadius.circular(15),
                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: _getMatchScoreColor(job.matchScore!).withAlpha(77),
                      //       blurRadius: 4,
                      //       offset: const Offset(0, 2),
                      //     ),
                      //   ],
                      // ),
                      child: Text(
                        '${(job.matchScore! * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Location and deadline info
              Row(
                children: [
                  if (job.jobLocation.isNotEmpty)
                    Expanded(
                      child: _buildInfoRow(
                        Icons.location_on_rounded,
                        job.jobLocation.take(2).map((loc) => loc.jobCity).join(', '),
                        const Color(0xFF6B7280),
                      ),
                    ),
                  if (job.deadline != null) ...[
                    const SizedBox(width: 12),
                    _buildDeadlineChip(job.deadline!, localizations),
                  ],
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Job details chips - Improved wrapping
              LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    clipBehavior: Clip.none,
                    children: [
                      if (job.workMode.isNotEmpty)
                        _buildInfoChip(
                          Icons.work_rounded,
                          _localizeWorkMode(job.workMode, localizations),
                          const Color(0xFFA5B4FC),
                          const Color(0xFF1F2937),
                        ),
                      if (job.expectedSalary.isNotEmpty)
                        _buildInfoChip(
                          Icons.payments_rounded,
                          job.expectedSalary,
                          const Color(0xFFFBBF24),
                          const Color(0xFF1F2937),
                        ),
                      if (job.durationInMonths > 0)
                        _buildInfoChip(
                          Icons.timer_rounded,
                          '${job.durationInMonths} ${localizations.jobCardMonths}',
                          const Color(0xFF86EFAC),
                          const Color(0xFF1F2937),
                        ),
                      if (job.internshipSeason.isNotEmpty)
                        _buildInfoChip(
                          Icons.calendar_today_rounded,
                          job.internshipSeason,
                          const Color(0xFF86EFAC), // Light green for season
                          const Color(0xFF1F2937),
                        ),
                    ],
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              // Skills preview - Improved wrapping
              if (job.hardSkills.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(
                      Icons.build_rounded,
                      size: 16,
                      color: const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      localizations.jobCardRelatedFields,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      clipBehavior: Clip.none,
                      children: job.relatedFields.take(3).map((field) => _buildSkillChip(_localizeField(field, localizations))).toList(),
                    );
                  },
                ),
                const SizedBox(height: 4),
              ],
              
              // Related fields if no hard skills - Improved wrapping
              if (job.hardSkills.isEmpty && job.relatedFields.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(
                      Icons.category_rounded,
                      size: 16,
                      color: const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      localizations.jobListItemRelatedFields,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      clipBehavior: Clip.none,
                      children: job.relatedFields.take(3).map((field) => _buildSkillChip(_localizeField(field, localizations))).toList(),
                    );
                  },
                ),
                const SizedBox(height: 4),
              ],
              
              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xFFE0E0E0)),
              const SizedBox(height: 16),
              
              // Bottom row with additional info and view button
              Row(
                children: [
                  // Additional info
                  Expanded(
                    child: job.requiredSpokenLanguages.isNotEmpty
                        ? _buildLanguageInfo()
                        : job.requiredDegree.isNotEmpty
                            ? _buildEducationInfo(localizations)
                            : job.visaHelp.isNotEmpty
                                ? _buildVisaInfo()
                                : const SizedBox.shrink(),
                  ),
                  
                  // View details button
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withAlpha(77),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => _navigateToJobDetailPage(context, job),
                      icon: const Icon(Icons.visibility_rounded, size: 16, color: Colors.white),
                      label: Text(
                        localizations.jobListItemViewDetails,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _localizeWorkMode(String workMode, AppLocalizations localizations) {
    switch (workMode.toLowerCase()) {
      case 'remote':
        return localizations.workModeRemote;
      case 'hybrid':
        return localizations.workModeHybrid;
      case 'on-site':
      case 'onsite':
        return localizations.workModeOnSite;
      case 'internship':
        return localizations.optionYesInternship.replaceAll('Yes, ', '');
      case 'part-time':
        return localizations.optionYesPartTime.replaceAll('Yes, ', '');
      default:
        return workMode.isEmpty ? localizations.jobCardNotAvailable : workMode;
    }
  }

  String _localizeField(String field, AppLocalizations localizations) {
    switch (field.toLowerCase()) {
      case 'engineering':
        return localizations.optionEngineering;
      case 'it & data science':
      case 'it and data science':
        return localizations.optionItDataScience;
      case 'marketing & communication':
      case 'marketing and communication':
        return localizations.optionMarketingCommunication;
      case 'finance & economics':
      case 'finance and economics':
        return localizations.optionFinanceEconomics;
      case 'political science':
      case 'political science & public administration':
        return localizations.optionPoliticalScience;
      case 'sales & business administration':
      case 'sales and business administration':
        return localizations.optionSalesBusiness;
      case 'arts & culture':
      case 'arts and culture':
        return localizations.optionArtsCulture;
      case 'biology, chemistry, & life sciences':
      case 'biology chemistry life sciences':
        return localizations.optionBiologyChemistry;
      case 'mechanical':
        return localizations.optionMechanical;
      case 'electrical':
        return localizations.optionElectrical;
      case 'aerospace':
        return localizations.optionAerospace;
      case 'civil':
        return localizations.optionCivil;
      case 'chemical':
        return localizations.optionChemical;
      default:
        return field;
    }
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDeadlineChip(JobDeadline deadline, AppLocalizations localizations) {
    final isUrgent = _isDeadlineSoon(deadline);
    final color = isUrgent ? const Color(0xFFEF4444) : const Color(0xFF6B7280);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule_rounded, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            _formatDeadline(deadline, localizations),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color bgColor, Color textColor) {
    if (text.isEmpty) {
      text = 'N/A';
    }
    
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: bgColor.withAlpha(51),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
        ),
        child: Text(
          skill,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6B7280),
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }

  Widget _buildLanguageInfo() {
    final languages = job.requiredSpokenLanguages.take(2).join(', ');
    return Row(
      children: [
        Icon(
          Icons.language_rounded,
          size: 14,
          color: const Color(0xFF6B7280),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            languages,
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEducationInfo(AppLocalizations localizations) {
    final education = _localizeEducation(job.requiredDegree.first, localizations);
    return Row(
      children: [
        Icon(
          Icons.school_rounded,
          size: 14,
          color: const Color(0xFF6B7280),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            education,
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _localizeEducation(String education, AppLocalizations localizations) {
    switch (education.toLowerCase()) {
      case 'bachelor':
        return localizations.optionBachelor;
      case 'master':
        return localizations.optionMaster;
      case 'phd':
        return localizations.optionPhd;
      case 'highschool':
        return localizations.optionHighschool;
      default:
        return education;
    }
  }

  Widget _buildVisaInfo() {
    return Row(
      children: [
        Icon(
          Icons.flight_rounded,
          size: 14,
          color: const Color(0xFF6B7280),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            job.visaHelp,
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDeadline(JobDeadline deadline, AppLocalizations localizations) {
    // Handle empty or invalid dates
    if (deadline.month.isEmpty || deadline.day.isEmpty) {
      return localizations.jobListItemNotSpecified;
    }
    
    try {
      final int month = int.parse(deadline.month);
      final int day = int.parse(deadline.day);
      final int currentYear = DateTime.now().year;
      
      // Create a deadline date for this year
      DateTime deadlineDate = DateTime(currentYear, month, day);
      
      // If the deadline has already passed this year, assume it's for next year
      if (deadlineDate.isBefore(DateTime.now())) {
        deadlineDate = DateTime(currentYear + 1, month, day);
      }
      
      final now = DateTime.now();
      final difference = deadlineDate.difference(now).inDays;
      
      if (difference < 0) {
        return localizations.jobListItemExpired;
      } else if (difference == 0) {
        return localizations.jobListItemToday;
      } else if (difference == 1) {
        return localizations.jobListItemTomorrow;
      } else if (difference < 7) {
        return localizations.jobListItemDaysLeft(difference.toString());
      } else {
        // Format as Month/Day for compact display
        return '$month/$day';
      }
    } catch (e) {
      return localizations.jobListItemInvalid;
    }
  }

  bool _isDeadlineSoon(JobDeadline deadline) {
    // Handle empty or invalid dates
    if (deadline.month.isEmpty || deadline.day.isEmpty) {
      return false;
    }
    
    try {
      final int month = int.parse(deadline.month);
      final int day = int.parse(deadline.day);
      final int currentYear = DateTime.now().year;
      
      // Create a deadline date for this year
      DateTime deadlineDate = DateTime(currentYear, month, day);
      
      // If the deadline has already passed this year, assume it's for next year
      if (deadlineDate.isBefore(DateTime.now())) {
        deadlineDate = DateTime(currentYear + 1, month, day);
      }
      
      final difference = deadlineDate.difference(DateTime.now()).inDays;
      return difference <= 7 && difference >= 0;
    } catch (e) {
      return false;
    }
  }

  // Color _getMatchScoreColor(double score) {
  //   if (score >= 0.8) return const Color(0xFF22C55E);
  //   if (score >= 0.6) return const Color(0xFF3B82F6);
  //   if (score >= 0.4) return const Color(0xFFFBBF24);
  //   return const Color(0xFFEF4444);
  // }

  void _navigateToJobDetailPage(BuildContext context, JobCardModel job) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobDetailPage(job: job),
      ),
    );
  }
}