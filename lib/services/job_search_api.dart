import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:youllgetit_flutter/models/job_card/job_card_model.dart';
import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/models/job_search_response.dart';

class JobSearchAPI {
  static const String baseUrl = "https://api2.youllgetit.eu";
  static const String endpoint = '/manual_search_endpoint';

  static Future<JobSearchResponse> searchJobs({
    String? query,
    String? location,
    String? company,
    List<String>? workModes,
    List<String>? skills,
    List<String>? fields,
    List<String>? durations,
    bool? isPaidInternship,
    int page = 1,
    int pageSize = 10,
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page.toString(),
      'page_size': pageSize.toString(),
    };
    
    if (fields != null && fields.isNotEmpty) {
      queryParams['job_fields'] = fields.join(',');
    }
    
    if (location != null && location.isNotEmpty) {
      queryParams['country'] = location;
    }
    
    if (workModes != null && workModes.isNotEmpty) {
      queryParams['work_modes'] = workModes.join(',');
    }

    if (durations != null && durations.isNotEmpty) {
      queryParams['durations'] = durations.join(',');
    }
    
    if (company != null && company.isNotEmpty) {
      queryParams['company'] = company;
    }
    
    if (query != null && query.isNotEmpty) {
      queryParams['role'] = query;
    }
    
    if (skills != null && skills.isNotEmpty) {
      queryParams['skills'] = skills.join(',');
    }

    if (isPaidInternship != null) {
      queryParams['is_paid_internship'] = isPaidInternship.toString();
    }

    debugPrint('JobSearchAPI: Searching with query params: $queryParams');
    
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
    debugPrint('JobSearchAPI: Request URI: $uri');
    try {      
      // ADD UTF-8 HEADERS
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json; charset=utf-8',
          'Content-Type': 'application/json; charset=utf-8',
        },
      );
      
      if (response.statusCode == 200) {
        // DECODE WITH UTF-8 EXPLICITLY
        final String responseBody = utf8.decode(response.bodyBytes);
        // debugPrint('JobSearchAPI: Response body: $responseBody');
        final jobs = JobCardModel.jobCardModelListFactory(json.decode(responseBody) as List<dynamic>);

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