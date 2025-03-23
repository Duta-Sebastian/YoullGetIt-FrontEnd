import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/widgets/job_card.dart';

class JobListItem extends StatelessWidget {
  final JobCardModel job;
  final bool isSelected;
  final bool isLongPressed;
  final bool isBlurred;
  final ValueChanged<bool> onChanged;
  final VoidCallback onLongPress;
  final VoidCallback onRemove;

  const JobListItem({
    super.key,
    required this.job,
    required this.isSelected,
    required this.isLongPressed,
    required this.isBlurred,
    required this.onChanged,
    required this.onLongPress,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showJobCard(context, job),
      onLongPress: onLongPress,
      child: Stack(
        children: [
          _buildJobCard(),
          _buildSelectionIcon(),
          if (isBlurred) _buildBlurOverlay(),
          if (isLongPressed) _buildRemoveButton(),
        ],
      ),
    );
  }

  Widget _buildJobCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.green : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              job.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  job.company,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  ' ®',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionIcon() {
    return Positioned(
      right: 24,
      bottom: 16,
      child: GestureDetector(
        onTap: () => onChanged(!isSelected),
        child: Icon(
          Icons.check,
          color: isSelected ? Colors.green : Colors.grey,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildBlurOverlay() {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.2 * 255).toInt()),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRemoveButton() {
    return Positioned(
      right: 26,
      bottom: 18,
      child: ElevatedButton.icon(
        onPressed: onRemove,
        icon: const Icon(Icons.delete_outline, size: 18),
        label: const Text('Remove'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade400,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  void _showJobCard(BuildContext context, JobCardModel job) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              JobCard(jobData: job, percentThresholdx: 0),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}