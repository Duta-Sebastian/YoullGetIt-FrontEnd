import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/data/question_repository.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/providers/job_provider.dart';
import 'package:youllgetit_flutter/services/job_api.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/screens/questionnaire_screen.dart';
import 'package:youllgetit_flutter/widgets/answers_review_widget.dart';

class ViewAnswersScreen extends ConsumerStatefulWidget {
  const ViewAnswersScreen({
    super.key,
  });

  @override
  ConsumerState<ViewAnswersScreen> createState() => _ViewAnswersScreenState();
}

class _ViewAnswersScreenState extends ConsumerState<ViewAnswersScreen> {
  List<MapEntry<String, dynamic>> entries = [];
  bool hasUpdatedAnswers = false;
  late final JobCoordinator _jobCoordinator;
  bool _currentlyShort = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _jobCoordinator = ref.read(jobCoordinatorProvider);
    _loadQuestionsAnswers();
  }

  void _loadQuestionsAnswers() async {
    try {
      final isShort = await DatabaseManager.isShortQuestionnaire();
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
          _currentlyShort = isShort;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading question answers: $e');
      if (mounted) {
        setState(() {
          entries = [];
          _isLoading = false;
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
    await DatabaseManager.saveQuestionAnswers(answersToSave, _currentlyShort);
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

  Widget _buildQuestionnaireTypeIndicator() {
    final localizations = AppLocalizations.of(context)!;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.amber.withAlpha(25),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.amber.withAlpha(77)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.bolt,
            size: 16,
            color: Colors.amber[700],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              localizations.shortQuestionnaireMode,
              style: TextStyle(
                fontSize: 14,
                color: Colors.amber[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: _switchToFullQuestionnaire,
            style: TextButton.styleFrom(
              foregroundColor: Colors.amber[700],
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              minimumSize: const Size(0, 32),
            ),
            child: Text(
              localizations.upgradeSwitch,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _switchToFullQuestionnaire() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuestionnaireScreen(
          isShortQuestionnaire: false,
          initialAnswers: _convertEntriesToAnswers(),
        ),
      ),
    );
  }

  Map<String, List<String>> _convertEntriesToAnswers() {
    Map<String, List<String>> answers = {};
    for (var entry in entries) {
      if (entry.value is List) {
        answers[entry.key] = List<String>.from(entry.value);
      } else {
        answers[entry.key] = [entry.value.toString()];
      }
    }
    return answers;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
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
          title: Text(localizations.reviewAnswersTitle),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                  )
                : entries.isEmpty 
                    ? Center(
                        child: Text(
                          localizations.reviewNoAnswersToDisplay,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : Column(
                        children: [
                          if (_currentlyShort) _buildQuestionnaireTypeIndicator(),
                          
                          Expanded(
                            child: AnswersReviewWidget(
                              entries: entries,
                              onAnswersUpdated: _onAnswersUpdated,
                              isShortQuestionnaire: _currentlyShort,
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