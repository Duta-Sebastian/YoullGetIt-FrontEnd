import 'package:flutter/material.dart';
import 'question_one.dart';
import 'question_two.dart';

class QuestionWrapper extends StatefulWidget {
  final int currentQuestionIndex;
  final int totalQuestions;
  final Function(int) onQuestionIndexChanged;
  final Function(String) onQuestionTextUpdated;

  const QuestionWrapper({
    super.key,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    required this.onQuestionIndexChanged,
    required this.onQuestionTextUpdated,
  });

  @override
  _QuestionWrapperState createState() => _QuestionWrapperState();
}

class _QuestionWrapperState extends State<QuestionWrapper> {
  List<String> selectedChoices = [];
  String otherText = "Other, specify";
  String questionText = "";

  void _goToNextQuestion(BuildContext context) {
    if (selectedChoices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an option"),
          duration: Duration(seconds: 2),
        ),
      );
    } else if (widget.currentQuestionIndex < widget.totalQuestions - 1) {
      widget.onQuestionIndexChanged(widget.currentQuestionIndex + 1);
    } else {
      print("All questions completed!");
    }
  }

  void _goToPreviousQuestion() {
    if (widget.currentQuestionIndex > 0) {
      widget.onQuestionIndexChanged(widget.currentQuestionIndex - 1);
    }
  }

  void _updateSelectedChoices(List<String> choices) {
    setState(() {
      selectedChoices = choices;
    });
  }

  void _updateOtherText(String text) {
    setState(() {
      otherText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> questions = [
      QuestionOne(
        selectedChoices: selectedChoices,
        otherText: otherText,
        onChoicesUpdated: _updateSelectedChoices,
        onOtherTextUpdated: _updateOtherText,
        onQuestionTextUpdated: widget.onQuestionTextUpdated,
      ),
      const QuestionTwo(),
    ];

    return Column(
      children: [
        questions[widget.currentQuestionIndex],

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.currentQuestionIndex > 0)
                ElevatedButton(
                  onPressed: _goToPreviousQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text("Previous"),
                ),

              if (widget.currentQuestionIndex == 0) const Spacer(),

              ElevatedButton(
                onPressed: () => _goToNextQuestion(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text(
                  widget.currentQuestionIndex == widget.totalQuestions - 1 ? "Finish" : "Next",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}