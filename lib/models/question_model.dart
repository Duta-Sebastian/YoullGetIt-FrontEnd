enum AnswerType {
  checkbox,
  text,
  chips,
}

class Question {
  final String id;
  final String text;
  final AnswerType answerType;
  final List<String>? options;
  final bool hasOtherField;

  Question({
    required this.id,
    required this.text,
    required this.answerType,
    this.options,
    this.hasOtherField = false,
  });
}
