import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/models/question_model.dart';
import 'package:youllgetit_flutter/services/question_translation_service.dart';

class RadioWidget extends StatefulWidget {
  final Question question;
  final List<String> selectedChoices;
  final Function(List<String>) onChoicesUpdated;

  const RadioWidget({
    super.key,
    required this.question,
    required this.selectedChoices,
    required this.onChoicesUpdated,
  });

  @override
  RadioWidgetState createState() => RadioWidgetState();
}

class RadioWidgetState extends State<RadioWidget> {
  late TextEditingController _otherController;
  String? otherText;

  @override
  void initState() {
    super.initState();
    _otherController = TextEditingController();
    _initializeController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
  void didUpdateWidget(covariant RadioWidget oldWidget) {
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

  void _selectChoice(String option) {
    List<String> updatedChoices = [option];
    
    if (widget.question.options?.contains(option) == true) {
      _otherController.clear();
      otherText = null;
    }
    
    widget.onChoicesUpdated(updatedChoices);
    HapticFeedback.selectionClick();
  }

  void _handleOtherTextChange(String text) {
    setState(() {
      otherText = text;
    });

    List<String> updatedChoices = [];
    if (text.isNotEmpty) {
      updatedChoices = [text];
    }

    widget.onChoicesUpdated(updatedChoices);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final translatedOptions = l10n != null 
        ? QuestionTranslationService.getTranslatedOptions(
            widget.question.id, 
            widget.question.options ?? [], 
            l10n
          )
        : widget.question.options ?? [];
    
    final hintText = l10n != null 
        ? QuestionTranslationService.getTranslatedHintText(widget.question.id, l10n)
        : l10n?.hintSelectOne ?? 'Select one option';
    
    final otherHint = l10n != null 
        ? QuestionTranslationService.getOtherFieldHint(widget.question.id, l10n)
        : l10n?.hintOtherSpecify ?? 'Other, specify';

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hint text
          if (widget.question.options != null && widget.question.options!.length > 1)
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                hintText,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // Options list
          ...List.generate(translatedOptions.length, (index) {
            if (index >= widget.question.options!.length) return SizedBox.shrink();
            
            final originalOption = widget.question.options![index];
            final translatedOption = translatedOptions[index];
            final isSelected = widget.selectedChoices.contains(originalOption);
            
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFFFFDE15).withValues(alpha: 0.1) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Color(0xFFFFDE15) : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _selectChoice(originalOption),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isSelected ? Color(0xFFFFDE15) : Colors.transparent,
                            border: Border.all(
                              color: isSelected ? Color(0xFFFFDE15) : Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.circle,
                                  size: 12,
                                  color: Colors.black,
                                )
                              : null,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            translatedOption,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: Colors.black87,
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

          // Other field
          if (widget.question.hasOtherField)
            Container(
              margin: EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: otherText?.isNotEmpty == true 
                    ? Color(0xFFFFDE15).withValues(alpha: 0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: otherText?.isNotEmpty == true 
                      ? Color(0xFFFFDE15)
                      : Colors.grey.shade300,
                  width: otherText?.isNotEmpty == true ? 2 : 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: otherText?.isNotEmpty == true 
                            ? Color(0xFFFFDE15) 
                            : Colors.transparent,
                        border: Border.all(
                          color: otherText?.isNotEmpty == true 
                              ? Color(0xFFFFDE15)
                              : Colors.grey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: otherText?.isNotEmpty == true
                          ? Icon(
                              Icons.circle,
                              size: 12,
                              color: Colors.black,
                            )
                          : null,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _otherController,
                        decoration: InputDecoration(
                          hintText: otherHint,
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: otherText?.isNotEmpty == true 
                              ? FontWeight.w600 
                              : FontWeight.normal,
                          color: Colors.black87,
                        ),
                        onChanged: _handleOtherTextChange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}