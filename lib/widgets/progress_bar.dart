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

    return Neumorphic(
      style: NeumorphicStyle(
        depth: 4, 
        intensity: 0.8,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
        color: Colors.grey[300], 
      ),
      child: SizedBox(
        height: 20,
        width: double.infinity,
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                double progressWidth = progressRatio * constraints.maxWidth;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      Container(
                        width: progressWidth,
                        height: 20,
                        color: const Color.fromRGBO(89, 164, 144, 1),
                      ),
                      Positioned(
                        top: 2,
                        left: 10,
                        child: Container(
                          width: progressWidth > 10 ? progressWidth - progressWidth * 0.10 : 0,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(120, 200, 180, 1),
                            borderRadius: BorderRadius.circular(3),
                          ),
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