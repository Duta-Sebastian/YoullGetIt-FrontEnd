import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/data/question_repository.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/models/question_model.dart';
import 'package:youllgetit_flutter/screens/branch_question_screen.dart';
import 'package:youllgetit_flutter/services/question_translation_service.dart';
import 'package:youllgetit_flutter/widgets/first_time_questions/generic_question.dart';

class EditQuestionScreen extends StatefulWidget {
  final Question question;
  final List<String> currentAnswers;
  final Map<String, List<String>> allCurrentAnswers;

  const EditQuestionScreen({
    super.key,
    required this.question,
    required this.currentAnswers,
    required this.allCurrentAnswers,
  });

  @override
  EditQuestionScreenState createState() => EditQuestionScreenState();
}

class EditQuestionScreenState extends State<EditQuestionScreen> {
  late List<String> _selectedAnswers;
  late Map<String, List<String>> _updatedAnswersMap;

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List.from(widget.currentAnswers);
    _updatedAnswersMap = Map<String, List<String>>.from(widget.allCurrentAnswers);
  }

  Question? _getQuestionById(String id) {
    try {
      return QuestionRepository.questions.firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }

  Question? _getQuestionByText(String text) {
    try {
      return QuestionRepository.questions.firstWhere((q) => q.text == text);
    } catch (e) {
      return null;
    }
  }

  bool _validateAnswers() {
    if (_selectedAnswers.isEmpty) {
      final localizations = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.pleaseSelectAtLeastOneOption),
          backgroundColor: Color(0xFFFFDE15),
        ),
      );
      return false;
    }
    return true;
  }

  bool get _hasNewBranches {
    if (widget.question.rootQuestionId != widget.question.id) return false;
    
    final addedBranches = _selectedAnswers.where((branch) => !widget.currentAnswers.contains(branch));
    
    if (addedBranches.isEmpty || widget.question.nextQuestionMap == null) return false;
    
    // Check if any of the added branches actually have questions
    for (final branch in addedBranches) {
      if (widget.question.nextQuestionMap!.containsKey(branch)) {
        final branchQuestionId = widget.question.nextQuestionMap![branch];
        if (branchQuestionId != null && branchQuestionId.isNotEmpty) {
          // Check if the branch question exists
          final branchQuestion = QuestionRepository.questions.firstWhere(
            (q) => q.id == branchQuestionId,
          );
          if (branchQuestion.id.isNotEmpty) {
            return true; // Found at least one valid branch with questions
          }
        }
      }
    }
    
    return false; // No valid branches with questions found
  }

  List<String> _getBranchQuestionTexts(String rootQuestionText, String branch) {
    final branchQuestionTexts = <String>[];
    final rootQuestion = _getQuestionByText(rootQuestionText);
    
    if (rootQuestion?.nextQuestionMap?.containsKey(branch) != true) {
      return branchQuestionTexts;
    }
    
    String? currentId = rootQuestion!.nextQuestionMap![branch];
    
    while (currentId != null) {
      final currentQuestion = _getQuestionById(currentId);
      if (currentQuestion == null) break;
      
      branchQuestionTexts.add(currentQuestion.text);
      
      if (currentQuestion.rootQuestionId == rootQuestion.id) {
        currentId = currentQuestion.nextQuestionId;
      } else {
        break;
      }
    }
    
    return branchQuestionTexts;
  }

  void _removeBranchAnswers(String rootQuestionText, String branch) {
    final branchQuestionTexts = _getBranchQuestionTexts(rootQuestionText, branch);
    for (final questionText in branchQuestionTexts) {
      _updatedAnswersMap.remove(questionText);
    }
  }

  void _updateAnswers(List<String> newAnswers) {
    setState(() {
      _selectedAnswers = newAnswers;
      _updatedAnswersMap[widget.question.text] = List.from(newAnswers);
      
      if (widget.question.rootQuestionId == widget.question.id) {
        _handleRootQuestionBranches(newAnswers);
      }
    });
  }

  void _handleRootQuestionBranches(List<String> newAnswers) {
    final previousAnswers = widget.currentAnswers;
    final removedBranches = previousAnswers.where((branch) => !newAnswers.contains(branch));
    
    for (final branch in removedBranches) {
      _removeBranchAnswers(widget.question.text, branch);
    }
  }

  void _updateText(String text) {
    setState(() {
      if (text.isNotEmpty) {
        _selectedAnswers = [text];
        _updatedAnswersMap[widget.question.text] = [text];
      } else {
        _selectedAnswers = [];
        _updatedAnswersMap.remove(widget.question.text);
      }
    });
  }

  void _saveChanges() async {
    if (!_validateAnswers()) return;
    if (_hasNewBranches) {
      _goToQuestionFlow();
      return;
    }
    
    // For regular saves, return the result immediately
    Navigator.pop(context, _updatedAnswersMap);
  }

  void _goToQuestionFlow() async {
    final addedBranches = _selectedAnswers.where((branch) => !widget.currentAnswers.contains(branch));
    
    if (addedBranches.isEmpty || widget.question.nextQuestionMap == null) return;

    String? firstBranchQuestionId;
    for (final branch in addedBranches) {
      if (widget.question.nextQuestionMap!.containsKey(branch)) {
        firstBranchQuestionId = widget.question.nextQuestionMap![branch];
        break;
      }
    }
    
    if (firstBranchQuestionId == null) return;

    final branchQuestionIndex = QuestionRepository.questions.indexWhere(
      (q) => q.id == firstBranchQuestionId
    );
    
    if (branchQuestionIndex == -1) return;

    if (!mounted) return;

    final result = await Navigator.of(context).push<Map<String, List<String>>>(
      MaterialPageRoute(
        builder: (context) => BranchQuestionsScreen(
          startingQuestionIndex: branchQuestionIndex,
          initialAnswers: _updatedAnswersMap,
          rootQuestionId: widget.question.id,
        ),
      ),
    );
    
    if (mounted) {
      // Always return the result (either from branch questions or updated answers)
      Navigator.pop(context, result ?? _updatedAnswersMap);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final translatedQuestionText = QuestionTranslationService.getTranslatedQuestionText(
      widget.question.id, 
      localizations
    );
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(localizations.editAnswerTitle),
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
                  translatedQuestionText,
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
                  question: widget.question,
                  selectedChoices: _selectedAnswers,
                  onChoicesUpdated: _updateAnswers,
                  onTextUpdated: _updateText,
                ),
              ),
              
              const SizedBox(height: 20),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFDE15), // Yellow button
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _hasNewBranches 
                        ? localizations.questionsNext 
                        : localizations.questionSave,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}