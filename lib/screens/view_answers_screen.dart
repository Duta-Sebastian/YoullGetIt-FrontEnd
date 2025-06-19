import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/data/question_repository.dart';
import 'package:youllgetit_flutter/models/question_model.dart';
import 'package:youllgetit_flutter/providers/job_provider.dart';
import 'package:youllgetit_flutter/services/job_api.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/utils/question_id_parts.dart';
import 'package:youllgetit_flutter/widgets/answers_review_widget.dart';

class ViewAnswersScreen extends ConsumerStatefulWidget {
  const ViewAnswersScreen({
    super.key
  });

  @override
  ConsumerState<ViewAnswersScreen> createState() => _ViewAnswersScreenState();
}

class _ViewAnswersScreenState extends ConsumerState<ViewAnswersScreen> {
  List<MapEntry<String, dynamic>> entries = [];
  bool hasUpdatedAnswers = false;
  late final JobCoordinator _jobCoordinator;

  Question? _getQuestionByText(String text) {
    try {
      return QuestionRepository.questions.firstWhere((q) => q.text == text);
    } catch (e) {
      return null;
    }
  }

  int _compareQuestionIds(String idA, String idB) {
    final partsA = parseQuestionId(idA);
    final partsB = parseQuestionId(idB);
    
    final mainCompare = partsA.mainNumber.compareTo(partsB.mainNumber);
    if (mainCompare != 0) return mainCompare;
    
    if (partsA.branchPart == null && partsB.branchPart == null) return 0;
    if (partsA.branchPart == null) return -1;
    if (partsB.branchPart == null) return 1;
    
    final branchCompare = partsA.branchPart!.compareTo(partsB.branchPart!);
    if (branchCompare != 0) return branchCompare;
    
    return partsA.subNumber.compareTo(partsB.subNumber);
  }

  void _loadQuestionsAnswers() async {
    try {
      final answers = await DatabaseManager.getQuestionAnswers();
      debugPrint('Loaded answers: $answers');
      
      // Order the entries here
      if (answers != null) {
        await QuestionRepository.initialize(); // Ensure questions are loaded
        
        final sortedAnswers = answers.toList();
        sortedAnswers.sort((a, b) {
          final questionA = _getQuestionByText(a.key);
          final questionB = _getQuestionByText(b.key);
          
          if (questionA == null || questionB == null) return 0;
          
          return _compareQuestionIds(questionA.id, questionB.id);
        });
        
        if (mounted) {
          setState(() {
            entries = sortedAnswers;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading question answers: $e');
      if (mounted) {
        setState(() {
          entries = [];
        });
      }
    }
  }

  void _onAnswersUpdated(Map<String, List<String>> updatedAnswers) async {
    hasUpdatedAnswers = true;
    Map<String, dynamic> answersToSave = {
      for (var entry in updatedAnswers.entries)
        entry.key: entry.value
    };
    await DatabaseManager.saveQuestionAnswers(answersToSave);
  }

  @override
  void initState() {
    super.initState();
    _jobCoordinator = ref.read(jobCoordinatorProvider);
    _loadQuestionsAnswers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Review Answers'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: entries.isEmpty ? 
            const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            ) :
            AnswersReviewWidget(
              entries: entries,
              onAnswersUpdated: _onAnswersUpdated,
            ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (hasUpdatedAnswers) {
      // Run async operations in a Future
      Future(() async {
        try {
          await JobApi.uploadUserInformation(null, null);
          await _jobCoordinator.resetJobState();
        } catch (e) {
          debugPrint('Error in dispose operations: $e');
        }
      });
    }
    super.dispose();
  }
}