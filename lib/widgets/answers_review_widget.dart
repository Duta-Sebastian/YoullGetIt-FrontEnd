import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/data/question_repository.dart';
import 'package:youllgetit_flutter/screens/edit_question_screen.dart';

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

  String _formatAnswers(List<String> answers) {
    if (answers.isEmpty) return 'No answer';
    return answers.join(', ');
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
        ),
      ),
    );
    if (result != null && !DeepCollectionEquality().equals(_answersMap, result)) {
      setState(() {
        _answersMap = result;
      });

      widget.onAnswersUpdated?.call(_answersMap);

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
  
  List<MapEntry<String, List<String>>> _getSortedEntries() {
    return QuestionRepository.sortAnswerEntries(_answersMap.entries.toList());
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