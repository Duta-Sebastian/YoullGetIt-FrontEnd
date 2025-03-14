import 'package:flutter/material.dart';

class JobOptionItem extends StatelessWidget {
  final dynamic jobOption;
  final ValueChanged<bool?> onChanged;

  const JobOptionItem({
    Key? key,
    required this.jobOption,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.2,
            child: SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                shape: const CircleBorder(),
                value: jobOption.isSelected,
                onChanged: onChanged,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${jobOption.title} ",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "/ ${jobOption.company}",
                    style: const TextStyle(
                      fontSize: 16,
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
}