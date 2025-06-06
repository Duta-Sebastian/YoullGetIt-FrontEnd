import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/models/job_card/job_card_model.dart';
import 'package:youllgetit_flutter/models/job_card/job_deadline_model.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailPage extends StatelessWidget {
  final JobCardModel job;

  const JobDetailPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Job Details',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1F2937)),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new_rounded),
            onPressed: () => _launchJobUrl(job.url),
            tooltip: 'Open in browser',
          ),
        ],
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _buildHeader(),
            ),
            
            // Content Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildJobDetailsCard(),
                  const SizedBox(height: 16),
                  _buildEducationCard(),
                  const SizedBox(height: 16),
                  _buildSkillsCard(),
                  const SizedBox(height: 16),
                  _buildDescriptionCard(),
                  const SizedBox(height: 16),
                  if (job.requirements.isNotEmpty)
                    _buildRequirementsCard(),
                  if (job.requirements.isNotEmpty)
                    const SizedBox(height: 16),
                  // Uncomment if you want to show match score card
                  // _buildMatchScoreCard(),
                  // const SizedBox(height: 24),
                  _buildApplyButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.business_rounded,
                        size: 18,
                        color: const Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          job.companyName,
                          style: TextStyle(
                            fontSize: 18,
                            color: const Color(0xFF374151),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Uncomment if you want to show match score
            // if (job.matchScore != null)
            //   Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //     decoration: BoxDecoration(
            //       color: _getMatchScoreColor(job.matchScore!),
            //       borderRadius: BorderRadius.circular(25),
            //       boxShadow: [
            //         BoxShadow(
            //           color: _getMatchScoreColor(job.matchScore!).withAlpha(77),
            //           blurRadius: 8,
            //           offset: const Offset(0, 2),
            //         ),
            //       ],
            //     ),
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         const Icon(Icons.star_rounded, color: Colors.white, size: 18),
            //         const SizedBox(width: 4),
            //         Text(
            //           '${(job.matchScore! * 100).round()}%',
            //           style: const TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //             fontSize: 16,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
          ],
        ),
        
        if (job.jobLocation.isNotEmpty || job.deadline != null) ...[
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          
          // Location and Deadline
          if (job.jobLocation.isNotEmpty)
            _buildHeaderInfoRow(
              Icons.location_on_rounded,
              'Location',
              job.jobLocation.map((loc) => '${loc.jobCity}, ${loc.jobCountry}').join(' • '),
            ),
          
          if (job.deadline != null)
            _buildHeaderInfoRow(
              Icons.schedule_rounded,
              'Deadline',
              _formatDeadline(job.deadline!),
              isUrgent: _isDeadlineSoon(job.deadline!),
            ),
        ],
      ],
    );
  }

  Widget _buildHeaderInfoRow(IconData icon, String label, String value, {bool isUrgent = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isUrgent ? const Color(0xFFEF4444) : const Color(0xFF6B7280),
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF374151),
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isUrgent ? const Color(0xFFEF4444) : const Color(0xFF374151),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobDetailsCard() {
    final details = [
      if (job.workMode.isNotEmpty) 
        _DetailItem(Icons.work_rounded, 'Work Mode', job.workMode),
      if (job.expectedSalary.isNotEmpty)
        _DetailItem(Icons.attach_money_rounded, 'Salary', job.expectedSalary),
      if (job.durationInMonths > 0)
        _DetailItem(Icons.timer_rounded, 'Duration', '${job.durationInMonths} months'),
      if (job.timeSpent.isNotEmpty)
        _DetailItem(Icons.schedule_rounded, 'Time Commitment', job.timeSpent),
      if (job.internshipSeason.isNotEmpty)
        _DetailItem(Icons.calendar_today_rounded, 'Season', job.internshipSeason),
      if (job.visaHelp.isNotEmpty)
        _DetailItem(Icons.flight_rounded, 'Visa Help', job.visaHelp),
    ];

    if (details.isEmpty) return const SizedBox.shrink();

    return _buildSectionCard(
      'Job Details',
      Icons.info_rounded,
      Column(
        children: details.map((detail) => _buildDetailRow(detail)).toList(),
      ),
    );
  }

  Widget _buildEducationCard() {
    final educationItems = <Widget>[];
    
    if (job.requiredDegree.isNotEmpty) {
      educationItems.addAll([
        _buildSubsectionTitle('Required Degree'),
        const SizedBox(height: 8),
        _buildChipGrid(job.requiredDegree, const Color(0xFFE879F9)), // Light purple
      ]);
    }
    
    if (job.allowedGraduationYears.isNotEmpty) {
      if (educationItems.isNotEmpty) educationItems.add(const SizedBox(height: 16));
      educationItems.addAll([
        _buildSubsectionTitle('Graduation Years'),
        const SizedBox(height: 8),
        _buildChipGrid(job.allowedGraduationYears, const Color(0xFF86EFAC)), // Light green
      ]);
    }

    if (educationItems.isEmpty) return const SizedBox.shrink();

    return _buildSectionCard(
      'Education Requirements',
      Icons.school_rounded,
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: educationItems),
    );
  }

  Widget _buildSkillsCard() {
    final skillSections = <Widget>[];
    
    if (job.hardSkills.isNotEmpty) {
      skillSections.addAll([
        _buildSkillSubsection('Technical Skills', job.hardSkills, Icons.build_rounded, const Color(0xFFA5B4FC)), // Light blue
      ]);
    }
    
    if (job.softSkills.isNotEmpty) {
      if (skillSections.isNotEmpty) skillSections.add(const SizedBox(height: 20));
      skillSections.addAll([
        _buildSkillSubsection('Soft Skills', job.softSkills, Icons.people_rounded, const Color(0xFF86EFAC)), // Light green
      ]);
    }
    
    if (job.requiredSpokenLanguages.isNotEmpty) {
      if (skillSections.isNotEmpty) skillSections.add(const SizedBox(height: 20));
      skillSections.addAll([
        _buildSkillSubsection('Languages', job.requiredSpokenLanguages, Icons.language_rounded, const Color(0xFF7DD3FC)), // Light cyan
      ]);
    }
    
    if (job.niceToHaves.isNotEmpty) {
      if (skillSections.isNotEmpty) skillSections.add(const SizedBox(height: 20));
      skillSections.addAll([
        _buildSkillSubsection('Nice-to-Have', job.niceToHaves, Icons.star_rounded, const Color(0xFFFBBF24)), // Golden yellow
      ]);
    }

    if (skillSections.isEmpty) return const SizedBox.shrink();

    return _buildSectionCard(
      'Skills & Qualifications',
      Icons.psychology_rounded,
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: skillSections),
    );
  }

  Widget _buildSkillSubsection(String title, List<String> skills, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color.withAlpha(180)),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildChipGrid(skills, color),
      ],
    );
  }

  Widget _buildDescriptionCard() {
    if (job.description.isEmpty) return const SizedBox.shrink();
    
    return _buildSectionCard(
      'Job Description',
      Icons.description_rounded,
      Text(
        job.description,
        style: const TextStyle(
          color: Color(0xFF374151),
          height: 1.6,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildRequirementsCard() {
    return _buildSectionCard(
      'Requirements',
      Icons.checklist_rounded,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: job.requirements.map((req) => 
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6366F1),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    req,
                    style: const TextStyle(
                      color: Color(0xFF374151),
                      height: 1.5,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).toList(),
      ),
    );
  }

  Widget _buildMatchScoreCard() {
    if (job.matchScore == null) return const SizedBox.shrink();
    
    final score = job.matchScore! * 100;
    final color = _getMatchScoreColor(job.matchScore!);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withAlpha(26), color.withAlpha(13)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(51)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.star_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Match Score',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getMatchScoreDescription(score),
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${score.round()}%',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withAlpha(77),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => _launchJobUrl(job.url),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Apply Now',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, Widget content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 15,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF6366F1), size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildDetailRow(_DetailItem detail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(detail.icon, size: 18, color: const Color(0xFF6B7280)),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              detail.label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF374151),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              detail.value,
              style: const TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubsectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1F2937),
      ),
    );
  }

  Widget _buildChipGrid(List<String> items, Color color) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) => 
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: color.withAlpha(51),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            item,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ).toList(),
    );
  }

  String _formatDeadline(JobDeadline deadline) {
    // Handle empty or invalid dates
    if (deadline.month.isEmpty || deadline.day.isEmpty) {
      return 'Not specified';
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
        return 'Expired';
      } else if (difference == 0) {
        return 'Today';
      } else if (difference == 1) {
        return 'Tomorrow';
      } else if (difference < 7) {
        return 'In $difference days';
      } else {
        // Format as Month Day
        final monthNames = [
          '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        return '${monthNames[month]} $day';
      }
    } catch (e) {
      return 'Invalid date';
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

  Color _getMatchScoreColor(double score) {
    if (score >= 0.8) return const Color(0xFF22C55E);
    if (score >= 0.6) return const Color(0xFF3B82F6);
    if (score >= 0.4) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  String _getMatchScoreDescription(double score) {
    if (score >= 80) return 'Excellent match for your profile';
    if (score >= 60) return 'Good match for your skills';
    if (score >= 40) return 'Moderate match with some gaps';
    return 'Limited match with your profile';
  }

  void _launchJobUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $urlString');
    }
  }
}

class _DetailItem {
  final IconData icon;
  final String label;
  final String value;

  _DetailItem(this.icon, this.label, this.value);
}