import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/widgets/first_time_questions/questions_wrapper.dart';
import '../widgets/progress_bar.dart';
import '../widgets/character_speech_bubble.dart';

class InternshipSelectorScreen extends StatefulWidget {
  const InternshipSelectorScreen({super.key});

  @override
  InternshipSelectorScreenState createState() => InternshipSelectorScreenState();
}

class InternshipSelectorScreenState extends State<InternshipSelectorScreen> {
  int currentQuestionIndex = 0;
  final int totalQuestions = 5;
  String questionText = "";

  void _updateQuestionIndex(int newIndex) {
    setState(() {
      currentQuestionIndex = newIndex;
    });
  }

  void _updateQuestionText(String text) {
    setState(() {
      questionText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Let\'s get started!',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              ProgressBar(
                currentQuestionIndex: currentQuestionIndex,
                totalQuestions: totalQuestions,
              ),
              const SizedBox(height: 20),
              CharacterSpeechBubble(
                text: questionText,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: QuestionWrapper(
                  currentQuestionIndex: currentQuestionIndex,
                  totalQuestions: totalQuestions,
                  onQuestionIndexChanged: _updateQuestionIndex,
                  onQuestionTextUpdated: _updateQuestionText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
