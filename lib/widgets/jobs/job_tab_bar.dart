import 'package:flutter/material.dart';

class JobTabBar extends StatelessWidget {
  final ValueChanged<int> onTabSelected;
  final int selectedIndex;

  const JobTabBar({
    super.key,
    required this.onTabSelected,
    required this.selectedIndex
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          _buildTab(0, 'Liked'),
          _buildTab(1, 'To Apply'),
          _buildTab(2, 'Applied'),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String label) {
    final bool isSelected = index == selectedIndex;

    return Expanded(
      child: InkWell(
        onTap: () => onTabSelected(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 2),
            if (isSelected)
              const Divider(
                height: 2,
                thickness: 2,
                color: Colors.black,
              ),
          ],
        ),
      ),
    );
  }
}