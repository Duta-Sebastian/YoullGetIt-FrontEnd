import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/data/question_repository.dart';
import 'package:youllgetit_flutter/providers/job_provider.dart';
import 'package:youllgetit_flutter/services/job_api.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
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

  void _loadQuestionsAnswers() async {
    try {
      final answers = await DatabaseManager.getQuestionAnswers();
      if (answers != null && mounted) {
        final sortedAnswers = QuestionRepository.sortAnswerEntries(
          answers.map((e) => MapEntry(e.key, e.value is List 
            ? List<String>.from(e.value.map((item) => item.toString()))
            : [e.value.toString()]
          )).toList()
        );

        final sortedEntries = sortedAnswers.map((entry) => 
          MapEntry<String, dynamic>(entry.key, entry.value)
        ).toList();
        
        setState(() {
          entries = sortedEntries;
        });
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

  Future<void> _handleExit() async {
    if (hasUpdatedAnswers) {
      try {
        await JobApi.uploadUserInformation(null, null);
        await _jobCoordinator.resetJobState();
      } catch (e) {
        debugPrint('Error in exit operations: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _jobCoordinator = ref.read(jobCoordinatorProvider);
    _loadQuestionsAnswers();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          await _handleExit();
        }
      },
      child: Scaffold(
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
      ),
    );
  }
}