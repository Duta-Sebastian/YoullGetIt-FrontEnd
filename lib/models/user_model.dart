class UserModel {
  final String username;
  final DateTime? lastChanged;

  UserModel({
    required this.username,
    required this.lastChanged,
  });

  factory UserModel.fromJson(List<dynamic> jsonArray) {
    if (jsonArray.isEmpty) {
      throw Exception("Empty response array");
    }

    Map<String, dynamic> json = jsonArray[0];
    
    String username = json['username'] != null ? json['username'] as String : '';
    
    DateTime? lastChanged;
    if (json['last_changed'] != null) {
      String dateStr = json['last_changed'] as String;
      if (dateStr != "0001-01-01T00:00:00Z") {
        lastChanged = DateTime.parse(dateStr);
      }
    }
    
    return UserModel(
      username: username,
      lastChanged: lastChanged,
    );
  }
}