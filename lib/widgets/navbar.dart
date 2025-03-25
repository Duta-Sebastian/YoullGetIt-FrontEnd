import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentPageIndex;
  final ValueChanged<int> onPageChanged;
  final List<Widget> pages;

  const BottomNavBar({
    super.key, 
    required this.currentPageIndex,
    required this.onPageChanged,
    required this.pages,
  });

  ClipRRect buildMyNavBar(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, Icons.loop, 0),
            _buildNavItem(context, Icons.bookmark, 1),
            _buildNavItem(context, Icons.widgets_rounded, 2),
            _buildNavItem(context, Icons.person, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, int index) {
    final bool isSelected = currentPageIndex == index;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: IconButton(
        enableFeedback: false,
        onPressed: () {
          onPageChanged(index);
        },
        icon: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            icon,
            color: Colors.white,
            size: isSelected ? 46 : 32,
          ),
        ),
        padding: EdgeInsets.all(isSelected ? 8 : 12),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildMyNavBar(context);
  }
}