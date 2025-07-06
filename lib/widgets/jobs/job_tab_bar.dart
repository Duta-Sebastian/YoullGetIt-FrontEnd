import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';

class JobTabBar extends StatefulWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;

  const JobTabBar({
    super.key,
    required this.onTabSelected,
    required this.selectedIndex,
  });

  @override
  State<JobTabBar> createState() => _JobTabBarState();
}

class _JobTabBarState extends State<JobTabBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.selectedIndex,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        widget.onTabSelected(_tabController.index);
      }
    });
  }

  @override
  void didUpdateWidget(JobTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != _tabController.index) {
      _tabController.animateTo(widget.selectedIndex);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade600,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        splashBorderRadius: BorderRadius.circular(16),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getTabColor(widget.selectedIndex),
          boxShadow: [
            BoxShadow(
              color: _getTabColor(widget.selectedIndex).withAlpha((255 * 0.3).round()),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: [
          _buildTab(0, Icons.thumb_up_outlined, l10n.jobCartTabLiked),
          _buildTab(1, Icons.edit_document, l10n.jobCartTabToApply),
          _buildTab(2, Icons.check_circle_outline, l10n.jobCartTabApplied),
        ],
      ),
    );
  }

  Widget _buildTab(int index, IconData icon, String label) {
    final isSelected = widget.selectedIndex == index;
    
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: isSelected ? 18 : 16,
          ),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }

  Color _getTabColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}