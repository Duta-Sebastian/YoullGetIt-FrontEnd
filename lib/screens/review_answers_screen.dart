import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/data/question_repository.dart';
import 'package:youllgetit_flutter/models/question_model.dart';
import 'package:youllgetit_flutter/screens/entry_upload_cv_screen.dart';
import 'package:youllgetit_flutter/utils/questions_saver.dart';

class ReviewAnswersScreen extends StatelessWidget {
  final Map<String, List<String>> answers;
  final List<MapEntry<String, List<String>>> orderedAnswerEntries;

  static const Color primaryColor = Color.fromRGBO(89, 164, 144, 1);

  ReviewAnswersScreen({
    super.key,
    required this.answers,
  }) : orderedAnswerEntries = _getOrderedAnswers(answers);

  static List<MapEntry<String, List<String>>> _getOrderedAnswers(Map<String, List<String>> answers) {
    final List<Question> orderedQuestions = QuestionRepository.questions;
    final List<MapEntry<String, List<String>>> orderedAnswerEntries = [];
    
    for (final question in orderedQuestions) {
      if (answers.containsKey(question.id)) {
        orderedAnswerEntries.add(
          MapEntry(question.text, answers[question.id]!),
        );
      }
    }
    
    return orderedAnswerEntries;
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
        title: const Text('Review your answers'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  itemCount: orderedAnswerEntries.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        children: const [
                          SizedBox(height: 16),
                          Text(
                            'Thank you for answering!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24),
                        ],
                      );
                    }
                    final entry = orderedAnswerEntries[index - 1];
                    return _buildAnswerCard(entry);
                  },
                ),
              ),
              const SizedBox(height: 20),
              _buildContinueButton(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerCard(MapEntry<String, List<String>> entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: primaryColor,
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: entry.value.length,
                itemBuilder: (context, index) {
                  final answer = entry.value[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 18,
                          color: primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _formatAnswer(answer),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Map<String, dynamic> serializedAnswers = {};

        for (var entry in orderedAnswerEntries) {
          serializedAnswers[entry.key] = entry.value;
        }
        
        QuestionsSaver.saveAnswers(serializedAnswers);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EntryUploadCvScreen(
              answers: serializedAnswers,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 5,
        padding: const EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: const Text(
        "Let's find it!",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  String _formatAnswer(String answer) {
    if (answer.contains(':')) {
      final parts = answer.split(':');
      if (parts.length == 2) {
        return '${parts[0]} - Level ${parts[1]}';
      }
    }
    return answer;
  }
}