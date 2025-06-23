import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youllgetit_flutter/data/question_repository.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/screens/review_answers_screen.dart';
import 'package:youllgetit_flutter/widgets/character_speech_bubble.dart';
import 'package:youllgetit_flutter/widgets/first_time_questions/progress_bar.dart';
import 'package:youllgetit_flutter/widgets/first_time_questions/questions_wrapper.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  QuestionnaireScreenState createState() => QuestionnaireScreenState();
}

class QuestionnaireScreenState extends State<QuestionnaireScreen> {
  int _currentQuestionIndex = 0;
  String _currentQuestionText = '';
  QuestionWrapperState? _questionWrapperState; // Reference to QuestionWrapper state
  
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

  void _onQuestionWrapperReady(QuestionWrapperState state) {
    setState(() {
      _questionWrapperState = state;
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
        const SizedBox(height: 12),
        ProgressBar(
          currentQuestionIndex: _currentQuestionIndex,
          totalQuestions: QuestionRepository.questionsCount,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    if (_questionWrapperState == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Previous button
          if (_questionWrapperState!.canGoBack) ...[
            Expanded(child: _buildPreviousButton()),
            const SizedBox(width: 12),
          ],
          
          // Next button
          Expanded(child: _buildNextButton()),
        ],
      ),
    );
  }

  Widget _buildPreviousButton() {
    final l10n = AppLocalizations.of(context)!;
    
    return SizedBox(
      height: 48,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _questionWrapperState!.isLoading ? null : _questionWrapperState!.goToPreviousQuestion,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: _questionWrapperState!.isLoading ? Colors.grey[200] : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _questionWrapperState!.isLoading ? Colors.grey[400]! : Colors.grey[300]!,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_questionWrapperState!.isLoading) ...[
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
                    ),
                  ),
                  const SizedBox(width: 6),
                ] else ...[
                  Icon(Icons.arrow_back, size: 18, color: Colors.grey[700]),
                  const SizedBox(width: 6),
                ],
                Text(
                  l10n.questionsPrevious,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _questionWrapperState!.isLoading ? Colors.grey[500] : Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    final l10n = AppLocalizations.of(context)!;
    
    return SizedBox(
      height: 48,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _questionWrapperState!.isLoading ? null : _questionWrapperState!.goToNextQuestion,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              gradient: _questionWrapperState!.isLoading 
                  ? LinearGradient(colors: [Colors.grey[300]!, Colors.grey[400]!])
                  : const LinearGradient(
                      colors: [Color(0xFFFFDE15), Color(0xFFFFF066)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: _questionWrapperState!.isLoading ? null : [
                BoxShadow(
                  color: const Color(0xFFFFDE15).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_questionWrapperState!.isLoading) ...[
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  _questionWrapperState!.isLastQuestion ? l10n.questionsFinish : l10n.questionsNext,
                  style: TextStyle(
                    color: _questionWrapperState!.isLoading ? Colors.grey[600] : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (!_questionWrapperState!.isLoading) ...[
                  const SizedBox(width: 6),
                  Icon(
                    _questionWrapperState!.isLastQuestion ? Icons.check : Icons.arrow_forward,
                    size: 18,
                    color: Colors.black,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    
                    CharacterSpeechBubble(text: _currentQuestionText),
                    const SizedBox(height: 24),
                    
                    QuestionWrapper(
                      currentQuestionIndex: _currentQuestionIndex,
                      totalQuestions: QuestionRepository.questionsCount,
                      onQuestionIndexChanged: _updateQuestionIndex,
                      onQuestionTextUpdated: _updateQuestionText,
                      onFinish: _onFinish,
                      onStateReady: _onQuestionWrapperReady,
                    ),
                    
                    const SizedBox(height: 100), // Padding for fixed buttons
                  ],
                ),
              ),
            ),
            
            // Fixed navigation buttons at bottom
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: _buildNavigationButtons(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}