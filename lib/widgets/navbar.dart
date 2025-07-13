import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/providers/navbar_animation_provider.dart';

class BottomNavBar extends ConsumerWidget {
  final int currentPageIndex;
  final ValueChanged<int> onPageChanged;
  final List<Widget> pages;

  const BottomNavBar({
    super.key, 
    required this.currentPageIndex,
    required this.onPageChanged,
    required this.pages,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationState = ref.watch(bookmarkAnimationProvider);
    final primaryColor = const Color.fromRGBO(121, 85, 72, 1);
    final localizations = AppLocalizations.of(context)!;
    
    return Container(
      height: 85, // Increased height to accommodate labels
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            context, 
            Icons.loop, 
            'Swipe', 
            0, 
            false, 
            0, 
            primaryColor
          ),
          _buildNavItem(
            context, 
            Icons.search, 
            localizations.search, 
            1, 
            false, 
            0, 
            primaryColor
          ),
          _buildNavItem(
            context, 
            Icons.bookmark, 
            localizations.saved, 
            2, 
            animationState.isAnimating, 
            animationState.progress,
            primaryColor
          ),
          _buildNavItem(
            context, 
            Icons.person, 
            localizations.profile, 
            3, 
            false, 
            0, 
            primaryColor
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, 
    IconData icon, 
    String label,
    int index, 
    bool isAnimating,
    double progress,
    Color themeColor
  ) {
    final bool isSelected = currentPageIndex == index;
    final Color iconColor = isSelected ? themeColor : const Color.fromRGBO(188, 170, 148, 1);
    final Color labelColor = isSelected ? themeColor : const Color.fromRGBO(188, 170, 148, 1);
    
    return GestureDetector(
      onTap: () => onPageChanged(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isAnimating && index == 2
                ? _buildSmoothAnimation(icon, iconColor, themeColor, progress)
                : Icon(
                    icon,
                    color: iconColor,
                    size: 28,
                  ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: labelColor,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSmoothAnimation(
    IconData icon, 
    Color baseColor, 
    Color themeColor,
    double progress
  ) {
    final double scaleValue;
    if (progress < 0.5) {
      scaleValue = progress * 2; 
    } else {
      scaleValue = (1.0 - progress) * 2;
    }
    
    final double smoothScale = 1.0 + (0.2 * sin(scaleValue * 3.14159));
    
    return Transform.scale(
      scale: smoothScale,
      child: Icon(
        icon,
        color: Color.lerp(baseColor, themeColor, progress < 0.5 
                    ? progress * 2
                    : 1.0 - (progress - 0.5) * 2),
        size: 28,
      ),
    );
  }
}