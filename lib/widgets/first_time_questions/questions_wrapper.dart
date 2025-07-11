import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/models/question_model.dart';
import 'package:youllgetit_flutter/services/question_translation_service.dart';
import 'package:youllgetit_flutter/widgets/first_time_questions/generic_question.dart';
import 'package:youllgetit_flutter/data/question_repository.dart';

class QuestionWrapper extends StatefulWidget {
  final int currentQuestionIndex;
  final int totalQuestions;
  final Function(int, String) onQuestionIndexChanged;
  final Function(String) onQuestionTextUpdated;
  final Function(Map<String, List<String>>)? onFinish;
  final Function(QuestionWrapperState)? onStateReady;
  final bool isShortQuestionnaire; // NEW: Add this parameter

  const QuestionWrapper({
    super.key,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    required this.onQuestionIndexChanged,
    required this.onQuestionTextUpdated,
    this.onFinish,
    this.onStateReady,
    required this.isShortQuestionnaire, // NEW: Make it required
  });

  @override
  QuestionWrapperState createState() => QuestionWrapperState();
}

class QuestionWrapperState extends State<QuestionWrapper> {
  List<String> _navigationStack = [];
  int _navigationStackIndex = 0;
  Map<String, List<String>> answersMap = {};
  bool _isLoading = false;

  // NEW: Helper property for cleaner code
  bool get isShortQuestionnaire => widget.isShortQuestionnaire;

  @override
  void initState() {
    super.initState();
    _initNavigationStack();
    // Expose this state to parent after next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onStateReady?.call(this);
    });
  }

  void _initNavigationStack() {
    final firstQuestion = QuestionRepository.questions.first;
    _navigationStack = [firstQuestion.id];
    _navigationStackIndex = 0;
  }

  Question? _getQuestionById(String id) {
    return QuestionRepository.getQuestionById(id);
  }

  // UPDATED: Add path filtering to route computation
  List<String> _computeRouteForRoot(Question root) {
    List<String> route = [];
    final selectedBranches = answersMap[root.text] ?? [];
    
    for (final branch in selectedBranches) {
      if (root.nextQuestionMap != null && root.nextQuestionMap!.containsKey(branch)) {
        String? currentId = root.nextQuestionMap![branch];
        
        while (currentId != null) {
          final question = _getQuestionById(currentId);
          
          if (question == null) break;
          
          // NEW: Check if question should be included in current path
          if (QuestionRepository.shouldIncludeInPath(currentId, isShortQuestionnaire)) {
            if (question.rootQuestionId == root.id) {
              route.add(question.id);
              // NEW: Use path-aware next question lookup
              currentId = QuestionRepository.getNextQuestionId(question, isShortQuestionnaire);
            } else {
              break;
            }
          } else {
            // NEW: Skip this question and continue to next
            currentId = QuestionRepository.getNextQuestionId(question, isShortQuestionnaire);
          }
        }
      }
    }
    
    // NEW: Use path-aware next question lookup for main flow
    if (root.nextQuestionId != null) {
      final nextId = QuestionRepository.getNextQuestionId(root, isShortQuestionnaire);
      
      if (nextId != null && (route.isEmpty || route.last != nextId)) {
        route.add(nextId);
      }
    }
    
    return route;
  }

  void _recomputeNavigationStackFromRoot(String rootId) {
    int rootIndex = _navigationStack.indexOf(rootId);
    if (rootIndex == -1) return;
    
    final rootQuestion = _getQuestionById(rootId);
    if (rootQuestion == null) return;
    
    final newRoute = _computeRouteForRoot(rootQuestion);
    
    setState(() {
      _navigationStack = _navigationStack.sublist(0, rootIndex + 1) + newRoute;
      
      if (_navigationStackIndex > _navigationStack.length - 1) {
        _navigationStackIndex = _navigationStack.length - 1;
      }
    });
  }

  bool _validateCurrentAnswer() {
    final currentQuestion = QuestionRepository.questions[widget.currentQuestionIndex];
    final l10n = AppLocalizations.of(context)!;
    
    if ((answersMap[currentQuestion.text] ?? []).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.pleaseSelectAtLeastOneOption,
            style: TextStyle(color: Colors.black)
          ),
          backgroundColor: const Color(0xFFFFDE15),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _handleQuestionnaireCompletion() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    // Add a small delay for better UX
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    if (widget.onFinish != null) {
      widget.onFinish!(answersMap);
    } else {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.celebration, color: Colors.white),
              const SizedBox(width: 8),
              Text(l10n.questionnaireCompleted),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _goToNextQuestion() async {
    if (!_validateCurrentAnswer()) return;

    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    final currentQuestion = QuestionRepository.questions[widget.currentQuestionIndex];
    
    if (currentQuestion.rootQuestionId == currentQuestion.id) {
      _recomputeNavigationStackFromRoot(currentQuestion.id);
    }

    // Add small delay for smooth transition
    await Future.delayed(const Duration(milliseconds: 200));

    if (!mounted) return;

    if (_navigationStackIndex < _navigationStack.length - 1) {
      _navigationStackIndex++;
      final nextQuestionId = _navigationStack[_navigationStackIndex];
      final newIndex = QuestionRepository.questions.indexWhere((q) => q.id == nextQuestionId);
      final newQuestionId = QuestionRepository.questions[newIndex].id;
      
      if (newIndex != -1) {
        setState(() {
          widget.onQuestionIndexChanged(newIndex, newQuestionId);
          _isLoading = false;
        });
      }
    } else {
      await _handleQuestionnaireCompletion();
    }
  }

  Future<void> _goToPreviousQuestion() async {
    if (_navigationStackIndex > 0) {
      if (!mounted) return;
      
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(milliseconds: 200));

      if (!mounted) return;

      _navigationStackIndex--;
      final prevQuestionId = _navigationStack[_navigationStackIndex];
      final prevIndex = QuestionRepository.questions.indexWhere((q) => q.id == prevQuestionId);
      final newQuestionId = QuestionRepository.questions[prevIndex].id;
      if (prevIndex != -1) {
        setState(() {
          widget.onQuestionIndexChanged(prevIndex, newQuestionId);
          _isLoading = false;
        });
      }
    }
  }

  // UPDATED: Use path filtering when removing branch answers
  List<String> _getBranchQuestionTexts(String rootId, String branch) {
    final branchQuestionTexts = <String>[];
    final rootQuestion = _getQuestionById(rootId);
    
    if (rootQuestion == null || 
        rootQuestion.nextQuestionMap == null || 
        !rootQuestion.nextQuestionMap!.containsKey(branch)) {
      return branchQuestionTexts;
    }
    
    String? currentId = rootQuestion.nextQuestionMap![branch];
    
    while (currentId != null) {
      final question = _getQuestionById(currentId);
      if (question == null) break;
      
      branchQuestionTexts.add(question.text);
      // NEW: Use path-aware next question lookup
      currentId = QuestionRepository.getNextQuestionId(question, isShortQuestionnaire);
    }
    
    return branchQuestionTexts;
  }

  void _removeBranchAnswers(String rootId, String branch) {
    final branchQuestionTexts = _getBranchQuestionTexts(rootId, branch);
    for (final questionText in branchQuestionTexts) {
      answersMap.remove(questionText);
    }
  }

  void _updateSelectedChoices(List<String> choices) {
    final currentQuestion = QuestionRepository.questions[widget.currentQuestionIndex];
    final questionText = currentQuestion.text;
    
    if (currentQuestion.rootQuestionId == currentQuestion.id) {
      final prevBranches = answersMap[questionText] ?? [];
      final removedBranches = prevBranches.where((b) => !choices.contains(b));
      
      for (final branch in removedBranches) {
        _removeBranchAnswers(currentQuestion.id, branch);
      }
      
      setState(() {
        answersMap[questionText] = List.from(choices);
      });
      
      _recomputeNavigationStackFromRoot(currentQuestion.id);
    } else {
      setState(() {
        answersMap[questionText] = List.from(choices);
      });
    }
  }

  void _updateOtherText(String text) {
    final currentQuestion = QuestionRepository.questions[widget.currentQuestionIndex];
    final questionText = currentQuestion.text;

    setState(() {
      final currentAnswers = answersMap[questionText] ?? [];
      final filteredAnswers = currentAnswers.where(
        (answer) => (currentQuestion.options ?? []).contains(answer)
      ).toList();
      
      if (text.isNotEmpty) {
        filteredAnswers.add(text);
      }
      
      answersMap[questionText] = filteredAnswers;
    });
  }

  // Public getters for parent to access state
  bool get canGoBack => _navigationStackIndex > 0;
  bool get isLoading => _isLoading;
  
  // UPDATED: Dynamically determine if this is the last question based on available path
  bool get isLastQuestion {
    // Check if we're at the end of our navigation stack
    if (_navigationStackIndex >= _navigationStack.length - 1) {
      return true;
    }
    
    // Check if the current question has no valid next question in this path
    final currentQuestion = QuestionRepository.questions[widget.currentQuestionIndex];
    final nextQuestionId = QuestionRepository.getNextQuestionId(currentQuestion, isShortQuestionnaire);
    
    return nextQuestionId == null;
  }

  // Public methods for parent to control navigation
  Future<void> goToNextQuestion() => _goToNextQuestion();
  Future<void> goToPreviousQuestion() => _goToPreviousQuestion();

  @override
  Widget build(BuildContext context) {
    final currentQuestion = QuestionRepository.questions[widget.currentQuestionIndex];
    final l10n = AppLocalizations.of(context)!;
    final translatedQuestionText = QuestionTranslationService.getTranslatedQuestionText(
      currentQuestion.id, 
      l10n
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onQuestionTextUpdated(translatedQuestionText);
      
      if (currentQuestion.rootQuestionId == currentQuestion.id) {
        _recomputeNavigationStackFromRoot(currentQuestion.id);
      }
    });

    return PopScope(
      canPop: _navigationStackIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _navigationStackIndex > 0) {
          _goToPreviousQuestion();
        }
      },
      child: GenericQuestionWidget(
        question: currentQuestion,
        selectedChoices: answersMap[currentQuestion.text] ?? [],
        onChoicesUpdated: _updateSelectedChoices,
        onTextUpdated: _updateOtherText,
      ),
    );
  }
}