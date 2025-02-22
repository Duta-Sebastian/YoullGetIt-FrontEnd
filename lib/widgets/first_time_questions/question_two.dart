import 'package:flutter/material.dart';

class QuestionTwo extends StatefulWidget {
  final Function(String) onQuestionTextUpdated;

  const QuestionTwo({
    super.key,
    required this.onQuestionTextUpdated,
  });

  @override
  _QuestionTwoState createState() => _QuestionTwoState();
}

class _QuestionTwoState extends State<QuestionTwo> {
  final String questionText = "Hello?";

    @override
  void initState() {
    super.initState();
    Future.microtask(() {
      widget.onQuestionTextUpdated(questionText);
    });
  }

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