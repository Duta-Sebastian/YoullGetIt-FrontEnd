import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/data/question_repository.dart';
import 'package:youllgetit_flutter/models/question_model.dart';
import 'package:youllgetit_flutter/screens/entry_upload_cv_screen.dart';
import 'package:youllgetit_flutter/utils/questions_saver.dart';
import 'package:youllgetit_flutter/widgets/answers_review_widget.dart';

class ReviewAnswersScreen extends StatelessWidget {
  final Map<String, List<String>> answers;

  static const Color primaryColor = Colors.amber;

  const ReviewAnswersScreen({
    super.key,
    required this.answers,
  });

  static List<MapEntry<String, List<String>>> _getOrderedAnswers(
      Map<String, List<String>> answers) {
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
    final orderedAnswerEntries = _getOrderedAnswers(answers);

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
                child: AnswersReviewWidget(
                  entries: orderedAnswerEntries,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Map<String, dynamic> serializedAnswers = {
                    for (var entry in orderedAnswerEntries)
                      entry.key: entry.value
                  };

                  QuestionsSaver.saveAnswers(serializedAnswers);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EntryUploadCvScreen(answers: serializedAnswers),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
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
                child: const Text(
                  "Let's find it!",
                  style: TextStyle(
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
