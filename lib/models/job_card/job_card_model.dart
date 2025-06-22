import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:youllgetit_flutter/models/job_card/job_deadline_model.dart';
import 'package:youllgetit_flutter/models/job_card/job_location_model.dart';

class JobCardModel {
  final String feedbackId; // feedback_id
  final String roleName; // role_name
  final String companyName; // company_name
  final List<JobLocationModel> jobLocation; // job_location 
  final List<String> relatedFields; // related_fields
  final String workMode; // work_mode
  final String timeSpent; // time_spent
  final double durationInMonths; // duration_in_months
  final String internshipSeason; // internship_season
  final List<String> allowedGraduationYears; // allowed_graduation_year
  final List<String> requiredSpokenLanguages; // required_spoken_languages
  final List<String> requiredDegree; // required_degree
  final String expectedSalary; // expected_salary
  final JobDeadline? deadline; // deadline (nullable)
  final String visaHelp; // visa_help
  final List<String> requirements; //requirements
  final String description; // description
  final List<String> hardSkills; // hard_skills
  final List<String> softSkills; // soft_skills
  final List<String> niceToHaves; // nice_to_haves
  final String url; // url
  final double? matchScore; // match_score
  
  JobCardModel({
    required this.feedbackId,
    required this.roleName,
    required this.companyName,
    required this.jobLocation,
    required this.relatedFields,
    required this.workMode,
    required this.timeSpent,
    required this.durationInMonths,
    required this.internshipSeason,
    required this.allowedGraduationYears,
    required this.requiredSpokenLanguages,
    required this.requiredDegree,
    required this.expectedSalary,
    this.deadline,
    required this.visaHelp,
    required this.requirements,
    required this.description,
    required this.hardSkills,
    required this.softSkills,
    required this.niceToHaves,
    required this.url,
    this.matchScore,
  });

  Map<String, dynamic> toJson() {
    return {
      'feedback_id': feedbackId,
      'role_name': roleName,
      'company_name': companyName,
      'job_location': jobLocation.map((location) => location.toJson()).toList(),
      'related_fields': relatedFields,
      'work_mode': workMode,
      'time_spent': timeSpent,
      'duration_in_months': durationInMonths,
      'internship_season': internshipSeason,
      'allowed_graduation_years': allowedGraduationYears,
      'required_spoken_languages': requiredSpokenLanguages,
      'required_degree': requiredDegree,
      'expected_salary': expectedSalary,
      'deadline': deadline?.toJson(),
      'visa_help': visaHelp,
      'requirements': requirements,
      'description': description,
      'hard_skills': hardSkills,
      'soft_skills': softSkills,
      'nice_to_haves': niceToHaves,
      'url': url,
      'match_score': matchScore,
    };
  }

  static JobCardModel fromJson(Map<String, dynamic> json) {    
    List<String> getStringList(dynamic field) {
      if (field == null || field is! List) {
        return [];
      } 
      else {
        return field.map((item) => item.toString()).toList();
      }
    }
    
    return JobCardModel(
      feedbackId: json['feedback_id'] ?? "",
      roleName: json['role_name'] ?? "",
      companyName: json['company_name'] ?? "",
      jobLocation: JobLocationModel.jobLocationModelListFactory(json['job_locations']),
      relatedFields: getStringList(json['related_fields']),
      workMode: json['work_mode'] ?? "",
      timeSpent: json['time_spent'] ?? "",
      durationInMonths: (json['duration_in_months'] ?? 0.0).toDouble(),
      internshipSeason: json['internship_season'] ?? "",
      allowedGraduationYears: getStringList(json['allowed_graduation_years']),
      requiredSpokenLanguages: getStringList(json['required_spoken_languages']),
      requiredDegree: getStringList(json['required_degree']),
      expectedSalary: json['expected_salary'] ?? "",
      deadline: JobDeadline.fromJson(json['deadline']),
      visaHelp: json['visa_help'] ?? "",
      requirements: getStringList(json['requirements']),
      description: json['description'] ?? "",
      hardSkills: getStringList(json['hard_skills']),
      softSkills: getStringList(json['soft_skills']),
      niceToHaves: getStringList(json['nice_to_haves']),
      url: json['url'] ?? "",
      matchScore: json['match_score']?.toDouble(),
    );
  }

  static List<JobCardModel> jobCardModelListFactory(List<dynamic> jobsData){
    return jobsData.map((job) {
      const encoder = JsonEncoder.withIndent('  ');
      debugPrint(encoder.convert(job["internship"]));
      return JobCardModel.fromJson(job["internship"]);
    }).toList().reversed.toList();
  }
}