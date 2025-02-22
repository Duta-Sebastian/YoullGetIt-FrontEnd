import 'package:flutter/material.dart';

class QuestionTwo extends StatelessWidget {
  const QuestionTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "This is Question Two",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}