class JobCardModel {
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
}
