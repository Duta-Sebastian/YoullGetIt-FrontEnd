import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';

class XyzFormulaWidget extends StatefulWidget {
  const XyzFormulaWidget({super.key});

  @override
  State<XyzFormulaWidget> createState() => _XyzFormulaWidgetState();
}

class _XyzFormulaWidgetState extends State<XyzFormulaWidget> with SingleTickerProviderStateMixin {
  static const String _minimizedKey = 'xyz_formula_minimized';
  bool _isMinimized = false; // Default to false for first app open
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
    final isMinimized = prefs.getBool(_minimizedKey) ?? false; // Default to false (expanded) for first open
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
    final localizations = AppLocalizations.of(context)!;
    
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
            Colors.yellow.shade50,
            Colors.yellow.shade100,
          ],
        ),
        borderRadius: BorderRadius.circular(_isMinimized ? 12 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.yellow.withAlpha((255 * 0.2).round()),
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
                        Icons.help_outline_rounded,
                        color: Colors.orange.shade600,
                        size: _isMinimized ? 16 : 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isMinimized ? localizations.xyzFormulaQuestion : localizations.xyzFormulaTitle,
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
                          color: Colors.orange.shade700,
                          size: _isMinimized ? 18 : 20,
                        ),
                      ),
                      onPressed: _toggleMinimized,
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
                      
                      // Description section
                      Text(
                        localizations.xyzFormulaDescription,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Formula section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.orange.shade200,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.lightbulb_outline,
                                    color: Colors.orange.shade600,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Formula',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              localizations.xyzFormulaFormula,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Example section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.auto_awesome,
                                    color: Colors.green.shade600,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  localizations.xyzFormulaExampleLabel,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              localizations.xyzFormulaExampleText,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                      
                      Row(
                        children: [
                          Icon(
                            Icons.tips_and_updates_outlined,
                            size: 16,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              localizations.xyzFormulaTip,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange.shade700,
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
}