import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/models/job_card/job_card_model.dart';
import 'package:youllgetit_flutter/models/job_card/job_deadline_model.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailPage extends StatelessWidget {
  final JobCardModel job;

  const JobDetailPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          localizations.jobDetails,
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1F2937)),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new_rounded),
            onPressed: () => _launchJobUrl(job.url),
            tooltip: localizations.openInBrowser,
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
              child: _buildHeader(context),
            ),
            
            // Content Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildJobDetailsCard(context),
                  const SizedBox(height: 16),
                  _buildEducationCard(context),
                  const SizedBox(height: 16),
                  _buildSkillsCard(context),
                  const SizedBox(height: 16),
                  _buildDescriptionCard(context),
                  const SizedBox(height: 16),
                  if (job.requirements.isNotEmpty && !_isNotFound(job.requirements))
                    _buildRequirementsCard(context),
                  if (job.requirements.isNotEmpty && !_isNotFound(job.requirements))
                    const SizedBox(height: 16),
                  _buildApplyButton(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
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
                      const Icon(
                        Icons.business_rounded,
                        size: 18,
                        color: Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          job.companyName,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF374151),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        
        if (job.jobLocation.isNotEmpty || job.deadline != null) ...[
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          
          // Location and Deadline
          if (job.jobLocation.isNotEmpty && !_isLocationNotFound(job.jobLocation))
            _buildHeaderInfoRow(
              Icons.location_on_rounded,
              localizations.location,
              job.jobLocation.map((loc) => '${loc.jobCity}, ${loc.jobCountry}').join(' • '),
            ),
          
          if (job.deadline != null)
            _buildHeaderInfoRow(
              Icons.schedule_rounded,
              localizations.deadline,
              _formatDeadline(job.deadline!, context),
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
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
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

  Widget _buildJobDetailsCard(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    debugPrint(job.internshipSeason);
    final details = [
      if (job.workMode.isNotEmpty && !_isNotFoundString(job.workMode)) 
        _DetailItem(Icons.work_rounded, localizations.workMode, job.workMode),
      if (job.expectedSalary.isNotEmpty && !_isNotFoundString(job.expectedSalary))
        _DetailItem(Icons.payments_rounded, localizations.salary, job.expectedSalary),
      if (job.durationInMonths > 0)
        _DetailItem(Icons.timer_rounded, localizations.duration, localizations.monthsCount(job.durationInMonths.toInt())),
      if (job.timeSpent.isNotEmpty && !_isNotFoundString(job.timeSpent))
        _DetailItem(Icons.schedule_rounded, localizations.timeCommitment, job.timeSpent),
      if (job.internshipSeason.isNotEmpty && !_isNotFoundString(job.internshipSeason))
        _DetailItem(Icons.calendar_today_rounded, localizations.season, job.internshipSeason),
      if (job.visaHelp.isNotEmpty && !_isNotFoundString(job.visaHelp))
        _DetailItem(Icons.flight_rounded, localizations.visaHelp, job.visaHelp),
    ];

    if (details.isEmpty) return const SizedBox.shrink();

    return _buildSectionCard(
      localizations.jobDetailsTitle,
      Icons.info_rounded,
      Column(
        children: details.map((detail) => _buildDetailRow(detail)).toList(),
      ),
    );
  }

  Widget _buildEducationCard(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final educationItems = <Widget>[];

    debugPrint('Required degrees is not empty: ${job.requiredDegree.isNotEmpty}');
    if (job.requiredDegree.isNotEmpty && !_isNotFound(job.requiredDegree)) {
      // Filter out "Not Found" values and localize the required degrees
      final filteredDegrees = job.requiredDegree
          .where((degree) => !_isNotFoundString(degree))
          .toList();
      
      if (filteredDegrees.isNotEmpty) {
        final localizedDegrees = filteredDegrees
            .map((degree) => _localizeEducation(degree, localizations))
            .toList();
        
        educationItems.addAll([
          _buildSubsectionTitle(localizations.requiredDegree),
          const SizedBox(height: 8),
          _buildChipGrid(localizedDegrees, const Color(0xFFE879F9)),
        ]);
      }
    }
    
    debugPrint('Allowed graduation years: ${job.allowedGraduationYears}');
    if (job.allowedGraduationYears.isNotEmpty && !_isNotFound(job.allowedGraduationYears)) {
      // Filter out "Not Found" values
      final filteredYears = job.allowedGraduationYears
          .where((year) => !_isNotFoundString(year))
          .toList();
      
      if (filteredYears.isNotEmpty) {
        if (educationItems.isNotEmpty) educationItems.add(const SizedBox(height: 16));
        educationItems.addAll([
          _buildSubsectionTitle(localizations.graduationYears),
          const SizedBox(height: 8),
          _buildChipGrid(filteredYears, const Color(0xFF86EFAC)),
        ]);
      }
    }

    if (educationItems.isEmpty) return const SizedBox.shrink();

    return _buildSectionCard(
      localizations.educationRequirements,
      Icons.school_rounded,
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: educationItems),
    );
  }

  Widget _buildSkillsCard(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final skillSections = <Widget>[];
    
    if (job.hardSkills.isNotEmpty && !_isNotFound(job.hardSkills)) {
      final filteredHardSkills = job.hardSkills
          .where((skill) => !_isNotFoundString(skill))
          .toList();
      
      if (filteredHardSkills.isNotEmpty) {
        skillSections.addAll([
          _buildSkillSubsection(localizations.technicalSkills, filteredHardSkills, Icons.build_rounded, const Color(0xFFA5B4FC)),
        ]);
      }
    }
    
    if (job.softSkills.isNotEmpty && !_isNotFound(job.softSkills)) {
      final filteredSoftSkills = job.softSkills
          .where((skill) => !_isNotFoundString(skill))
          .toList();
      
      if (filteredSoftSkills.isNotEmpty) {
        if (skillSections.isNotEmpty) skillSections.add(const SizedBox(height: 20));
        skillSections.addAll([
          _buildSkillSubsection(localizations.softSkills, filteredSoftSkills, Icons.people_rounded, const Color(0xFF86EFAC)),
        ]);
      }
    }
    
    if (job.requiredSpokenLanguages.isNotEmpty && !_isNotFound(job.requiredSpokenLanguages)) {
      final filteredLanguages = job.requiredSpokenLanguages
          .where((lang) => !_isNotFoundString(lang))
          .toList();
      
      if (filteredLanguages.isNotEmpty) {
        if (skillSections.isNotEmpty) skillSections.add(const SizedBox(height: 20));
        skillSections.addAll([
          _buildSkillSubsection(localizations.languages, filteredLanguages, Icons.language_rounded, const Color(0xFF7DD3FC)),
        ]);
      }
    }
    
    if (job.niceToHaves.isNotEmpty && !_isNotFound(job.niceToHaves)) {
      final filteredNiceToHaves = job.niceToHaves
          .where((item) => !_isNotFoundString(item))
          .toList();
      
      if (filteredNiceToHaves.isNotEmpty) {
        if (skillSections.isNotEmpty) skillSections.add(const SizedBox(height: 20));
        skillSections.addAll([
          _buildSkillSubsection(localizations.niceToHave, filteredNiceToHaves, Icons.star_rounded, const Color(0xFFFBBF24)),
        ]);
      }
    }

    if (skillSections.isEmpty) return const SizedBox.shrink();

    return _buildSectionCard(
      localizations.skillsAndQualifications,
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
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildChipGrid(skills, color),
      ],
    );
  }

  Widget _buildDescriptionCard(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    if (job.description.isEmpty || _isNotFoundString(job.description)) return const SizedBox.shrink();
    
    return _buildSectionCard(
      localizations.jobDescription,
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

  Widget _buildRequirementsCard(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    // Filter out "Not Found" requirements
    final filteredRequirements = job.requirements
        .where((req) => !_isNotFoundString(req))
        .toList();
    
    if (filteredRequirements.isEmpty) return const SizedBox.shrink();
    
    return _buildSectionCard(
      localizations.requirements,
      Icons.checklist_rounded,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: filteredRequirements.map((req) => 
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

  Widget _buildApplyButton(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              localizations.applyNow,
              style: const TextStyle(
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
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
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

  String _formatDeadline(JobDeadline deadline, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    // Handle empty or invalid dates
    if (deadline.month.isEmpty || deadline.day.isEmpty) {
      return localizations.notSpecified;
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
        return localizations.expired;
      } else if (difference == 0) {
        return localizations.today;
      } else if (difference == 1) {
        return localizations.tomorrow;
      } else if (difference < 7) {
        return localizations.inDays(difference);
      } else {
        // Format as Month Day using localized month names
        return localizations.monthDay(month.toString(), day.toString());
      }
    } catch (e) {
      return localizations.invalidDate;
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

  void _launchJobUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $urlString');
    }
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

  // Helper methods to check for "Not Found" values
  bool _isNotFoundString(String value) {
    return value.toLowerCase().trim() == 'not found';
  }

  bool _isNotFound(List<String> values) {
    return values.isEmpty || 
           values.length == 1 && _isNotFoundString(values.first) ||
           values.every((value) => _isNotFoundString(value));
  }

  bool _isLocationNotFound(List<dynamic> locations) {
    if (locations.isEmpty) return true;
    
    for (var location in locations) {
      // Check if location has jobCity and jobCountry properties
      if (location.jobCity != null && location.jobCountry != null) {
        if (!_isNotFoundString(location.jobCity) && !_isNotFoundString(location.jobCountry)) {
          return false; // Found at least one valid location
        }
      }
    }
    return true; // All locations are "Not Found" or invalid
  }
}

class _DetailItem {
  final IconData icon;
  final String label;
  final String value;

  _DetailItem(this.icon, this.label, this.value);
}