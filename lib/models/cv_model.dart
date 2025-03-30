class CvModel {
  final List<int> cvData;
  final DateTime lastChanged;

  CvModel({
    required this.cvData,
    required this.lastChanged,
  });

  factory CvModel.fromJson(List<dynamic> jsonArray) {
    if (jsonArray.isEmpty) {
      throw Exception("Empty response array");
    }

    Map<String, dynamic> json = jsonArray[0];
    return CvModel(
      cvData: List<int>.from(json['cv_data']),
      lastChanged: DateTime.parse(json['last_changed']),
    );
  }
}