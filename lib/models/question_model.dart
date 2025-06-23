enum AnswerType {
  checkbox,
  radio,
  languages,
  restrictedChips,
}

class Question {
  final String id;
  final String text;
  final AnswerType answerType;
  final List<String>? options;
  final bool hasOtherField;
  final String? nextQuestionId;
  final Map<String, String>? nextQuestionMap;
  final String? rootQuestionId;
  final String? previousQuestionId;
  final bool isRoot;

  const Question({
    required this.id,
    required this.text,
    required this.answerType,
    this.options,
    this.hasOtherField = false,
    this.nextQuestionId,
    this.nextQuestionMap,
    this.previousQuestionId,
    this.rootQuestionId,
  }) : isRoot = rootQuestionId == id;
}