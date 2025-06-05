import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:youllgetit_flutter/data/question_repository.dart';

class ProgressBar extends StatelessWidget {
  final int currentQuestionIndex;
  final int totalQuestions;

  const ProgressBar({
    super.key,
    required this.currentQuestionIndex,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final totalRootQuestions = _countRootQuestions();
    final currentRootIndex = _getCurrentRootIndex();
    
    // Calculate progress ratio
    final progressRatio = totalRootQuestions > 0 
        ? (currentRootIndex) / totalRootQuestions 
        : 0.0;

    return Container(
      height: 24,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          // Inset shadow for depth
          BoxShadow(
            color: Colors.grey.shade400,
            offset: const Offset(0, 2),
            blurRadius: 4,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              // Main amber progress fill
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progressRatio,
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.amber,
                        Colors.amber,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x4DFFC107), // Colors.amber with 0.3 opacity equivalent
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Top glossy highlight
              if (progressRatio > 0)
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progressRatio,
                  child: Container(
                    height: 20,
                    padding: const EdgeInsets.fromLTRB(1, 1, 1, 10),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0x99FFFFFF), // Colors.white with 0.6 opacity equivalent
                            Color(0x33FFFFFF), // Colors.white with 0.2 opacity equivalent
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  int _countRootQuestions() {
    final rootQuestions = QuestionRepository.questions
        .where((q) => RegExp(r'^q\d+$').hasMatch(q.id))
        .toList();
    
    return rootQuestions.length;
  }
  
  int _getCurrentRootIndex() {
    if (currentQuestionIndex >= QuestionRepository.questions.length) {
      return 0;
    }
    
    final currentQuestion = QuestionRepository.questions[currentQuestionIndex];
    
    final rootId = currentQuestion.rootQuestionId ?? currentQuestion.id;
    final match = RegExp(r'^q(\d+)').firstMatch(rootId);
    
    if (match != null) {
      final rootNumber = int.tryParse(match.group(1) ?? '0') ?? 0;
      return rootNumber;
    }
    
    return 0;
  }
}