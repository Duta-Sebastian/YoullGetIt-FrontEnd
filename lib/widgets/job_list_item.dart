import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';

class JobListItem extends StatelessWidget {
  final JobCardModel job;
  final bool isSelected;
  final bool isLongPressed;
  final bool isBlurred;
  final ValueChanged<bool?> onChanged;
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
      onTap: () => onChanged(!isSelected),
      onLongPress: onLongPress,
      child: Stack(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isSelected ? Colors.green : Colors.grey.shade200,
                width: isSelected ? 2 : 1,
              ),
            ),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              '®',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),                        
                      ],
                    ),
                  ),
                  Icon(
                    Icons.check,
                    color: isSelected ? Colors.green : Colors.green.withOpacity(0.5),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          
          if (isBlurred)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            

          if (isLongPressed)
            Positioned(
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
            ),
        ],
      ),
    );
  }
}