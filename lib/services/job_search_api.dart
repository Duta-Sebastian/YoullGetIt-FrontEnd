// lib/services/mock_job_search_service.dart
import 'package:youllgetit_flutter/models/job_card_model.dart';

class MockJobSearchService {
  // Mock data to simulate API response
  final List<JobCardModel> _allJobs = List.generate(
    50,
    (index) => JobCardModel(
      id: 'job_$index',
      title: 'Software Developer ${index % 3 == 0 ? 'Senior' : index % 3 == 1 ? 'Mid-level' : 'Junior'}',
      company: 'Tech Company ${(index % 10) + 1}',
      location: index % 3 == 0 ? 'Remote' : index % 3 == 1 ? 'New York' : 'San Francisco',
      duration: 'Full-time',
      education: ['Bachelor\'s degree'],
      workMode: index % 3 == 0 ? 'Remote' : index % 3 == 1 ? 'Hybrid' : 'On-site',
      jobType: 'Full-time',
      salary: '\$${80 + index % 20}k - \$${110 + index % 30}k',
      languages: ['English', if (index % 3 == 0) 'Spanish'],
      hardSkills: [
        'Flutter',
        'Dart',
        if (index % 2 == 0) 'React',
        if (index % 3 == 0) 'Node.js',
        if (index % 4 == 0) 'Python',
      ],
      softSkills: [
        'Communication',
        'Teamwork',
        if (index % 2 == 0) 'Problem Solving',
      ],
      niceToHave: [
        if (index % 2 == 0) 'AWS',
        if (index % 3 == 0) 'Firebase',
      ],
      description: 'This is a job description for position $index. We are looking for talented developers to join our team.',
      requirements: [
        'Experience with Flutter',
        '${1 + index % 5}+ years of experience',
      ],
      matchScore: 0.5 + (index % 50) / 100,
      jobUrl: 'https://example.com/job/$index',
    ),
  );

  Future<JobSearchResponse> searchJobs({
    String? query,
    String? location,
    String? workMode,
    List<String>? hardSkills,
    int page = 1,
    int pageSize = 10,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Filter jobs based on query parameters
    List<JobCardModel> filteredJobs = _allJobs.where((job) {
      bool matches = true;
      
      if (query != null && query.isNotEmpty) {
        matches = matches && (
          job.title.toLowerCase().contains(query.toLowerCase()) ||
          job.company.toLowerCase().contains(query.toLowerCase())
        );
      }
      
      if (location != null && location.isNotEmpty) {
        matches = matches && job.location.toLowerCase().contains(location.toLowerCase());
      }
      
      if (workMode != null && workMode.isNotEmpty && workMode != 'All') {
        matches = matches && job.workMode == workMode;
      }
      
      if (hardSkills != null && hardSkills.isNotEmpty) {
        for (final skill in hardSkills) {
          matches = matches && job.hardSkills.contains(skill);
        }
      }
      
      return matches;
    }).toList();

    // Calculate pagination values
    final int totalCount = filteredJobs.length;
    final int totalPages = (totalCount / pageSize).ceil();
    
    // Apply pagination
    final int startIndex = (page - 1) * pageSize;
    final int endIndex = startIndex + pageSize > filteredJobs.length 
                         ? filteredJobs.length 
                         : startIndex + pageSize;
    
    // Check for valid indices
    List<JobCardModel> paginatedJobs = [];
    if (startIndex < filteredJobs.length) {
      paginatedJobs = filteredJobs.sublist(startIndex, endIndex);
    }

    return JobSearchResponse(
      jobs: paginatedJobs,
      totalCount: totalCount,
      currentPage: page,
      totalPages: totalPages,
    );
  }
}

class JobSearchResponse {
  final List<JobCardModel> jobs;
  final int totalCount;
  final int currentPage;
  final int totalPages;

  JobSearchResponse({
    required this.jobs,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
  });
}