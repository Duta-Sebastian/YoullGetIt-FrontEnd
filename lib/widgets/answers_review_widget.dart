import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/data/question_repository.dart';
import 'package:youllgetit_flutter/models/question_model.dart';
import 'package:youllgetit_flutter/screens/edit_question_screen.dart';
import 'package:youllgetit_flutter/utils/question_id_parts.dart';

class AnswersReviewWidget extends StatefulWidget {
  final List<MapEntry<String, dynamic>> entries;
  final Function(Map<String, List<String>>)? onAnswersUpdated;

  const AnswersReviewWidget({
    super.key,
    required this.entries,
    this.onAnswersUpdated,
  });

  @override
  AnswersReviewWidgetState createState() => AnswersReviewWidgetState();
}

class AnswersReviewWidgetState extends State<AnswersReviewWidget> {
  late Map<String, List<String>> _answersMap;
  late List<String> _fixedQuestionOrder; // Store the original order

  @override
  void initState() {
    super.initState();
    _initializeAnswersMap();
    _ensureQuestionRepositoryInitialized();
    _establishFixedOrder();
  }

  void _initializeAnswersMap() {
    _answersMap = {};
    for (final entry in widget.entries) {
      _answersMap[entry.key] = _getAnswersList(entry.value);
    }
  }

  void _establishFixedOrder() {
    final sortedEntries = _answersMap.entries.toList();
    sortedEntries.sort((a, b) {
      final questionA = _getQuestionByText(a.key);
      final questionB = _getQuestionByText(b.key);
      
      if (questionA == null || questionB == null) return 0;
      
      return _compareQuestionIds(questionA.id, questionB.id);
    });
    
    _fixedQuestionOrder = sortedEntries.map((e) => e.key).toList();
  }

  void _ensureQuestionRepositoryInitialized() {
    if (QuestionRepository.questions.isEmpty) {
      QuestionRepository.initialize();
    }
  }

  Question? _getQuestionByText(String text) {
    try {
      return QuestionRepository.questions.firstWhere((q) => q.text == text);
    } catch (e) {
      return null;
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

  String _formatAnswers(List<String> answers) {
    if (answers.isEmpty) return 'No answer';
    return answers.join(', ');
  }

  bool _mapsAreEqual(Map<String, List<String>> map1, Map<String, List<String>> map2) {
    if (map1.length != map2.length) return false;
    
    for (final entry in map1.entries) {
      if (!map2.containsKey(entry.key)) return false;
      final list1 = entry.value;
      final list2 = map2[entry.key]!;
      if (list1.length != list2.length) return false;
      for (int i = 0; i < list1.length; i++) {
        if (list1[i] != list2[i]) return false;
      }
    }
    return true;
  }

  void _editQuestion(String questionText) async {
    final question = _getQuestionByText(questionText);
    if (question == null) return;

    final result = await Navigator.of(context).push<Map<String, List<String>>>(
      MaterialPageRoute(
        builder: (context) => EditQuestionScreen(
          question: question,
          currentAnswers: _answersMap[questionText] ?? [],
          allCurrentAnswers: Map<String, List<String>>.from(_answersMap),
        ),
      ),
    );

    if (result != null) {
      // Check if there were actual changes
      final hasChanges = !_mapsAreEqual(_answersMap, result);
      
      setState(() {
        _answersMap = result;
        // Immediately update the fixed order to include new questions in correct positions
        _updateFixedOrderWithNewQuestions(result);
      });

      // Only update database and notify parent if there were actual changes
      if (hasChanges) {
        if (widget.onAnswersUpdated != null) {
          widget.onAnswersUpdated!(_answersMap);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Answer updated successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  void _updateFixedOrderWithNewQuestions(Map<String, List<String>> newAnswersMap) {
    // Find questions that are in the new map but not in our fixed order
    final newQuestions = <String>[];
    for (final questionText in newAnswersMap.keys) {
      if (!_fixedQuestionOrder.contains(questionText)) {
        newQuestions.add(questionText);
      }
    }
    
    // Insert each new question in the correct sorted position
    for (final newQuestionText in newQuestions) {
      final newQuestion = _getQuestionByText(newQuestionText);
      if (newQuestion != null) {
        int insertIndex = _fixedQuestionOrder.length;
        
        // Find the correct position by comparing with existing questions
        for (int i = 0; i < _fixedQuestionOrder.length; i++) {
          final existingQuestion = _getQuestionByText(_fixedQuestionOrder[i]);
          if (existingQuestion != null && 
              _compareQuestionIds(newQuestion.id, existingQuestion.id) < 0) {
            insertIndex = i;
            break;
          }
        }
        
        _fixedQuestionOrder.insert(insertIndex, newQuestionText);
      }
    }
    
    // Remove questions that are no longer in the answers map
    _fixedQuestionOrder.removeWhere((questionText) => !newAnswersMap.containsKey(questionText));
  }

  List<MapEntry<String, List<String>>> _getSortedEntries() {
    final sortedEntries = <MapEntry<String, List<String>>>[];
    
    // Use the fixed order which is always kept up to date
    for (final questionText in _fixedQuestionOrder) {
      if (_answersMap.containsKey(questionText)) {
        sortedEntries.add(MapEntry(questionText, _answersMap[questionText]!));
      }
    }
    
    return sortedEntries;
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

  @override
  Widget build(BuildContext context) {
    if (_answersMap.isEmpty) {
      return const Center(
        child: Text(
          'No answers to display',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final sortedEntries = _getSortedEntries();

    return ListView.builder(
      itemCount: sortedEntries.length,
      itemBuilder: (context, index) {
        final entry = sortedEntries[index];
        final questionText = entry.key;
        final answers = entry.value;
        final formattedAnswers = _formatAnswers(answers);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _editQuestion(questionText),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          questionText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.edit,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      formattedAnswers,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}