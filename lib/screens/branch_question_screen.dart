import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/data/question_repository.dart';
import 'package:youllgetit_flutter/models/question_model.dart';
import 'package:youllgetit_flutter/widgets/first_time_questions/generic_question.dart';

class BranchQuestionsScreen extends StatefulWidget {
  final int startingQuestionIndex;
  final Map<String, List<String>> initialAnswers;
  final String rootQuestionId;

  const BranchQuestionsScreen({
    super.key,
    required this.startingQuestionIndex,
    required this.initialAnswers,
    required this.rootQuestionId,
  });

  @override
  BranchQuestionsScreenState createState() => BranchQuestionsScreenState();
}

class BranchQuestionsScreenState extends State<BranchQuestionsScreen> {
  late int _currentQuestionIndex;
  late Map<String, List<String>> _answersMap;
  
  @override
  void initState() {
    super.initState();
    _currentQuestionIndex = widget.startingQuestionIndex;
    _answersMap = Map<String, List<String>>.from(widget.initialAnswers);
  }

  Question get _currentQuestion => QuestionRepository.questions[_currentQuestionIndex];

  bool get _isLastQuestionInBranch {
    final nextQuestionId = _currentQuestion.nextQuestionId;
    if (nextQuestionId == null) return true;
    
    final nextQuestion = QuestionRepository.questions.firstWhere(
      (q) => q.id == nextQuestionId,
    );
    
    return nextQuestion.id.isEmpty || nextQuestion.rootQuestionId != widget.rootQuestionId;
  }

  void _updateAnswers(List<String> answers) {
    setState(() {
      _answersMap[_currentQuestion.text] = List.from(answers);
    });
  }

  void _updateText(String text) {
    setState(() {
      if (text.isNotEmpty) {
        _answersMap[_currentQuestion.text] = [text];
      } else {
        _answersMap.remove(_currentQuestion.text);
      }
    });
  }

  bool _validateCurrentAnswer() {
    final answers = _answersMap[_currentQuestion.text] ?? [];
    if (answers.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one option")),
      );
      return false;
    }
    return true;
  }

  void _goToNext() {
    if (!_validateCurrentAnswer()) return;

    if (_isLastQuestionInBranch) {
      // Return the complete updated answers when finishing the branch
      Navigator.of(context).pop(_answersMap);
      return;
    }

    final nextQuestionId = _currentQuestion.nextQuestionId!;
    final nextIndex = QuestionRepository.questions.indexWhere((q) => q.id == nextQuestionId);
    
    if (nextIndex != -1) {
      setState(() {
        _currentQuestionIndex = nextIndex;
      });
    }
  }

  void _goToPrevious() {
    final currentId = _currentQuestion.id;
    
    for (int i = 0; i < QuestionRepository.questions.length; i++) {
      final question = QuestionRepository.questions[i];
      if (question.nextQuestionId == currentId && 
          question.rootQuestionId == widget.rootQuestionId) {
        setState(() {
          _currentQuestionIndex = i;
        });
        return;
      }
    }
  }

  bool get _hasPreviousQuestion {
    final currentId = _currentQuestion.id;
    return QuestionRepository.questions.any((q) => 
      q.nextQuestionId == currentId && q.rootQuestionId == widget.rootQuestionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(_answersMap),
        ),
        title: const Text('Complete Questions'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  _currentQuestion.text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              Expanded(
                child: GenericQuestionWidget(
                  question: _currentQuestion,
                  selectedChoices: _answersMap[_currentQuestion.text] ?? [],
                  onChoicesUpdated: _updateAnswers,
                  onTextUpdated: _updateText,
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _hasPreviousQuestion
                        ? ElevatedButton(
                            onPressed: _goToPrevious,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber.shade600,
                              foregroundColor: Colors.black,
                            ),
                            child: const Text("Previous"),
                          )
                        : const SizedBox.shrink(),
                    ElevatedButton(
                      onPressed: _goToNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade600,
                        foregroundColor: Colors.black,
                      ),
                      child: Text(_isLastQuestionInBranch ? "Finish" : "Next"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}