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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(_animation.value);
          return Transform(
            alignment: Alignment.center,
            transform: transform,
            child: _animation.value <= pi / 2 ? _buildFront() : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: _buildBack(),
                ),
          );
        },
      ),
    );
  }

  Widget _buildFront() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.jobData.title, style: _titleStyle),
          Text(widget.jobData.company, style: _subtitleStyle),
          const SizedBox(height: 5),
          Text(widget.jobData.location, style: _infoStyle),
          const SizedBox(height: 16),
          _buildInfoRow([
            _buildChip(widget.jobData.duration, Color.fromRGBO(154, 255, 148, 1), Color.fromRGBO(51, 95, 48, 1)),
            _buildChip(widget.jobData.education, Color.fromRGBO(255, 190, 249, 1), Color.fromRGBO(108, 62, 103, 1)),
          ]),
          const SizedBox(height: 8),
          _buildInfoRow([
            _buildChip(widget.jobData.jobType, Color.fromRGBO(171, 196, 234, 1), Color.fromRGBO(54, 81, 121, 1)),
            _buildChip(widget.jobData.salary, Color.fromRGBO(255, 242, 138, 1), Color.fromRGBO(137, 126, 31, 1)),
            _buildChip(widget.jobData.languages, Color.fromRGBO(190, 243, 255, 1), Color.fromRGBO(18, 76, 89, 1)),
          ]),
          const SizedBox(height: 24),
          const Text("Prior Experience", style: _headerStyle),
          const SizedBox(height: 8),
          _buildChip(widget.jobData.experience, Color.fromRGBO(255, 226, 192, 1), Color.fromRGBO(134, 82, 19, 1)),
        ],
      ),
    );
  }

  Widget _buildBack() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Skills", style: _headerStyle),
          const SizedBox(height: 12),
          _buildWrappedChips(
            widget.jobData.skills,
            Color.fromRGBO(190, 243, 255, 1),
            Color.fromRGBO(13, 107, 128, 1),
          ),
          const SizedBox(height: 24),
          const Text("Nice-to-Haves", style: _headerStyle),
          const SizedBox(height: 12),
          _buildWrappedChips(
            widget.jobData.niceToHave,
            Color.fromRGBO(129, 220, 196, 1),
            Color.fromRGBO(7, 84, 63, 1),
          ),
        ],
      ),
    );
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
    
    // double blurRadius = shouldApplyEffect ? 8.0 + (threshold.abs() / 100 * 8) : 0;
    double spreadRadius = shouldApplyEffect ? 0.5 + (threshold.abs() / 100 * 1.1) : 0;

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(31, 45, 42, 1),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
          if (shouldApplyEffect)
            BoxShadow(
              color: glowColor,
              // blurRadius: blurRadius,
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

  Widget _buildInfoRow(List<Widget> children) {
    return Row(
      children: [
        for (int i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          children[i],
        ],
      ],
    );
  }

  Widget _buildWrappedChips(List<String> items, Color chipColor, Color textColor) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) => _buildChip(item, chipColor, textColor)).toList(),
    );
  }

  Widget _buildChip(String label, Color chipColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

const _titleStyle = TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold);
const _subtitleStyle = TextStyle(color: Colors.white, fontSize: 22);
const _infoStyle = TextStyle(color: Colors.white, fontSize: 14);
const _headerStyle = TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);