import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:youllgetit_flutter/models/question_model.dart';
import 'package:youllgetit_flutter/services/question_translation_service.dart';

class CheckboxWidget extends StatefulWidget {
  final Question question;
  final List<String> selectedChoices;
  final Function(List<String>) onChoicesUpdated;

  const CheckboxWidget({
    super.key,
    required this.question,
    required this.selectedChoices,
    required this.onChoicesUpdated,
  });

  @override
  CheckboxWidgetState createState() => CheckboxWidgetState();
}

class CheckboxWidgetState extends State<CheckboxWidget> {
  late TextEditingController _otherController;
  String? otherText;

  @override
  void initState() {
    super.initState();
    _otherController = TextEditingController();
    _initializeController();
  }

  void _initializeController() {
    if (widget.question.options != null && widget.question.options!.isNotEmpty) {
      final otherAnswers = widget.selectedChoices
          .where((choice) => !widget.question.options!.contains(choice))
          .toList();

      if (otherAnswers.isNotEmpty) {
        _otherController.text = otherAnswers.last;
        otherText = otherAnswers.last;
      }
    }
  }

  @override
  void didUpdateWidget(covariant CheckboxWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.question.text != oldWidget.question.text) {
      _otherController.clear();
      otherText = null;
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

    final List<String> updatedChoices = List.from(widget.selectedChoices)
      ..removeWhere((choice) => widget.question.options != null && 
                               !widget.question.options!.contains(choice));

    if (text.isNotEmpty) {
      updatedChoices.add(text);
    }

    widget.onChoicesUpdated(updatedChoices);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final translatedOptions = QuestionTranslationService.getTranslatedOptions(
      widget.question.id, 
      widget.question.options ?? [], 
      l10n
    );
    final hintText = QuestionTranslationService.getTranslatedHintText(widget.question.id, l10n);
    final otherHint = QuestionTranslationService.getOtherFieldHint(widget.question.id, l10n);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.question.options != null && widget.question.options!.length > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              hintText,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ...List.generate(translatedOptions.length, (index) {
          final originalOption = widget.question.options![index];
          final translatedOption = translatedOptions[index];
          
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: NeumorphicButton(
                onPressed: () {
                  _toggleChoice(originalOption);
                },
                style: NeumorphicStyle(
                  color: widget.selectedChoices.contains(originalOption)
                      ? const Color(0xFFFFDE15)
                      : Colors.white,
                  depth: 5,
                  intensity: 0.5,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: Row(
                    children: [
                      Icon(
                        widget.selectedChoices.contains(originalOption)
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: widget.selectedChoices.contains(originalOption)
                            ? Colors.black
                            : Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          translatedOption,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: widget.selectedChoices.contains(originalOption)
                                ? Colors.black
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        if (widget.question.hasOtherField)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FractionallySizedBox(
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
                  controller: _otherController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: otherHint,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
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
  }
}