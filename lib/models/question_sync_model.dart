class QuestionSyncModel {
  final String? questionJson;
  final DateTime? lastChanged;
  final bool isShortQuestionnaire;

  QuestionSyncModel({
    this.questionJson,
    this.lastChanged,
    this.isShortQuestionnaire = false,
  });

  factory QuestionSyncModel.fromJson(List<dynamic> jsonArray) {
    if (jsonArray.isEmpty) {
      throw Exception("Empty response array");
    }

    Map<String, dynamic> json = jsonArray[0];

    String? questionJson = json['question_json'] as String?;
    DateTime? lastChanged;
    if (json['last_changed'] != null) {
      String dateStr = json['last_changed'] as String;
      if (dateStr != "0001-01-01T00:00:00Z") {
        lastChanged = DateTime.parse(dateStr);
      }
    }
    bool isShortQuestionnaire = json['is_short_questionnaire'] ?? false;

    return QuestionSyncModel(
      questionJson: questionJson,
      lastChanged: lastChanged,
      isShortQuestionnaire: isShortQuestionnaire,
    );
  }
}