enum JobStatus {
  unknown,
  liked,
  toApply,
  applied
}

extension JobStatusExtension on JobStatus {
  static JobStatus fromString(String value) {
    return JobStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => JobStatus.unknown,
    );
  }
}