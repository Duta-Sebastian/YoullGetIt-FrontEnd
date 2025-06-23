import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/models/question_model.dart';
import 'package:youllgetit_flutter/services/question_translation_service.dart';

class TextWidget extends StatefulWidget {
  final Question question;
  final List<String> selectedChoices;
  final Function(String) onTextUpdated;

  const TextWidget({
    super.key,
    required this.question,
    required this.selectedChoices,
    required this.onTextUpdated,
  });

  @override
  TextWidgetState createState() => TextWidgetState();
}

class TextWidgetState extends State<TextWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _initializeController();
  }

  void _initializeController() {
    if (widget.selectedChoices.isNotEmpty) {
      _controller.text = widget.selectedChoices.first;
    }
  }

  @override
  void didUpdateWidget(covariant TextWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.question.text != oldWidget.question.text) {
      _controller.clear();
      _initializeController();
    } else if (!_areListsEqual(widget.selectedChoices, oldWidget.selectedChoices)) {
      _initializeController();
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
    _controller.dispose();
    super.dispose();
  }

  void _handleTextChange(String text) {
    widget.onTextUpdated(text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hintText = QuestionTranslationService.getTranslatedHintText(widget.question.id, l10n);

    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 5,
          intensity: 0.5,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(8),
          ),
        ),
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 10.0,
            ),
          ),
          onChanged: _handleTextChange,
          maxLines: 4,
          minLines: 1,
        ),
      ),
    );
  }
}