import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:youllgetit_flutter/data/question_repository.dart';
import 'package:youllgetit_flutter/models/question_model.dart';

class ReviewAnswersScreen extends StatelessWidget {
  final Map<String, List<String>> answers;

  const ReviewAnswersScreen({
    super.key,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    // Get the ordered list of questions from repository
    final List<Question> orderedQuestions = QuestionRepository.questions;
    
    // Create a list of ordered answer entries that will be displayed
    final List<MapEntry<String, List<String>>> orderedAnswerEntries = [];
    
    // Process each question in the order they appear in the repository
    for (final question in orderedQuestions) {
      // Check if this question has answers
      if (answers.containsKey(question.id)) {
        // Add this question and its answers to our ordered list
        orderedAnswerEntries.add(
          MapEntry(question.text, answers[question.id]!),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Review your answers'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Thank you for answering!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(89, 164, 144, 1),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...orderedAnswerEntries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            depth: 3,
                            intensity: 0.5,
                            boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(12),
                            ),
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
                                    color: Color.fromRGBO(89, 164, 144, 1),
                                  ),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 0.5,
                                ),
                                const SizedBox(height: 8),
                                ...entry.value.map((answer) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.check_circle,
                                            size: 18,
                                            color: Color.fromRGBO(89, 164, 144, 1),
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
                                    )),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: NeumorphicButton(
                onPressed: () {
                  // Add your "Let's find it!" action here
                  // For example: Navigator.of(context).pushNamed('/results');
                },
                style: NeumorphicStyle(
                  depth: 5,
                  intensity: 0.6,
                  color: const Color.fromRGBO(89, 164, 144, 1),
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
                child: const Text(
                  "Let's find it!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  // Helper method to format language answers which are stored as "language:level"
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