import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChecklistCard extends StatefulWidget {
  const ChecklistCard({super.key});

  @override
  State<ChecklistCard> createState() => _ChecklistCardState();
}

class _ChecklistCardState extends State<ChecklistCard> with SingleTickerProviderStateMixin {
  static const String _minimizedKey = 'checklist_card_minimized';
  bool _isMinimized = true;
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _sizeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    
    
    
    _loadMinimizedState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadMinimizedState() async {
    final prefs = await SharedPreferences.getInstance();
    final isMinimized = prefs.getBool(_minimizedKey) ?? false;
    if (mounted) {
      setState(() {
        _isMinimized = isMinimized;
        if (_isMinimized) {
          _controller.value = 1.0;
        }
      });
    }
  }

  Future<void> _toggleMinimized() async {
    if (_isMinimized) {
      await _controller.reverse();
    } else {
      await _controller.forward();
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_minimizedKey, !_isMinimized);
    
    if (mounted) {
      setState(() {
        _isMinimized = !_isMinimized;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber.shade50,
            Colors.amber.shade100,
          ],
        ),
        borderRadius: BorderRadius.circular(_isMinimized ? 12 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withAlpha((255 * 0.2).round()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isMinimized ? _toggleMinimized : null,
          borderRadius: BorderRadius.circular(_isMinimized ? 12 : 20),
          child: Padding(
            padding: EdgeInsets.all(_isMinimized ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (always visible)
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(_isMinimized ? 6 : 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(_isMinimized ? 8 : 12),
                      ),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: Colors.amber.shade600,
                        size: _isMinimized ? 16 : 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isMinimized ? 'Tap to learn how your Job Cart works' : 'How Your Job Cart Works',
                        style: TextStyle(
                          fontSize: _isMinimized ? 14 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: RotationTransition(
                        turns: _rotationAnimation,
                        child: Icon(
                          _isMinimized ? Icons.expand_more : Icons.close,
                          color: Colors.amber.shade700,
                          size: _isMinimized ? 18 : 20,
                        ),
                      ),
                      onPressed: _toggleMinimized,
                      tooltip: _isMinimized ? 'Expand' : 'Minimize',
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: _isMinimized ? 28 : 32,
                        minHeight: _isMinimized ? 28 : 32,
                      ),
                    ),
                  ],
                ),
                
                // Expandable content
                SizeTransition(
                  sizeFactor: _sizeAnimation.drive(
                    Tween<double>(begin: 1.0, end: 0.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      
                      // Explanation section
                      const Text(
                        'Your Job Cart helps you organize your job search:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      _buildExplanationItem(
                        icon: Icons.thumb_up_outlined,
                        title: 'Potential Opportunities',
                        description: 'Jobs you\'ve liked and want to explore further',
                        color: Colors.amber.shade600,
                      ),
                      
                      _buildExplanationItem(
                        icon: Icons.edit_document,
                        title: 'Applications Remaining',
                        description: 'Jobs you\'re ready to apply for',
                        color: Colors.blue.shade600,
                      ),
                      
                      _buildExplanationItem(
                        icon: Icons.check_circle_outline,
                        title: 'Applications Completed',
                        description: 'Jobs you\'ve already applied to',
                        color: Colors.green.shade600,
                      ),
                      
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                      
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            size: 16,
                            color: Colors.amber.shade700,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Swipe left on any job to remove it from your cart',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.amber.shade700,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExplanationItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withAlpha((255 * 0.1).round()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}