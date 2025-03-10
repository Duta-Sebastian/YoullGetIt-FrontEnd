import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:youllgetit_flutter/models/question_model.dart';

class GenericQuestionWidget extends StatefulWidget {
  final Question question;
  final List<String> selectedChoices;
  final Function(List<String>) onChoicesUpdated;
  final Function(String) onTextUpdated;

  const GenericQuestionWidget({
    super.key,
    required this.question,
    required this.selectedChoices,
    required this.onChoicesUpdated,
    required this.onTextUpdated,
  });

  @override
  GenericQuestionWidgetState createState() => GenericQuestionWidgetState();
}

class GenericQuestionWidgetState extends State<GenericQuestionWidget> {
  late TextEditingController _otherController;
  String? otherText;

  @override
  void initState() {
    super.initState();
    _otherController = TextEditingController();
    _initializeController();
  }

  void _initializeController() {
    // Check if the current question has an "other" text answer
    final otherAnswers = widget.selectedChoices
        .where((choice) => !widget.question.options!.contains(choice))
        .toList();

    if (otherAnswers.isNotEmpty) {
      _otherController.text = otherAnswers.last; // Use the last text input
      otherText = otherAnswers.last;
    }
  }

  @override
  void didUpdateWidget(covariant GenericQuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the question changes, reset the controller
    if (widget.question.id != oldWidget.question.id) {
      _otherController.clear();
      otherText = null;
      _initializeController(); // Reinitialize for the new question
    }

    // If the same question but selected choices change, update the controller
    else if (!_areListsEqual(widget.selectedChoices, oldWidget.selectedChoices)) {
      _otherController.clear();
      otherText = null;

      final otherAnswers = widget.selectedChoices
          .where((choice) => !widget.question.options!.contains(choice))
          .toList();

      if (otherAnswers.isNotEmpty) {
        _otherController.text = otherAnswers.last; // Use the last text input
        otherText = otherAnswers.last;
      }
    }
  }

  bool _areListsEqual(List<String>? list1, List<String>? list2) {
    if (list1 == null || list2 == null) return list1 == list2;
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  void _toggleChoice(String option) {
    setState(() {
      List<String> updatedChoices = List.from(widget.selectedChoices);
      if (updatedChoices.contains(option)) {
        updatedChoices.remove(option);
      } else {
        updatedChoices.add(option);
      }
      widget.onChoicesUpdated(updatedChoices);
    });
  }

  void _handleOtherTextChange(String text) {
    setState(() {
      otherText = text;
    });

    widget.onTextUpdated(text);

    final List<String> updatedChoices = List.from(widget.selectedChoices)
      ..removeWhere((choice) => !widget.question.options!.contains(choice));

    if (text.isNotEmpty) {
      updatedChoices.add(text);
    }

    widget.onChoicesUpdated(updatedChoices);
  }

  @override
  Widget build(BuildContext context) {
    Widget answerWidget;

    switch (widget.question.answerType) {
      case AnswerType.checkbox:
        answerWidget = Column(
          children: [
            ...?widget.question.options?.map(
              (option) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: FractionallySizedBox(
                  widthFactor: 0.7,
                  child: NeumorphicButton(
                    onPressed: () {
                      setState(() {
                        _toggleChoice(option);
                      });
                    },
                    style: NeumorphicStyle(
                      color: widget.selectedChoices.contains(option)
                          ? Colors.green
                          : Colors.white,
                      depth: 5,
                      intensity: 0.5,
                      boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (widget.question.hasOtherField)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: FractionallySizedBox(
                  widthFactor: 0.7,
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      depth: 5,
                      intensity: 0.5,
                      boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.circular(8),
                      ),
                    ),
                    child: TextField(
                      controller: _otherController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: 'Other, specify',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 10.0,
                        ),
                      ),
                      onChanged: _handleOtherTextChange,
                    ),
                  ),
                ),
              ),
          ],
        );
        break;
      case AnswerType.text:
        answerWidget = FractionallySizedBox(
          widthFactor: 0.7,
          child: Neumorphic(
            style: NeumorphicStyle(
              depth: 5,
              intensity: 0.5,
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(8),
              ),
            ),
            child: TextField(
              controller: _otherController,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'Type your answer here',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 10.0,
                ),
              ),
              onChanged: _handleOtherTextChange,
            ),
          ),
        );
        break;
      case AnswerType.chips:
        answerWidget = Wrap(
          spacing: 8.0,
          children: widget.question.options!.map((option) {
            final isSelected = widget.selectedChoices.contains(option);
            return FractionallySizedBox(
              widthFactor: 0.7,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: NeumorphicButton(
                  onPressed: () {
                    setState(() {
                      _toggleChoice(option);
                    });
                  },
                  style: NeumorphicStyle(
                    color: isSelected ? Colors.green : Colors.white,
                    depth: 5,
                    intensity: 0.5,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0,
                    ),
                    child: Center(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: answerWidget,
            ),
          ),
        ),
      ],
    );
  }
}