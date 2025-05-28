class JobLocationModel {
  final String jobCity; // job_city
  final String jobCountry; // job_country

  JobLocationModel({
    required this.jobCity,
    required this.jobCountry,
  });

  Map<String, dynamic> toJson() {
    return {
      'job_city': jobCity,
      'job_country': jobCountry,
    };
  }

  static JobLocationModel fromJson(Map<String, dynamic> jobLocation) {
    return JobLocationModel(
      jobCity: jobLocation['job_city'] ?? "",
      jobCountry: jobLocation['job_country'] ?? "",
    );
  }

  static List<JobLocationModel> jobLocationModelListFactory(dynamic jobLocations) {
    if (jobLocations == null || jobLocations is! List) {
      return [];
    }
    
    return jobLocations.map<JobLocationModel>((jobLocation) {
      return JobLocationModel.fromJson(jobLocation as Map<String, dynamic>);
    }).toList();
  }
}