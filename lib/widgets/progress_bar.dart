import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int currentQuestionIndex;
  final int totalQuestions;

  const ProgressBar({super.key, 
    required this.currentQuestionIndex,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[300],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: (currentQuestionIndex + 1) / totalQuestions,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(89, 164, 144, 1))
        ),
      ),
    );
  }
}