import 'package:flutter/material.dart';
import 'dart:math';

class JobCardData {
  final String title;
  final String company;
  final String location;
  final String duration;
  final String education;
  final String jobType;
  final String salary;
  final String languages;
  final String experience;

  JobCardData({
    required this.title,
    required this.company,
    required this.location,
    required this.duration,
    required this.education,
    required this.jobType,
    required this.salary,
    required this.languages,
    required this.experience,
  });
}

class JobCard extends StatefulWidget {
  final JobCardData jobData;

  const JobCard({super.key, required this.jobData});

  @override
  _JobCardState createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> with SingleTickerProviderStateMixin {
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
                  transform: Matrix4.rotationY(pi), // Fix mirrored text
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
      child: Center(
        child: Text(
          "More details coming soon...",
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(31, 45, 42, 1),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
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
const _headerStyle = TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500);
