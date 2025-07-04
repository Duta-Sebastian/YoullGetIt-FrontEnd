import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:youllgetit_flutter/data/question_repository.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/screens/entry_upload_cv_screen.dart';
import 'package:youllgetit_flutter/screens/questionnaire_screen.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/widgets/answers_review_widget.dart';

class ReviewAnswersScreen extends StatefulWidget {
  final Map<String, List<String>> answers;
  final bool isShortQuestionnaire;

  static const Color primaryColor = Colors.amber;

  const ReviewAnswersScreen({
    super.key,
    required this.answers,
    required this.isShortQuestionnaire,
  });

  @override
  State<ReviewAnswersScreen> createState() => _ReviewAnswersScreenState();
}

class _ReviewAnswersScreenState extends State<ReviewAnswersScreen> {
  late Map<String, List<String>> _currentAnswers;
  late bool _currentlyShort;

  @override
  void initState() {
    super.initState();
    _currentAnswers = Map<String, List<String>>.from(widget.answers);
    _currentlyShort = widget.isShortQuestionnaire;
    
    _saveAnswers(_currentAnswers);
  }

  void _saveAnswers(Map<String, List<String>> answers) async {
    try {
      await DatabaseManager.saveQuestionAnswers(
        {for (var entry in answers.entries) entry.key: entry.value},
        _currentlyShort
      );
    } catch (e) {
      debugPrint('Error saving answers: $e');
    }
  }

  List<MapEntry<String, List<String>>> _getOrderedAnswers() {
    return QuestionRepository.sortAnswerEntries(_currentAnswers.entries.toList());
  }

  void _onAnswersUpdated(Map<String, List<String>> updatedAnswers) {
    if (!const DeepCollectionEquality().equals(_currentAnswers, updatedAnswers)) {
      setState(() {
        _currentAnswers = updatedAnswers;
      });
      
      _saveAnswers(updatedAnswers);
    }
  }

  void _switchToFullQuestionnaire() {
    final localizations = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.upgradeToFullTitle),
        content: Text(localizations.upgradeToFullContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.settingsPageCancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performSwitch();
            },
            child: Text(localizations.upgradeSwitch),
          ),
        ],
      ),
    );
  }

  void _performSwitch() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionnaireScreen(
          isShortQuestionnaire: false,
          initialAnswers: _currentAnswers,
        ),
      ),
    );
  }

  Widget _buildQuestionnaireTypeIndicator() {
    final localizations = AppLocalizations.of(context)!;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.amber.withAlpha(25),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.amber.withAlpha(77)),
      ),
      child: Row(
        children: [
          Icon(Icons.bolt, color: Colors.amber[700], size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              localizations.shortQuestionnaireMode,
              style: TextStyle(
                color: Colors.amber[800],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: _switchToFullQuestionnaire,
            style: TextButton.styleFrom(
              foregroundColor: Colors.amber[700],
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              localizations.upgradeSwitch, 
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(localizations.reviewAnswersTitle),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              if (_currentlyShort) _buildQuestionnaireTypeIndicator(),
              
              Expanded(
                child: AnswersReviewWidget(
                  entries: _getOrderedAnswers(),
                  onAnswersUpdated: _onAnswersUpdated,
                  isShortQuestionnaire: _currentlyShort,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Map<String, dynamic> serializedAnswers = {
                    for (var entry in _currentAnswers.entries)
                      entry.key: entry.value
                  };
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EntryUploadCvScreen(
                        answers: serializedAnswers, 
                        isShortQuestionnaire: _currentlyShort
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ReviewAnswersScreen.primaryColor,
                  foregroundColor: Colors.black,
                  elevation: 5,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  localizations.reviewAnswersLetsFind,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}