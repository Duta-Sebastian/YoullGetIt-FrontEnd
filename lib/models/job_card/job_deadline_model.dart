class JobDeadline {
  final String month;
  final String day;

  JobDeadline({
    required this.month,
    required this.day,
  });

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'day': day,
    };
  }

  static JobDeadline? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    
    return JobDeadline(
      month: json['month']?.toString() ?? "",
      day: json['day']?.toString() ?? "",
    );
  }

  @override
  String toString() {
    return 'JobDeadline(month: $month, day: $day)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JobDeadline &&
        other.month == month &&
        other.day == day;
  }

  @override
  int get hashCode => month.hashCode ^ day.hashCode;
}