class JobCardModel {
  final int id;
  final String title;
  final String company;
  final String location;
  final String duration;
  final String education;
  final String jobType;
  final String salary;
  final String languages;
  final String experience;
  final List<String> skills;
  final List<String> niceToHave;
  
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
    required this.experience,
    required this.skills,
    required this.niceToHave,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'duration': duration,
      'education': education,
      'salary': salary,
      'languages': languages,
      'jobType': jobType,
      'experience': experience,
      'skills': skills,
      'niceToHave': niceToHave,
    };
  }

  static JobCardModel fromJson(Map<String, dynamic> json) {
    return JobCardModel(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      location: json['location'],
      duration: json['duration'],
      education: json['education'],
      salary: json['salary'],
      languages: json['languages'],
      jobType: json['jobType'],
      experience: json['experience'],
      skills: List<String>.from(json['skills']),
      niceToHave: List<String>.from(json['niceToHave']),
    );
  }
}
