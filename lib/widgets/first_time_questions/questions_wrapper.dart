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
    super.key,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    required this.onQuestionIndexChanged,
    required this.onQuestionTextUpdated,
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
    final firstQuestion = QuestionRepository.questions.first;
    _navigationStack = [firstQuestion.id];
    _navigationStackIndex = 0;
  }

  List<String> _computeRouteForRoot(Question root) {
    List<String> route = [];
    final selectedBranches = answersMap[root.id] ?? [];
    for (final branch in selectedBranches) {
      if (root.nextQuestionMap != null && root.nextQuestionMap!.containsKey(branch)) {
        String? currentId = root.nextQuestionMap![branch];
        while (currentId != null) {
          final question = QuestionRepository.questions.firstWhere((q) => q.id == currentId);
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
      if (route.isEmpty || route.last != root.nextQuestionId) {
        route.add(root.nextQuestionId!);
      }
    }
    return route;
  }

  void _recomputeNavigationStackFromRoot(String rootId) {
    int rootIndex = _navigationStack.indexOf(rootId);
    if (rootIndex == -1) return;
    final rootQuestion = QuestionRepository.questions.firstWhere((q) => q.id == rootId);
    final newRoute = _computeRouteForRoot(rootQuestion);
    setState(() {
      _navigationStack = _navigationStack.sublist(0, rootIndex + 1) + newRoute;
      if (_navigationStackIndex > _navigationStack.length - 1) {
        _navigationStackIndex = _navigationStack.length - 1;
      }
    });
  }

  void _goToNextQuestion() {
    final currentQuestion = QuestionRepository.questions[widget.currentQuestionIndex];

    if ((answersMap[currentQuestion.id] ?? []).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one option"))
      );
      return;
    }

    if (currentQuestion.isRoot) {
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
    }

    if (widget.currentQuestionIndex == QuestionRepository.questions.length - 1) {
      print(answersMap);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You've completed the questions!"))
      );
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

  void _updateSelectedChoices(List<String> choices) {
    final qId = QuestionRepository.questions[widget.currentQuestionIndex].id;
    if (QuestionRepository.questions[widget.currentQuestionIndex].isRoot) {
      final prevBranches = answersMap[qId] ?? [];
      final removedBranches = prevBranches.where((b) => !choices.contains(b));
      for (final branch in removedBranches) {
        _removeBranchAnswers(qId, branch);
      }
      setState(() {
        answersMap[qId] = List.from(choices);
      });
      _recomputeNavigationStackFromRoot(qId);
    } else {
      setState(() {
        answersMap[qId] = List.from(choices);
      });
    }
  }

  void _updateOtherText(String text) {
    final currentQuestion = QuestionRepository.questions[widget.currentQuestionIndex];
    final questionId = currentQuestion.id;

    setState(() {
      // Remove any previous text input that is not part of the predefined options
      answersMap[questionId]?.removeWhere(
        (answer) => !(currentQuestion.options ?? []).contains(answer),
      );

      // Add the new text input if it's not empty
      if (text.isNotEmpty) {
        answersMap[questionId] = [
          ...?answersMap[questionId],
          text,
        ];
      }
    });
  }

  void _removeBranchAnswers(String rootId, String branch) {
    final branchQuestionIds = _getBranchQuestionIds(rootId, branch);
    for (final id in branchQuestionIds) {
      answersMap.remove(id);
    }
  }

  List<String> _getBranchQuestionIds(String rootId, String branch) {
    final branchQuestions = <String>[];
    final root = QuestionRepository.questions.firstWhere((q) => q.id == rootId);
    String? currentId = root.nextQuestionMap?[branch];
    
    while (currentId != null) {
      branchQuestions.add(currentId);
      final nextQuestion = QuestionRepository.questions.firstWhere((q) => q.id == currentId);
      currentId = nextQuestion.nextQuestionId;
    }
    return branchQuestions;
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = QuestionRepository.questions[widget.currentQuestionIndex];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onQuestionTextUpdated(currentQuestion.text);
      if (currentQuestion.isRoot) {
        _recomputeNavigationStackFromRoot(currentQuestion.id);
      }
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
              if (_navigationStackIndex > 0)
                ElevatedButton(
                  onPressed: _goToPreviousQuestion,
                  child: const Text("Previous"),
                ),
              // Add a Spacer to push the "Next" button to the right
              if (_navigationStackIndex == 0) Spacer(),
              ElevatedButton(
                onPressed: _goToNextQuestion,
                child: Text(
                  widget.currentQuestionIndex == QuestionRepository.questions.length - 1
                    ? "Finish" 
                    : "Next",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}