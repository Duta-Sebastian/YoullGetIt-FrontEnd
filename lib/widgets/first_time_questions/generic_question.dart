import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:youllgetit_flutter/models/question_model.dart';
import 'package:youllgetit_flutter/services/question_translation_service.dart';
import 'package:youllgetit_flutter/widgets/first_time_questions/question_types/checkbox_question.dart';
import 'package:youllgetit_flutter/widgets/first_time_questions/question_types/chips_question.dart';
import 'package:youllgetit_flutter/widgets/first_time_questions/question_types/languages_question.dart';
import 'package:youllgetit_flutter/widgets/first_time_questions/question_types/radio_question.dart';
import 'package:youllgetit_flutter/widgets/first_time_questions/question_types/restricted_chips_question.dart';
import 'package:youllgetit_flutter/widgets/first_time_questions/question_types/text_question.dart';

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
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final translatedQuestionText = QuestionTranslationService.getTranslatedQuestionText(
      widget.question.id, 
      l10n
    );

    Widget answerWidget;

    switch (widget.question.answerType) {
      case AnswerType.checkbox:
        answerWidget = CheckboxWidget(
          question: widget.question,
          selectedChoices: widget.selectedChoices,
          onChoicesUpdated: widget.onChoicesUpdated,
        );
        break;
        
      case AnswerType.radio:
        answerWidget = RadioWidget(
          question: widget.question,
          selectedChoices: widget.selectedChoices,
          onChoicesUpdated: widget.onChoicesUpdated,
        );
        break;
        
      case AnswerType.text:
        answerWidget = TextWidget(
          question: widget.question,
          selectedChoices: widget.selectedChoices,
          onTextUpdated: widget.onTextUpdated,
        );
        break;
        
      case AnswerType.languages:
        answerWidget = LanguagesWidget(
          question: widget.question,
          selectedChoices: widget.selectedChoices,
          onChoicesUpdated: widget.onChoicesUpdated,
        );
        break;
        
      case AnswerType.chips:
        answerWidget = ChipsWidget(
          question: widget.question,
          selectedChoices: widget.selectedChoices,
          onChoicesUpdated: widget.onChoicesUpdated,
        );
        break;

      case AnswerType.restrictedChips:
        answerWidget = RestrictedChipsWidget(
          question: widget.question,
          selectedChoices: widget.selectedChoices,
          onChoicesUpdated: widget.onChoicesUpdated,
        );
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Question title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            translatedQuestionText,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // Answer widget
        Flexible(
          fit: FlexFit.loose,
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