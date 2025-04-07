import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:youllgetit_flutter/data/question_repository.dart';
import 'package:youllgetit_flutter/screens/review_answers_screen.dart';
import 'package:youllgetit_flutter/widgets/character_speech_bubble.dart';
import 'package:youllgetit_flutter/widgets/first_time_questions/questions_wrapper.dart';
import 'package:youllgetit_flutter/widgets/progress_bar.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  QuestionnaireScreenState createState() => QuestionnaireScreenState();
}

class QuestionnaireScreenState extends State<QuestionnaireScreen> {
  int _currentQuestionIndex = 0;
  String _currentQuestionText = '';
  
  void _updateQuestionIndex(int newIndex) {
    setState(() {
      _currentQuestionIndex = newIndex;
    });
  }
  
  void _updateQuestionText(String text) {
    setState(() {
      _currentQuestionText = text;
    });
  }

  void _onFinish(Map<String, List<String>> answers) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ReviewAnswersScreen(answers: answers))
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Questions',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ProgressBar(
          currentQuestionIndex: _currentQuestionIndex,
          totalQuestions: QuestionRepository.questions.length,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              
              CharacterSpeechBubble(text: _currentQuestionText),
              const SizedBox(height: 24),
              
              Expanded(
                child: QuestionWrapper(
                  currentQuestionIndex: _currentQuestionIndex,
                  totalQuestions: QuestionRepository.questions.length,
                  onQuestionIndexChanged: _updateQuestionIndex,
                  onQuestionTextUpdated: _updateQuestionText,
                  onFinish: _onFinish,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}