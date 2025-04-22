import 'package:flutter/material.dart';
import 'dart:math';
import 'package:youllgetit_flutter/models/job_card_model.dart';

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
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: pi).animate(_controller);
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
          // Using a slightly higher perspective value to fix the black line
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.002) // Adjusted from 0.001 to 0.002
            ..rotateY(_animation.value);
            
          if (_animation.value <= pi / 2) {
            // Front side
            return Transform(
              alignment: Alignment.center,
              transform: transform,
              child: Stack(
                children: [
                  _buildFront(),
                  // Only add overlay when there's a threshold value
                  if (widget.percentThresholdx != 0)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          gradient: LinearGradient(
                            colors: widget.percentThresholdx > 0 
                                ? [Colors.green.withOpacity(0), Colors.green.withOpacity(min(0.5, widget.percentThresholdx / 100))]
                                : [Colors.red.withOpacity(min(0.5, -widget.percentThresholdx / 100)), Colors.red.withOpacity(0)],
                            begin: widget.percentThresholdx > 0 ? Alignment.centerLeft : Alignment.centerLeft,
                            end: widget.percentThresholdx > 0 ? Alignment.centerRight : Alignment.centerRight,
                          ),
                        ),
                        child: Center(
                          child: widget.percentThresholdx > 0
                              ? Icon(Icons.check_circle, color: Colors.white, size: min(100, widget.percentThresholdx))
                              : Icon(Icons.close, color: Colors.white, size: min(100, -widget.percentThresholdx)),
                        ),
                      ),
                    ),
                ],
              ),
            );
          } else {
            // Back side - ensure we're not seeing any glitches
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.002) // Consistent perspective
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
                // Card header
                Text(widget.jobData.title, style: _titleStyle),
                Text(widget.jobData.company, style: _subtitleStyle),
                const SizedBox(height: 5),
                
                // Location
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(_getStringOrNA(widget.jobData.location), style: _infoStyle),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Job details
                const Text("Job Details", style: _sectionStyle),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.start,
                  children: [
                    _buildChipWithIcon(
                      _getStringOrNA(widget.jobData.jobType),
                      Icons.work,
                      const Color.fromRGBO(171, 196, 234, 1),
                      const Color.fromRGBO(54, 81, 121, 1)
                    ),
                    _buildChipWithIcon(
                      _getStringOrNA(widget.jobData.salary),
                      Icons.attach_money,
                      const Color.fromRGBO(255, 242, 138, 1),
                      const Color.fromRGBO(137, 126, 31, 1)
                    ),
                    _buildChipWithIcon(
                      _getStringOrNA(widget.jobData.workMode),
                      Icons.business_center,
                      const Color.fromRGBO(255, 190, 148, 1),
                      const Color.fromRGBO(134, 82, 19, 1)
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Duration and Education
                const Text("Education & Duration", style: _sectionStyle),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildChipWithIcon(
                      _getStringOrNA(widget.jobData.duration),
                      Icons.date_range,
                      const Color.fromRGBO(154, 255, 148, 1),
                      const Color.fromRGBO(51, 95, 48, 1)
                    ),
                    if (widget.jobData.education.isEmpty)
                      _buildChipWithIcon(
                        "N/A",
                        Icons.school,
                        const Color.fromRGBO(154, 255, 148, 1),
                        const Color.fromRGBO(51, 95, 48, 1)
                      )
                    else
                      ...widget.jobData.education.map((edu) => 
                        _buildChipWithIcon(
                          _getStringOrNA(edu),
                          Icons.school,
                          const Color.fromRGBO(154, 255, 148, 1),
                          const Color.fromRGBO(51, 95, 48, 1)
                        )
                      ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Languages
                const Text("Languages", style: _sectionStyle),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.start,
                  children: widget.jobData.languages.isEmpty 
                      ? [
                          _buildChipWithIcon(
                            "N/A",
                            Icons.language,
                            const Color.fromRGBO(190, 243, 255, 1),
                            const Color.fromRGBO(18, 76, 89, 1)
                          )
                        ]
                      : widget.jobData.languages.map((lang) => 
                          _buildChipWithIcon(
                            _getStringOrNA(lang),
                            Icons.language,
                            const Color.fromRGBO(190, 243, 255, 1),
                            const Color.fromRGBO(18, 76, 89, 1)
                          )
                        ).toList(),
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
            // Hard Skills
            Row(
              children: const [
                Icon(Icons.build, color: Colors.white70, size: 20),
                SizedBox(width: 8),
                Text("Hard Skills", style: _headerStyle),
              ],
            ),
            const SizedBox(height: 8),
            _buildWrappedChips(
              widget.jobData.hardSkills.isEmpty ? ["N/A"] : widget.jobData.hardSkills,
              const Color.fromRGBO(190, 243, 255, 1),
              const Color.fromRGBO(13, 107, 128, 1),
            ),
            
            const SizedBox(height: 16),
            
            // Soft Skills
            Row(
              children: const [
                Icon(Icons.psychology, color: Colors.white70, size: 20),
                SizedBox(width: 8),
                Text("Soft Skills", style: _headerStyle),
              ],
            ),
            const SizedBox(height: 8),
            _buildWrappedChips(
              widget.jobData.softSkills.isEmpty ? ["N/A"] : widget.jobData.softSkills,
              const Color.fromRGBO(255, 190, 249, 1),
              const Color.fromRGBO(108, 62, 103, 1),
            ),
            
            const SizedBox(height: 16),
            
            // Nice-to-Have
            Row(
              children: const [
                Icon(Icons.star, color: Colors.white70, size: 20),
                SizedBox(width: 8),
                Text("Nice-to-Haves", style: _headerStyle),
              ],
            ),
            const SizedBox(height: 8),
            _buildWrappedChips(
              widget.jobData.niceToHave.isEmpty ? ["N/A"] : widget.jobData.niceToHave,
              const Color.fromRGBO(129, 220, 196, 1),
              const Color.fromRGBO(7, 84, 63, 1),
            ),
          ],
        ),
      ),
    );
  }

  String _getStringOrNA(String? value) {
    if (value == null || value.isEmpty) {
      return "N/A";
    }
    return value;
  }

  Color _calculateGlowColor(double threshold) {
    const Color positiveGlowBase = Color.fromRGBO(129, 220, 196, 1);
    const Color negativeGlowBase = Color.fromRGBO(153, 34, 36, 1);
    
    const Color neutralColor = Color.fromRGBO(0, 0, 0, 0);
    
    double absThreshold = threshold.abs();
    double normalizedIntensity = min(1.0, absThreshold / 100);
    
    double curvedIntensity = normalizedIntensity * normalizedIntensity * 0.4;
    
    Color baseColor = threshold > 0 ? positiveGlowBase : negativeGlowBase;
    
    return Color.lerp(neutralColor, baseColor, curvedIntensity) ?? neutralColor;
  }

  Widget _buildCard({required Widget child}) {
    double threshold = widget.percentThresholdx;
    
    bool shouldApplyEffect = threshold != 0;
    Color glowColor = _calculateGlowColor(threshold);
    double borderWidth = shouldApplyEffect ? 2.0 : 0.0;
    double spreadRadius = shouldApplyEffect ? 0.5 + (threshold.abs() / 100 * 1.1) : 0;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(31, 45, 42, 1),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
          if (shouldApplyEffect)
            BoxShadow(
              color: glowColor,
              spreadRadius: spreadRadius,
            ),
        ],
        border: shouldApplyEffect 
            ? Border.all(color: glowColor, width: borderWidth)
            : null,
      ),
      padding: const EdgeInsets.all(16.0),
      child: child,
    );
  }

  Widget _buildWrappedChips(List<String> items, Color chipColor, Color textColor) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.start,
      children: items.map((item) => 
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: chipColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: chipColor.withAlpha((255 * 0.3).toInt()),
                blurRadius: 3,
                offset: const Offset(0, 1),
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
            overflow: TextOverflow.ellipsis,
          ),
        )
      ).toList(),
    );
  }

  Widget _buildChipWithIcon(String label, IconData icon, Color chipColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: chipColor.withAlpha((255 * 0.3).toInt()),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 14),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

const _titleStyle = TextStyle(
  color: Colors.white,
  fontSize: 20,
  fontWeight: FontWeight.bold,
  letterSpacing: 0.2,
);
const _subtitleStyle = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);
const _infoStyle = TextStyle(
  color: Colors.white,
  fontSize: 13,
  fontWeight: FontWeight.w400,
);
const _headerStyle = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.bold,
  letterSpacing: 0.2,
);
const _sectionStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.2,
);