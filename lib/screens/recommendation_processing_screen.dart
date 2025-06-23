import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/screens/home_screen.dart';
import 'package:youllgetit_flutter/services/job_api.dart';
import 'package:youllgetit_flutter/providers/job_provider.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/utils/first_time_checker.dart';

class RecommendationProcessingScreen extends ConsumerStatefulWidget {
  final bool withCv;
  final Map<String, dynamic> answers;

  const RecommendationProcessingScreen({
    super.key,
    required this.withCv, 
    required this.answers
  });

  @override
  ConsumerState<RecommendationProcessingScreen> createState() => _RecommendationProcessingScreenState();
}

class _RecommendationProcessingScreenState extends ConsumerState<RecommendationProcessingScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  bool _isError = false;
  String _errorMessage = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    // Delay processing slightly to allow for smooth UI initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _processRecommendation();
    });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _processRecommendation() async {
    try {
      // Add minimum delay to prevent immediate flash
      final futures = await Future.wait([
        JobApi.uploadUserInformation(widget.withCv, widget.answers),
        Future.delayed(const Duration(milliseconds: 1500)), // Minimum loading time
      ]);
      
      final result = futures[0] as int;
      
      if (!mounted) return;
      
      if (result == 0) {
        final localizations = AppLocalizations.of(context)!;
        setState(() {
          _isLoading = false;
          _isError = true;
          _errorMessage = localizations.processingFailedToProcess;
        });
        // Reset animation for error view
        _animationController.reset();
        _animationController.forward();
      } else {
        // Perform background operations without blocking UI
        _performBackgroundOperations();
        
        // Navigate immediately for better UX
        if (mounted) {
          await Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end).chain(
                  CurveTween(curve: curve),
                );

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      
      final localizations = AppLocalizations.of(context)!;
      setState(() {
        _isLoading = false;
        _isError = true;
        _errorMessage = localizations.processingErrorOccurred(e.toString());
      });
      // Reset animation for error view
      _animationController.reset();
      _animationController.forward();
    }
  }

  Future<void> _performBackgroundOperations() async {
    // Perform these operations without blocking navigation
    try {
      await Future.wait([
        ref.read(activeJobsProvider.notifier).fetchJobs(),
        setFirstTimeOpening(),
        DatabaseManager.saveQuestionAnswers(widget.answers),
      ]);
    } catch (e) {
      // Log error but don't block navigation
      debugPrint('Background operations error: $e');
    }
  }

  void _retryProcessing() {
    setState(() {
      _isLoading = true;
      _isError = false;
      _errorMessage = '';
    });
    _animationController.reset();
    _animationController.forward();
    _processRecommendation();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Center(
                  child: _isLoading 
                    ? _buildLoadingView()
                    : _isError 
                      ? _buildErrorView()
                      : const SizedBox.shrink(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    final localizations = AppLocalizations.of(context)!;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              color: Colors.amber,
              strokeWidth: 4,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            localizations.processingFindingOpportunities,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            localizations.processingAnalyzingProfile,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    final localizations = AppLocalizations.of(context)!;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red.shade400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _errorMessage,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _retryProcessing,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                localizations.processingTryAgain,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: _goBack,
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                localizations.processingGoBack,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}