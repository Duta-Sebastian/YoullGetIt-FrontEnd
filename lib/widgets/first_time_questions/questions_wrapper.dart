import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/models/question_model.dart';
import 'package:youllgetit_flutter/widgets/first_time_questions/generic_question.dart';
import 'package:youllgetit_flutter/data/question_repository.dart';

class QuestionWrapper extends StatefulWidget {
  final int currentQuestionIndex;
  final int totalQuestions;
  final Function(int) onQuestionIndexChanged;
  final Function(String) onQuestionTextUpdated;

  const QuestionWrapper({
    Key? key,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    required this.onQuestionIndexChanged,
    required this.onQuestionTextUpdated,
  }) : super(key: key);

  @override
  QuestionWrapperState createState() => QuestionWrapperState();
}

class QuestionWrapperState extends State<QuestionWrapper> {
  Map<String, List<String>> answersMap = {};

  void _goToNextQuestion() {
    final currentQuestionId = QuestionRepository.questions[widget.currentQuestionIndex].id;
    print("Current question ID: $currentQuestionId");
    
    // Check if there are no answers for the current question
    if (answersMap[currentQuestionId] == null || answersMap[currentQuestionId]!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least one option"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Explicitly reset the "Other" field for the next question
    if (widget.currentQuestionIndex < widget.totalQuestions - 1) {
      final nextQuestionId = QuestionRepository.questions[widget.currentQuestionIndex + 1].id;
      setState(() {
        // Reset the answers for the next question, specifically clearing the "Other" field
        answersMap[nextQuestionId] = [];
      });

      widget.onQuestionIndexChanged(widget.currentQuestionIndex + 1);
    } else {
      print('Final selections: $answersMap');
    }
  }


  void _goToPreviousQuestion() {
    if (widget.currentQuestionIndex > 0) {
      widget.onQuestionIndexChanged(widget.currentQuestionIndex - 1);
    }
  }

  void _updateSelectedChoices(List<String> choices) {
    final questionId = QuestionRepository.questions[widget.currentQuestionIndex].id;
    setState(() {
      answersMap[questionId] = List.from(choices);
    });
  }

  void _updateOtherText(String text) {
    final currentQuestion = QuestionRepository.questions[widget.currentQuestionIndex];
    final questionId = currentQuestion.id;

    setState(() {
      if (text.isNotEmpty) {
        // If "Other" text is provided, update the current question's answer list
        answersMap[questionId] = [
          ...?answersMap[questionId]?.where((answer) => !currentQuestion.options!.contains(answer)),
          text
        ];
      } else {
        // If "Other" text is empty, remove any "Other" answers from the current question
        answersMap[questionId]?.removeWhere(
          (answer) => !(currentQuestion.options ?? []).contains(answer),
        );
      }
      // Debugging output to ensure that the map is correctly updated
      print('Updated answersMap: $answersMap');
    });
  }

  @override
  Widget build(BuildContext context) {
    final Question currentQuestion = QuestionRepository.questions[widget.currentQuestionIndex];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onQuestionTextUpdated(currentQuestion.text);
    });

    return Column(
      children: [
        Expanded(
          child: GenericQuestionWidget(
            question: currentQuestion,
            selectedChoices: answersMap[currentQuestion.id] ?? [],
            onChoicesUpdated: _updateSelectedChoices,
            onTextUpdated: _updateOtherText,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.currentQuestionIndex > 0)
                ElevatedButton(
                  onPressed: _goToPreviousQuestion,
                  child: const Text("Previous"),
                ),
              ElevatedButton(
                onPressed: _goToNextQuestion,
                child: Text(
                  widget.currentQuestionIndex == widget.totalQuestions - 1 ? "Finish" : "Next",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
