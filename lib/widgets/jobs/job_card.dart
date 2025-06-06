import 'package:flutter/material.dart';
import 'dart:math';
import 'package:youllgetit_flutter/models/job_card/job_card_model.dart';
import 'package:youllgetit_flutter/models/job_card/job_deadline_model.dart';

class JobCard extends StatefulWidget {
  final JobCardModel jobData;
  final double percentThresholdx;

  const JobCard({super.key, required this.jobData, required this.percentThresholdx});

  @override
  JobCardState createState() => JobCardState();
}

class JobCardState extends State<JobCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
    );
  }

  void _flipCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  void _resetFlipState() {
    if (!_isFront) {
      _controller.reverse();
      _isFront = true;
    }
  }

  @override
  void didUpdateWidget(covariant JobCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _resetFlipState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(_animation.value);
            
          if (_animation.value <= pi / 2) {
            return Transform(
              alignment: Alignment.center,
              transform: transform,
              child: Stack(
                children: [
                  _buildFront(),
                  if (widget.percentThresholdx != 0)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: LinearGradient(
                            colors: widget.percentThresholdx > 0 
                                ? [const Color(0xFF86EFAC).withAlpha(0), const Color(0xFF86EFAC).withAlpha(min(102, (widget.percentThresholdx / 100 * 102).round()))]
                                : [const Color(0xFFFCA5A5).withAlpha(min(102, (-widget.percentThresholdx / 100 * 102).round())), const Color(0xFFFCA5A5).withAlpha(0)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: Center(
                          child: widget.percentThresholdx > 0
                              ? Icon(Icons.check_circle_rounded, 
                                  color: const Color(0xFF22C55E), 
                                  size: min(80, widget.percentThresholdx * 0.8))
                              : Icon(Icons.cancel_rounded, 
                                  color: const Color(0xFFEF4444), 
                                  size: min(80, -widget.percentThresholdx * 0.8)),
                        ),
                      ),
                    ),
                ],
              ),
            );
          } else {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(pi)
                ..rotateY(_animation.value),
              child: _buildBack(),
            );
          }
        },
      ),
    );
  }

  Widget _buildFront() {
    return _buildCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section with match score
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.jobData.roleName, style: _titleStyle),
                          const SizedBox(height: 4),
                          Text(widget.jobData.companyName, style: _subtitleStyle),
                        ],
                      ),
                    ),
                    // if (widget.jobData.matchScore != null)
                    //   Container(
                    //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    //     decoration: BoxDecoration(
                    //       color: _getMatchScoreColor(widget.jobData.matchScore!),
                    //       borderRadius: BorderRadius.circular(20),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: _getMatchScoreColor(widget.jobData.matchScore!).withAlpha(77),
                    //           blurRadius: 4,
                    //           offset: const Offset(0, 2),
                    //         ),
                    //       ],
                    //     ),
                    //     child: Text(
                    //       '${(widget.jobData.matchScore! * 100).round()}%',
                    //       style: const TextStyle(
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 12,
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Location and deadline
                if (widget.jobData.jobLocation.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(Icons.location_on_rounded, color: const Color(0xFF6B7280), size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.jobData.jobLocation.map((loc) => '${loc.jobCity}, ${loc.jobCountry}').join(' • '),
                            style: _infoStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                if (widget.jobData.deadline != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Icon(Icons.schedule_rounded, color: const Color(0xFF6B7280), size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Deadline: ${_formatDeadline(widget.jobData.deadline!)}',
                          style: _infoStyle.copyWith(
                            color: _isDeadlineSoon(widget.jobData.deadline!) ? const Color(0xFFEF4444) : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                const Divider(height: 24, thickness: 1),
                
                // Job Details
                const Text("Job Details", style: _sectionStyle),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildChipWithIcon(
                      widget.jobData.workMode.isEmpty ? "N/A" : widget.jobData.workMode,
                      Icons.work_rounded,
                      const Color(0xFFA5B4FC), // Light blue
                      const Color(0xFF1F2937),
                    ),
                    _buildChipWithIcon(
                      widget.jobData.expectedSalary.isEmpty ? "N/A" : widget.jobData.expectedSalary,
                      Icons.attach_money_rounded,
                      const Color(0xFFFBBF24), // Golden yellow
                      const Color(0xFF1F2937),
                    ),
                    _buildChipWithIcon(
                      '${widget.jobData.durationInMonths} months',
                      Icons.timer_rounded,
                      const Color(0xFF86EFAC), // Light green
                      const Color(0xFF1F2937),
                    ),
                    if (widget.jobData.internshipSeason.isNotEmpty)
                      _buildChipWithIcon(
                        widget.jobData.internshipSeason,
                        Icons.calendar_today_rounded,
                        const Color(0xFF86EFAC), // Light green for season
                        const Color(0xFF1F2937),
                      ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Education Requirements
                if (widget.jobData.requiredDegree.isNotEmpty) ...[
                  const Text("Education Requirements", style: _sectionStyle),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: widget.jobData.requiredDegree.map((degree) => 
                      _buildSimpleChip(degree, const Color(0xFFE879F9), const Color(0xFF1F2937)) // Light purple
                    ).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Languages
                if (widget.jobData.requiredSpokenLanguages.isNotEmpty) ...[
                  const Text("Required Languages", style: _sectionStyle),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: widget.jobData.requiredSpokenLanguages.map((lang) => 
                      _buildChipWithIcon(lang, Icons.language_rounded, const Color(0xFF7DD3FC), const Color(0xFF1F2937)) // Light cyan
                    ).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Visa Help
                if (widget.jobData.visaHelp.isNotEmpty) ...[
                  const Text("Visa Support", style: _sectionStyle),
                  const SizedBox(height: 8),
                  _buildChipWithIcon(
                    widget.jobData.visaHelp,
                    Icons.flight_rounded,
                    widget.jobData.visaHelp != "Not found"? const Color(0xFF86EFAC) : const Color(0xFFFCA5A5),
                    const Color(0xFF1F2937),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Related Fields
                if (widget.jobData.relatedFields.isNotEmpty) ...[
                  const Text("Related Fields", style: _sectionStyle),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: widget.jobData.relatedFields.map((field) => 
                      _buildSimpleChip(field, const Color(0xFFD1D5DB), const Color(0xFF1F2937)) // Light gray
                    ).toList(),
                  ),
                ],
                
                // Flip indicator
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.flip_rounded, size: 16, color: const Color(0xFF6B7280)),
                        const SizedBox(width: 4),
                        Text(
                          'Tap to see skills',
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildBack() {
    return _buildCard(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.psychology_rounded, color: const Color(0xFF374151), size: 24),
                const SizedBox(width: 8),
                const Text("Skills & Requirements", style: _headerStyle),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Hard Skills
            Row(
              children: [
                Icon(Icons.build_rounded, color: const Color(0xFF6366F1), size: 20),
                const SizedBox(width: 8),
                const Text("Technical Skills", style: _skillHeaderStyle),
              ],
            ),
            const SizedBox(height: 8),
            _buildWrappedChips(
              widget.jobData.hardSkills.isEmpty ? ["N/A"] : widget.jobData.hardSkills,
              const Color(0xFFA5B4FC),
              const Color(0xFF1F2937),
            ),
            
            const SizedBox(height: 20),
            
            // Soft Skills
            Row(
              children: [
                Icon(Icons.people_rounded, color: const Color(0xFF22C55E), size: 20),
                const SizedBox(width: 8),
                const Text("Soft Skills", style: _skillHeaderStyle),
              ],
            ),
            const SizedBox(height: 8),
            _buildWrappedChips(
              widget.jobData.softSkills.isEmpty ? ["N/A"] : widget.jobData.softSkills,
              const Color(0xFF86EFAC),
              const Color(0xFF1F2937),
            ),
            
            const SizedBox(height: 20),
            
            // Nice-to-Haves
            Row(
              children: [
                Icon(Icons.star_rounded, color: const Color(0xFFF59E0B), size: 20),
                const SizedBox(width: 8),
                const Text("Nice-to-Have", style: _skillHeaderStyle),
              ],
            ),
            const SizedBox(height: 8),
            _buildWrappedChips(
              widget.jobData.niceToHaves.isEmpty ? ["N/A"] : widget.jobData.niceToHaves,
              const Color(0xFFFBBF24),
              const Color(0xFF1F2937),
            ),
            
            // Requirements section
            // if (widget.jobData.requirements.isNotEmpty) ...[
            //   const SizedBox(height: 20),
            //   Row(
            //     children: [
            //       Icon(Icons.checklist_rounded, color: const Color(0xFF8B5CF6), size: 20),
            //       const SizedBox(width: 8),
            //       const Text("Requirements", style: _skillHeaderStyle),
            //     ],
            //   ),
            //   const SizedBox(height: 8),
            //   _buildWrappedChips(
            //     widget.jobData.requirements,
            //     const Color(0xFFE879F9),
            //     const Color(0xFF1F2937),
            //   ),
            // ],
            
            // Back flip indicator
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.flip_rounded, size: 16, color: const Color(0xFF6B7280)),
                    const SizedBox(width: 4),
                    Text(
                      'Tap to see details',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
      
      // Simple format without relative dates for now
      final monthNames = [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${monthNames[month]} $day';
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

  // Color _getMatchScoreColor(double score) {
  //   if (score >= 0.8) return const Color(0xFF22C55E);
  //   if (score >= 0.6) return const Color(0xFF3B82F6);
  //   if (score >= 0.4) return const Color(0xFFF59E0B);
  //   return const Color(0xFFEF4444);
  // }

  Color _calculateGlowColor(double threshold) {
    const Color positiveGlowBase = Color(0xFF86EFAC);
    const Color negativeGlowBase = Color(0xFFFCA5A5);
    const Color neutralColor = Colors.transparent;
    
    double absThreshold = threshold.abs();
    double normalizedIntensity = min(1.0, absThreshold / 100);
    double curvedIntensity = normalizedIntensity * normalizedIntensity * 0.5;
    
    Color baseColor = threshold > 0 ? positiveGlowBase : negativeGlowBase;
    return Color.lerp(neutralColor, baseColor, curvedIntensity) ?? neutralColor;
  }

  Widget _buildCard({required Widget child}) {
    double threshold = widget.percentThresholdx;
    bool shouldApplyEffect = threshold != 0;
    Color glowColor = _calculateGlowColor(threshold);
    double borderWidth = shouldApplyEffect ? 2.0 : 0.0;
    double spreadRadius = shouldApplyEffect ? 1.0 + (threshold.abs() / 100 * 2.0) : 0;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF9E6), // Warm cream background
            Color(0xFFFEF3C7), // Slightly more yellow
          ],
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          if (shouldApplyEffect)
            BoxShadow(
              color: glowColor.withAlpha(77),
              spreadRadius: spreadRadius,
              blurRadius: 10,
            ),
        ],
        border: shouldApplyEffect 
            ? Border.all(color: glowColor, width: borderWidth)
            : Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      padding: const EdgeInsets.all(20.0),
      child: child,
    );
  }

  Widget _buildWrappedChips(List<String> items, Color chipColor, Color textColor) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) => 
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: chipColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: chipColor.withAlpha(51),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            item,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ).toList(),
    );
  }

  Widget _buildChipWithIcon(String label, IconData icon, Color chipColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: chipColor.withAlpha(51),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 16),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleChip(String label, Color chipColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: chipColor.withAlpha(51),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
}

// Updated text styles with better hierarchy
const _titleStyle = TextStyle(
  color: Color(0xFF1F2937),
  fontSize: 22,
  fontWeight: FontWeight.bold,
  letterSpacing: 0.3,
  height: 1.2,
);

const _subtitleStyle = TextStyle(
  color: Color(0xFF374151),
  fontSize: 16,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.1,
);

const _infoStyle = TextStyle(
  color: Color(0xFF6B7280),
  fontSize: 13,
  fontWeight: FontWeight.w500,
);

const _headerStyle = TextStyle(
  color: Color(0xFF1F2937),
  fontSize: 18,
  fontWeight: FontWeight.bold,
  letterSpacing: 0.2,
);

const _sectionStyle = TextStyle(
  color: Color(0xFF374151),
  fontSize: 14,
  fontWeight: FontWeight.bold,
  letterSpacing: 0.2,
);

const _skillHeaderStyle = TextStyle(
  color: Color(0xFF1F2937),
  fontSize: 15,
  fontWeight: FontWeight.bold,
  letterSpacing: 0.1,
);