import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:youllgetit_flutter/models/question_model.dart';
import 'package:youllgetit_flutter/widgets/first_time_questions/generic_question.dart';
import 'package:youllgetit_flutter/data/question_repository.dart';

class QuestionWrapper extends StatefulWidget {
  final int currentQuestionIndex;
  final int totalQuestions;
  final Function(int) onQuestionIndexChanged;
  final Function(String) onQuestionTextUpdated;
  final Function(Map<String, List<String>>)? onFinish;

  const QuestionWrapper({
    super.key,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    required this.onQuestionIndexChanged,
    required this.onQuestionTextUpdated,
    this.onFinish,
  });

  @override
  QuestionWrapperState createState() => QuestionWrapperState();
}

class QuestionWrapperState extends State<QuestionWrapper> {
  List<String> _navigationStack = [];
  int _navigationStackIndex = 0;
  Map<String, List<String>> answersMap = {};

  @override
  void initState() {
    super.initState();
    _initNavigationStack();
  }

  void _initNavigationStack() {
    final firstQuestion = QuestionRepository.questions.first;
    _navigationStack = [firstQuestion.id];
    _navigationStackIndex = 0;
  }

  Question _getQuestionById(String id) {
    return QuestionRepository.questions.firstWhere(
      (q) => q.id == id,
      orElse: () => Question(id: '', text: '', answerType: AnswerType.text),
    );
  }

  List<String> _computeRouteForRoot(Question root) {
    List<String> route = [];
    final selectedBranches = answersMap[root.id] ?? [];
    
    for (final branch in selectedBranches) {
      if (root.nextQuestionMap != null && root.nextQuestionMap!.containsKey(branch)) {
        String? currentId = root.nextQuestionMap![branch];
        
        while (currentId != null) {
          final question = _getQuestionById(currentId);
          
          if (question.id.isEmpty) break;
          
          if (question.rootQuestionId == root.id) {
            route.add(question.id);
            currentId = question.nextQuestionId;
          } else {
            break;
          }
        }
      }
    }
    
    if (root.nextQuestionId != null) {
      final nextQ = _getQuestionById(root.nextQuestionId!);
      
      if (nextQ.id.isNotEmpty && (route.isEmpty || route.last != root.nextQuestionId)) {
        route.add(root.nextQuestionId!);
      }
    }
    
    return route;
  }

  void _recomputeNavigationStackFromRoot(String rootId) {
    int rootIndex = _navigationStack.indexOf(rootId);
    if (rootIndex == -1) return;
    
    final rootQuestion = _getQuestionById(rootId);
    if (rootQuestion.id.isEmpty) return;
    
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
    if ((answersMap[currentQuestion.id] ?? []).isEmpty && 
        currentQuestion.answerType != AnswerType.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one option"))
      );
      return false;
    }
    return true;
  }

  void _handleQuestionnaireCompletion() {
    if (widget.onFinish != null) {
      widget.onFinish!(answersMap);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You've completed the questionnaire!"))
      );
    }
  }

  void _goToNextQuestion() {
    if (!_validateCurrentAnswer()) return;

    final currentQuestion = QuestionRepository.questions[widget.currentQuestionIndex];
    
    if (currentQuestion.rootQuestionId == currentQuestion.id) {
      _recomputeNavigationStackFromRoot(currentQuestion.id);
    }

    if (_navigationStackIndex < _navigationStack.length - 1) {
      _navigationStackIndex++;
      final nextQuestionId = _navigationStack[_navigationStackIndex];
      final newIndex = QuestionRepository.questions.indexWhere((q) => q.id == nextQuestionId);
      
      if (newIndex != -1) {
        setState(() {
          widget.onQuestionIndexChanged(newIndex);
        });
      }
    } else {
      _handleQuestionnaireCompletion();
    }
  }

  void _goToPreviousQuestion() {
    if (_navigationStackIndex > 0) {
      _navigationStackIndex--;
      final prevQuestionId = _navigationStack[_navigationStackIndex];
      final prevIndex = QuestionRepository.questions.indexWhere((q) => q.id == prevQuestionId);
      
      if (prevIndex != -1) {
        setState(() {
          widget.onQuestionIndexChanged(prevIndex);
        });
      }
    }
  }

  List<String> _getBranchQuestionIds(String rootId, String branch) {
    final branchQuestions = <String>[];
    final rootQuestion = _getQuestionById(rootId);
    
    if (rootQuestion.id.isEmpty || 
        rootQuestion.nextQuestionMap == null || 
        !rootQuestion.nextQuestionMap!.containsKey(branch)) {
      return branchQuestions;
    }
    
    String? currentId = rootQuestion.nextQuestionMap![branch];
    
    while (currentId != null) {
      branchQuestions.add(currentId);
      
      final nextQuestion = _getQuestionById(currentId);
      
      if (nextQuestion.id.isEmpty) break;
      currentId = nextQuestion.nextQuestionId;
    }
    
    return branchQuestions;
  }

  void _removeBranchAnswers(String rootId, String branch) {
    final branchQuestionIds = _getBranchQuestionIds(rootId, branch);
    for (final id in branchQuestionIds) {
      answersMap.remove(id);
    }
  }

  void _updateSelectedChoices(List<String> choices) {
    final currentQuestion = QuestionRepository.questions[widget.currentQuestionIndex];
    final questionId = currentQuestion.id;
    
    if (currentQuestion.rootQuestionId == questionId) {
      final prevBranches = answersMap[questionId] ?? [];
      final removedBranches = prevBranches.where((b) => !choices.contains(b));
      
      for (final branch in removedBranches) {
        _removeBranchAnswers(questionId, branch);
      }
      
      setState(() {
        answersMap[questionId] = List.from(choices);
      });
      
      _recomputeNavigationStackFromRoot(questionId);
    } else {
      setState(() {
        answersMap[questionId] = List.from(choices);
      });
    }
  }

  void _updateOtherText(String text) {
    final currentQuestion = QuestionRepository.questions[widget.currentQuestionIndex];
    final questionId = currentQuestion.id;

    if (currentQuestion.answerType == AnswerType.text) {
      setState(() {
        if (text.isNotEmpty) {
          answersMap[questionId] = [text];
        } else {
          answersMap.remove(questionId);
        }
      });
    } else {
      setState(() {
        final currentAnswers = answersMap[questionId] ?? [];
        final filteredAnswers = currentAnswers.where(
          (answer) => (currentQuestion.options ?? []).contains(answer)
        ).toList();
        
        if (text.isNotEmpty) {
          filteredAnswers.add(text);
        }
        
        answersMap[questionId] = filteredAnswers;
      });
    }
  }

  bool _isLastQuestion() {
    return _navigationStackIndex == _navigationStack.length - 1 && 
           widget.currentQuestionIndex == QuestionRepository.questions.length - 1;
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _navigationStackIndex > 0
            ? _buildPreviousButton()
            : const SizedBox.shrink(),
        _buildNextButton(),
      ],
    );
  }

  Widget _buildPreviousButton() {
    return NeumorphicButton(
      onPressed: _goToPreviousQuestion,
      style: NeumorphicStyle(
        color: Colors.amber.shade600,
        depth: 5,
        intensity: 0.5,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(8),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Text(
          "Previous",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return NeumorphicButton(
      onPressed: _goToNextQuestion,
      style: NeumorphicStyle(
        color: Colors.amber.shade600,
        depth: 5,
        intensity: 0.5,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Text(
          _isLastQuestion() ? "Finish" : "Next",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = QuestionRepository.questions[widget.currentQuestionIndex];
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onQuestionTextUpdated(currentQuestion.text);
      
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
      child: Column(
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
            child: _buildNavigationButtons(),
          ),
        ],
      ),
    );
  }
}