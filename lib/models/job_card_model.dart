import 'package:flutter/material.dart';

class JobCardModel {
  final String id; // feedback_id
  final String title; // role_name
  final String company; // company_name
  final String location; // job_location
  final String duration; // was not in Pydantic model, keeping from original
  final List<String> education; // required_degree
  final String workMode; // work_mode  
  final String jobType; // time_spent
  final String salary; // expected_salary
  final List<String> languages; // required_spoken_languages
  final List<String> hardSkills; // hard_skills
  final List<String> softSkills; // soft_skills
  final List<String> niceToHave; // nice_to_haves in Pydantic
  final String description; // description
  final List<String> requirements; // requirements
  final double matchScore; // match_score
  final String jobUrl; // url
  
  JobCardModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.duration,
    required this.education,
    required this.workMode,
    required this.jobType,
    required this.salary,
    required this.languages,
    required this.hardSkills,
    required this.softSkills,
    required this.niceToHave,
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
      'time_spent': duration,
      'work_mode': workMode,
      'required_degree': education,
      'expected_salary': salary,
      'required_spoken_languages': languages,
      'hard_skills': hardSkills,
      'soft_skills': softSkills,
      'nice_to_haves': niceToHave,
      'description': description,
      'requirements': requirements,
      'match_score': matchScore,
      'url': jobUrl,
    };
  }

  static JobCardModel fromJson(Map<String, dynamic> json) {    
    String id = json['feedback_id'] ?? '';
    String title = json['role_name'] ?? '';
    String company = json['company_name'] ?? '';
    
    double matchScore = 0.0;
    if (json['match_score'] != null) {
      try {
        matchScore = double.parse(json['match_score'].toString());
      } catch (e) {
        debugPrint("Error parsing match_score: $e");
      }
    }
    
    List<String> getStringList(dynamic field) {
      if (field == null) return [];
      if (field is List) {
        return field.map((item) => item.toString()).toList();
      }
      return [];
    }
    
    return JobCardModel(
      id: id,
      title: title,
      company: company,
      location: json['job_location'] ?? '',
      duration: json['time_spent'] ?? '',
      workMode: json['work_mode'] ?? '',
      jobType: json['job_type'] ?? '',
      education: getStringList(json['required_degree']),
      salary: json['expected_salary'] ?? '',
      languages: getStringList(json['required_spoken_languages']),
      hardSkills: getStringList(json['hard_skills']),
      softSkills: getStringList(json['soft_skills']),
      niceToHave: getStringList(json['nice_to_haves']),
      description: json['description'] ?? '',
      requirements: getStringList(json['requirements']),
      matchScore: matchScore,
      jobUrl: json['url'] ?? '',
    );
  }
}