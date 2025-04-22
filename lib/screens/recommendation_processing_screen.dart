import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/screens/home_screen.dart';
import 'package:youllgetit_flutter/services/job_api.dart';
import 'package:youllgetit_flutter/providers/job_provider.dart';

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

class _RecommendationProcessingScreenState extends ConsumerState<RecommendationProcessingScreen> {
  bool _isLoading = true;
  bool _isError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _processRecommendation();
  }

  Future<void> _processRecommendation() async {
    try {
      final result = await JobApi.uploadUserInformation(
        widget.withCv, 
        widget.answers
      );
      
      if (result == 0) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _isError = true;
            _errorMessage = 'Failed to process your data. Please try again.';
          });
        }
      } else {
        ref.read(activeJobsProvider.notifier).fetchJobs(10);
        
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isError = true;
          _errorMessage = 'An error occurred: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _isLoading 
            ? _buildLoadingView()
            : _isError 
              ? _buildErrorView()
              : const SizedBox(),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          const Text(
            'Finding the perfect opportunities for you...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'We\'re analyzing your profile to match you with the best jobs',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red,
          ),
          const SizedBox(height: 24),
          Text(
            _errorMessage,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _isError = false;
              });
              _processRecommendation();
            },
            child: const Text('Try Again'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}