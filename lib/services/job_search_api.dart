import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/models/job_search_response.dart';

class JobSearchAPI {
  static const String baseUrl = "https://api2.youllgetit.eu";
  static const String endpoint = '/manual_search_endpoint';

  static Future<JobSearchResponse> searchJobs({
    String? query,
    String? field,
    String? location,
    String? workMode,
    List<String>? skills,
    String? company,
    int page = 1,
    int pageSize = 10,
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page.toString(),
      'page_size': pageSize.toString(),
    };
    
    if (field != null && field.isNotEmpty && field != 'All') {
      queryParams['field'] = field;
    }
    
    if (location != null && location.isNotEmpty) {
      queryParams['country'] = location;
    }
    
    if (workMode != null && workMode.isNotEmpty && workMode != 'All') {
      queryParams['work_mode'] = workMode;
    }
    
    if (company != null && company.isNotEmpty) {
      queryParams['company'] = company;
    }
    
    if (query != null && query.isNotEmpty && company == null) {
      queryParams['company'] = query;
    }
    
    if (skills != null && skills.isNotEmpty) {
      queryParams['skills'] = skills.join(',');
    }
    
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
    
    try {      
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final List<dynamic> jobsData = json.decode(response.body);
        
        debugPrint('Received ${jobsData.length} jobs from API');
        
        final List<JobCardModel> jobs = jobsData.map((jobData) {
          return JobCardModel.fromJson(jobData["internship"]);
        }).toList();

        final bool hasMorePages = jobs.length >= pageSize;
        
        final int totalCount = hasMorePages 
            ? (page * pageSize) + pageSize
            : (page - 1) * pageSize + jobs.length;
        
        return JobSearchResponse(
          jobs: jobs,
          totalCount: totalCount,
          currentPage: page,
          hasMorePages: hasMorePages,
        );
      } else {
        debugPrint('API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load jobs: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('API Exception: $e');
      throw Exception('Error connecting to job search API: $e');
    }
  }
}