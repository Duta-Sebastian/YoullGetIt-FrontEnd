import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/data/question_repository.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/services/question_translation_service.dart';
import 'package:youllgetit_flutter/screens/edit_question_screen.dart';

class AnswersReviewWidget extends StatefulWidget {
  final List<MapEntry<String, dynamic>> entries;
  final Function(Map<String, List<String>>)? onAnswersUpdated;
  final bool isShortQuestionnaire; // NEW: Add path awareness

  const AnswersReviewWidget({
    super.key,
    required this.entries,
    this.onAnswersUpdated,
    required this.isShortQuestionnaire, // NEW: Required parameter
  });

  @override
  AnswersReviewWidgetState createState() => AnswersReviewWidgetState();
}

class AnswersReviewWidgetState extends State<AnswersReviewWidget> {
  late Map<String, List<String>> _answersMap;

  // NEW: Helper property for cleaner code
  bool get isShortQuestionnaire => widget.isShortQuestionnaire;

  @override
  void initState() {
    super.initState();
    _initializeAnswersMap();
  }

  void _initializeAnswersMap() {
    _answersMap = {};
    for (final entry in widget.entries) {
      _answersMap[entry.key] = _getAnswersList(entry.value);
    }
  }

  List<String> _getAnswersList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    } else if (value is String) {
      return [value];
    }
    return [];
  }

  String _formatAnswers(List<String> answers, AppLocalizations localizations, String questionText) {
    if (answers.isEmpty) return localizations.reviewNoAnswer;
    
    // Try to get the question to apply translations to answer options
    final question = QuestionRepository.getQuestionByText(questionText);
    if (question != null && question.options != null) {
      // Translate the answer options if they match question options
      final translatedAnswers = answers.map((answer) {
        final originalIndex = question.options!.indexOf(answer);
        if (originalIndex != -1) {
          final translatedOptions = QuestionTranslationService.getTranslatedOptions(
            question.id, 
            question.options!, 
            localizations
          );
          if (originalIndex < translatedOptions.length) {
            return translatedOptions[originalIndex];
          }
        }
        return answer; // Return original if not found in options
      }).toList();
      
      return translatedAnswers.join(', ');
    }
    
    return answers.join(', ');
  }

  String _getTranslatedQuestionText(String questionText, AppLocalizations localizations) {
    // Try to get the question and translate it
    final question = QuestionRepository.getQuestionByText(questionText);
    if (question != null) {
      return QuestionTranslationService.getTranslatedQuestionText(question.id, localizations);
    }
    return questionText; // Fallback to original text
  }

  void _editQuestion(String questionText) async {
    final question = QuestionRepository.getQuestionByText(questionText);
    if (question == null) return;

    final result = await Navigator.of(context).push<Map<String, List<String>>>(
      MaterialPageRoute(
        builder: (context) => EditQuestionScreen(
          question: question,
          currentAnswers: _answersMap[questionText] ?? [],
          allCurrentAnswers: Map<String, List<String>>.from(_answersMap),
          isShortQuestionnaire: isShortQuestionnaire, // NEW: Pass path info
        ),
      ),
    );
    
    if (result != null && !DeepCollectionEquality().equals(_answersMap, result)) {
      setState(() {
        _answersMap = result;
      });

      widget.onAnswersUpdated?.call(_answersMap);

      if (mounted) {
        final localizations = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.reviewAnswerUpdatedSuccessfully),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  } 
  
  List<MapEntry<String, List<String>>> _getSortedEntries() {
    return QuestionRepository.sortAnswerEntries(_answersMap.entries.toList());
  }

  // NEW: Filter entries to only show questions that should be in current path
  List<MapEntry<String, List<String>>> _getFilteredSortedEntries() {
    final sortedEntries = _getSortedEntries();
    
    return sortedEntries.where((entry) {
      final question = QuestionRepository.getQuestionByText(entry.key);
      if (question == null) return true; // Keep if we can't determine
      
      return QuestionRepository.shouldIncludeInPath(question.id, isShortQuestionnaire);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    if (_answersMap.isEmpty) {
      return Center(
        child: Text(
          localizations.reviewNoAnswersToDisplay,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // NEW: Use filtered entries that respect current path
    final filteredEntries = _getFilteredSortedEntries();

    if (filteredEntries.isEmpty) {
      final localizations = AppLocalizations.of(context)!;
      final mode = isShortQuestionnaire 
          ? localizations.choiceScreenFastAccess.toLowerCase()
          : localizations.choiceScreenHigherAccuracy.toLowerCase();
      
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              localizations.noAnswersForMode(mode),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            if (isShortQuestionnaire) ...[
              const SizedBox(height: 16),
              Text(
                localizations.switchToSeeAllAnswers(localizations.choiceScreenHigherAccuracy.toLowerCase()),
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      );
    }

    return Column(
      children: [        
        Expanded(
          child: ListView.builder(
            itemCount: filteredEntries.length,
            itemBuilder: (context, index) {
              final entry = filteredEntries[index];
              final questionText = entry.key;
              final answers = entry.value;
              final translatedQuestionText = _getTranslatedQuestionText(questionText, localizations);
              final formattedAnswers = _formatAnswers(answers, localizations, questionText);

              // NEW: Check if question is editable in current path
              final question = QuestionRepository.getQuestionByText(questionText);
              final isEditable = question != null && 
                  QuestionRepository.shouldIncludeInPath(question.id, isShortQuestionnaire);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 2,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: isEditable ? () => _editQuestion(questionText) : null,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                translatedQuestionText,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isEditable ? Colors.black87 : Colors.grey[600],
                                ),
                              ),
                            ),
                            if (isEditable)
                              const Icon(
                                Icons.edit,
                                color: Colors.blue,
                                size: 20,
                              )
                            else
                              Icon(
                                Icons.lock,
                                color: Colors.grey[400],
                                size: 20,
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isEditable ? Colors.white : Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            formattedAnswers,
                            style: TextStyle(
                              fontSize: 14,
                              color: isEditable ? Colors.black : Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}