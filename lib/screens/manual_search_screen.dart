// lib/screens/job_search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/providers/job_provider.dart';
import 'package:youllgetit_flutter/providers/navbar_animation_provider.dart';
import 'package:youllgetit_flutter/services/job_search_api.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/widgets/jobs/search_job_list_item.dart';

class JobSearchScreen extends ConsumerStatefulWidget  {
  const JobSearchScreen({super.key});

  @override
  ConsumerState<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends ConsumerState<JobSearchScreen> {
  final MockJobSearchService _jobService = MockJobSearchService();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  List<JobCardModel> _jobs = [];
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalCount = 0;
  bool _isLoading = false;
  bool _isFilterShown = false;
  String? _selectedWorkMode;
  List<String> _selectedSkills = [];

  final List<String> _workModeOptions = ['All', 'Remote', 'Hybrid', 'On-site'];
  final List<String> _skillOptions = [
    'Flutter',
    'Dart',
    'React',
    'Node.js', 
    'Python',
    'AWS',
    'Firebase'
  ];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _locationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchJobs({bool reset = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (reset) {
        _currentPage = 1;
        _jobs = [];
      }
    });

    try {
      final response = await _jobService.searchJobs(
        query: _searchController.text,
        location: _locationController.text,
        workMode: _selectedWorkMode == 'All' ? null : _selectedWorkMode,
        hardSkills: _selectedSkills.isEmpty ? null : _selectedSkills,
        page: _currentPage,
        pageSize: 10,
      );

      setState(() {
        if (reset || _currentPage == 1) {
          _jobs = response.jobs;
        } else {
          _jobs.addAll(response.jobs);
        }
        _totalCount = response.totalCount;
        _totalPages = response.totalPages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading jobs: $e')),
      );
    }
  }

  void _loadNextPage() {
    if (_currentPage < _totalPages && !_isLoading) {
      setState(() {
        _currentPage++;
      });
      _fetchJobs();
    }
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _locationController.clear();
      _selectedWorkMode = null;
      _selectedSkills = [];
      _isFilterShown = false;
    });
    _fetchJobs(reset: true);
  }

  void _toggleSkill(String skill) {
    setState(() {
      if (_selectedSkills.contains(skill)) {
        _selectedSkills.remove(skill);
      } else {
        _selectedSkills.add(skill);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Job Search',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFilterShown ? Icons.filter_list_off : Icons.filter_list,
              color: Colors.blue.shade700,
            ),
            onPressed: () {
              setState(() {
                _isFilterShown = !_isFilterShown;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          if (_isFilterShown) _buildFilters(),
          _buildResultInfo(),
          Expanded(
            child: _jobs.isEmpty && !_isLoading
                ? _buildEmptyState()
                : _buildJobsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search jobs, titles, companies...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _fetchJobs(reset: true);
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onSubmitted: (_) => _fetchJobs(reset: true),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location filter
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              hintText: 'Enter location',
              prefixIcon: const Icon(Icons.location_on_outlined),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onSubmitted: (_) => _fetchJobs(reset: true),
          ),
          
          const SizedBox(height: 16),
          
          // Work mode filter
          const Text(
            'Work Mode',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _workModeOptions.map((mode) {
                final bool isSelected = _selectedWorkMode == mode;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(mode),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedWorkMode = selected ? mode : null;
                      });
                      _fetchJobs(reset: true);
                    },
                    backgroundColor: Colors.grey.shade100,
                    selectedColor: Colors.blue.shade100,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.blue.shade800 : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Skills filter
          const Text(
            'Skills',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _skillOptions.map((skill) {
              final bool isSelected = _selectedSkills.contains(skill);
              return FilterChip(
                label: Text(skill),
                selected: isSelected,
                onSelected: (selected) {
                  _toggleSkill(skill);
                  _fetchJobs(reset: true);
                },
                backgroundColor: Colors.grey.shade100,
                selectedColor: Colors.blue.shade100,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.blue.shade800 : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 16),
          
          // Reset filters button
          Center(
            child: TextButton.icon(
              onPressed: _resetFilters,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Filters'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.grey.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$_totalCount Jobs Found',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_isLoading)
            SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildJobsList() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _loadNextPage();
        }
        return false;
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _jobs.length + (_currentPage < _totalPages ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _jobs.length) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
                ),
              ),
            );
          }
          return SearchJobListItem(
            job: _jobs[index],
            onAddToLiked: (JobCardModel job) => {
               DatabaseManager.insertJobCard(job),
               ref.read(bookmarkAnimationProvider.notifier).triggerAnimation(),
               //ref.read(jobCoordinatorProvider).handleManualSearchAdd(job)
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No jobs found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search query',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _resetFilters,
            icon: const Icon(Icons.refresh),
            label: const Text('Reset Filters'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}