import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/providers/job_provider.dart';
import 'package:youllgetit_flutter/providers/navbar_animation_provider.dart';
import 'package:youllgetit_flutter/screens/job_filters_screen.dart';
import 'package:youllgetit_flutter/services/job_search_api.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/widgets/jobs/search_job_list_item.dart';

class JobSearchScreen extends ConsumerStatefulWidget {
  const JobSearchScreen({super.key});

  @override
  ConsumerState<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends ConsumerState<JobSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  String? _location;
  String? _company;
  String? _workMode;
  String? _field;
  List<String> _selectedSkills = [];
  
  List<JobCardModel> _jobs = [];
  int _currentPage = 1;
  int _totalCount = 0;
  bool _isLoading = false;
  bool _hasMorePages = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchJobs({bool reset = false}) async {
    if (_isLoading) {
      debugPrint('Already loading, skipping fetch');
      return;
    }

    debugPrint('Fetching jobs for page $_currentPage (reset: $reset)');

    setState(() {
      _isLoading = true;
      if (reset) {
        _currentPage = 1;
        _jobs = [];
        _hasMorePages = true;
      }
    });

    try {
      final response = await JobSearchAPI.searchJobs(
        query: _searchController.text,
        location: _location,
        workMode: _workMode == 'All' ? null : _workMode,
        skills: _selectedSkills.isEmpty ? null : _selectedSkills,
        company: _company,
        field: _field == 'All' ? null : _field,
        page: _currentPage,
        pageSize: 10,
      );

      if (mounted) {
        setState(() {
          if (reset || _currentPage == 1) {
            _jobs = response.jobs;
          } else {
            _jobs.addAll(response.jobs);
          }
          
          if (reset || _currentPage == 1) {
            _totalCount = response.jobs.length;
          } else {
            _totalCount = _jobs.length;
          }
          
          _hasMorePages = response.hasMorePages;
          _isLoading = false;
          
          debugPrint('Loaded ${response.jobs.length} jobs (total: ${_jobs.length})');
          debugPrint('Current page: $_currentPage, Has more pages: $_hasMorePages');
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasMorePages = false;
        });
        debugPrint('Error loading jobs: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading jobs: $e')),
        );
      }
    }
  }

  DateTime _lastScrollTime = DateTime.now();

  void _loadNextPage() {
    final now = DateTime.now();
    if (now.difference(_lastScrollTime).inMilliseconds < 500) {
      debugPrint('Debouncing scroll - ignoring request');
      return;
    }
    _lastScrollTime = now;
    
    if (_isLoading) {
      debugPrint('Already loading, skipping next page');
      return;
    }
    
    if (_hasMorePages) {
      debugPrint('Loading next page: ${_currentPage + 1}');
      setState(() {
        _currentPage++;
      });
      _fetchJobs();
    } else {
      debugPrint('No more pages to load');
    }
  }

  Future<void> _openFilters() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobFiltersScreen(
          initialQuery: _searchController.text,
          initialLocation: _location,
          initialCompany: _company,
          initialWorkMode: _workMode,
          initialField: _field,
          initialSkills: _selectedSkills,
        ),
      ),
    );
    
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _searchController.text = result['query'] ?? '';
        _location = result['location'];
        _company = result['company'];
        _workMode = result['workMode'];
        _field = result['field'];
        _selectedSkills = List<String>.from(result['skills'] ?? []);
      });
      
      _fetchJobs(reset: true);
    }
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
              Icons.filter_list,
              color: Colors.blue.shade700,
            ),
            onPressed: _openFilters,
          ),
        ],
      ),
      body: Column(
        children: [
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
        if (scrollInfo is ScrollEndNotification && 
            scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 50) {
          _loadNextPage();
        }
        return false;
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _jobs.length + (_hasMorePages ? 1 : 0),
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
            onAddToLiked: (JobCardModel job) {
              DatabaseManager.insertJobCard(job);
              ref.read(bookmarkAnimationProvider.notifier).triggerAnimation();
              //ref.read(jobCoordinatorProvider).handleManualSearchAdd(job);
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
            onPressed: () {
              setState(() {
                _searchController.clear();
                _location = null;
                _company = null;
                _workMode = null;
                _field = null;
                _selectedSkills = [];
              });
              _fetchJobs(reset: true);
            },
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