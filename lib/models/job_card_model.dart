class JobCardModel {
  final String id;
  final String title;
  final String company;
  final String location;
  final String duration;
  final List<String> education;
  final String workMode;
  final String jobType;
  final String salary;
  final List<String> languages;
  final List<String> hardSkills;
  final List<String> softSkills;
  final List<String> niceToHave;
  final String description;
  final List<String> requirements;
  final double matchScore;
  final Uri jobUrl;
  
  JobCardModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.duration,
    required this.education,
    required this.jobType,
    required this.salary,
    required this.languages,
    required this.niceToHave,
    required this.workMode,
    required this.hardSkills,
    required this.softSkills,
    required this.description,
    required this.requirements,
    required this.matchScore,
    required this.jobUrl,
  });

Map<String, dynamic> toJson() {
  return {
    'feedback_id': id,
    'role_name': title,
    'company_name': company,
    'job_location': location,
    'duration': duration,
    'required_degree': education,
    'job_type': jobType,
    'work_mode': workMode,
    'expected_salary': salary,
    'required_spoken_languages': languages,
    'hard_skills': hardSkills,
    'soft_skills': softSkills,
    'nice_to_have': niceToHave,
    'job_description': description,
    'job_requirements': requirements,
    'match_score': matchScore,
    'job_url': jobUrl.toString(),
  };
}

  static JobCardModel fromJson(Map<String, dynamic> json) {    
    final String durationValue = json['start_month'] != null && json['end_month'] != null
        ? '${json['start_month']} - ${json['end_month']}'
        : '';    
    return JobCardModel(
      id: json['feedback_id'] ?? json['job_id'] ?? '',
      title: json['role_name'] ?? '',
      company: json['company_name'] ?? '',
      location: json['job_location'] ?? '',
      workMode: json['work_mode'] ?? '',
      jobType: json['job_type'] ?? '',
      jobUrl: Uri.parse(json['job_url'] ?? ''),
      matchScore: json['match_score'] != null ? json['match_score'].toDouble() : 0.0,
      description: json['job_description'] ?? '',
      duration: durationValue,
      education: json['required_degree'] != null 
        ? (json['required_degree'] as List).map((degree) => degree.toString()).toList() 
        : [],
      salary: json['expected_salary'] ?? '',
      languages: json['required_spoken_languages'] != null 
        ? (json['required_spoken_languages'] as List).map((lang) => lang.toString()).toList()
        : [],
      niceToHave: json['nice_to_have'] != null 
        ? (json['nice_to_have'] as List).map((item) => item.toString()).toList()
        : [],
      hardSkills: json['hard_skills'] != null 
        ? (json['hard_skills'] as List).map((skill) => skill.toString()).toList()
        : [],
      softSkills: json['soft_skills'] != null 
        ? (json['soft_skills'] as List).map((skill) => skill.toString()).toList()
        : [],
      requirements: json['job_requirements'] != null 
        ? (json['job_requirements'] as List).map((req) => req.toString()).toList()
        : [],
    );
  }
}