import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/models/job_card/job_card_model.dart';
import 'package:youllgetit_flutter/providers/connectivity_provider.dart';
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
  List<String>_workMode = [];
  List<String>_field = [];
  List<String>_selectedSkills = [];
  List<String>_durations = [];
  bool _isPaidInternship = false;
  
  List<JobCardModel> _jobs = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMorePages = true;
  bool _hasInitialized = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      _hasInitialized = true;
      // Get connectivity status from build context and pass it
      final connectivityStatus = ref.read(isConnectedProvider);
      final isConnected = connectivityStatus.when(
        data: (value) => value,
        loading: () => true, // Changed to true to be optimistic during loading
        error: (_, __) => false
      );
      _fetchJobs(isConnected: isConnected);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchJobs({bool reset = false, bool? isConnected}) async {
    final localizations = AppLocalizations.of(context)!;
    
    if (_isLoading) {
      debugPrint('Already loading, skipping fetch');
      return;
    }

    // Use passed connectivity status or get current snapshot
    bool connected = isConnected ?? true; // Default to true if not provided
    
    if (isConnected == null) {
      // Fallback to reading current state
      final connectivityStatus = ref.read(isConnectedProvider);
      connected = connectivityStatus.when(
        data: (value) => value,
        loading: () => true, // Changed to true to be optimistic
        error: (_, __) => false
      );
    }

    debugPrint('JobSearchScreen: Using connectivity status = $connected');

    if (!connected) {
      debugPrint('JobSearchScreen: No internet connection, skipping API call');
      if (mounted && context.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations.jobSearchNoInternetSnackbar),
                backgroundColor: Colors.orange,
              ),
            );
          }
        });
      }
      return;
    }

    debugPrint('JobSearchScreen: Proceeding with API call');
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
        workModes: _workMode.isEmpty ? null : _workMode,
        skills: _selectedSkills.isEmpty ? null : _selectedSkills,
        fields: _field.isEmpty ? null : _field,
        durations: _durations.isEmpty ? null : _durations,
        isPaidInternship: _isPaidInternship,
        company: _company,
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
        
        if (context.mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localizations.jobSearchErrorLoading(e.toString()))),
              );
            }
          });
        }
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
      
      // Pass current connectivity status
      final connectivityStatus = ref.read(isConnectedProvider);
      final isConnected = connectivityStatus.when(
        data: (value) => value,
        loading: () => true,
        error: (_, __) => false
      );
      _fetchJobs(isConnected: isConnected);
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
          initialDurations: _durations,
          initialIsPaidInternship: _isPaidInternship,
        ),
      ),
    );
    
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _searchController.text = result['query'] ?? '';
        _location = result['location'];
        _company = result['company'];
        _workMode = List<String>.from(result['workModes'] ?? []);
        _field = List<String>.from(result['fields'] ?? []);
        _durations = List<String>.from(result['durations'] ?? []);
        _selectedSkills = List<String>.from(result['skills'] ?? []);
        _isPaidInternship = result['isPaidInternship'] ?? false;
      });
      
      // Pass current connectivity status
      final connectivityStatus = ref.read(isConnectedProvider);
      final isConnected = connectivityStatus.when(
        data: (value) => value,
        loading: () => true,
        error: (_, __) => false
      );
      _fetchJobs(reset: true, isConnected: isConnected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final connectivityStatus = ref.watch(isConnectedProvider);
    final bool isConnected = connectivityStatus.when(
      data: (value) => value,
      loading: () => true, // Changed to true to be optimistic during loading
      error: (_, __) => false
    );
    
    debugPrint('JobSearchScreen: Connectivity status = $isConnected, state = ${connectivityStatus.toString()}');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          localizations.jobSearchTitle,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
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
          // Offline banner - only show when we're confirmed offline
          if (!isConnected && connectivityStatus is AsyncData) 
            Container(
              color: Colors.amber.shade100,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.wifi_off, size: 16, color: Colors.amber.shade800),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      localizations.jobSearchOfflineNotice,
                      style: TextStyle(fontSize: 12, color: Colors.amber.shade800),
                    ),
                  ),
                ],
              ),
            ),
          
          _buildResultInfo(localizations),
          Expanded(
            child: _jobs.isEmpty && !_isLoading
                ? _buildEmptyState(isConnected, localizations)
                : _buildJobsList(isConnected, localizations),
          ),
        ],
      ),
    );
  }

  Widget _buildResultInfo(AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              localizations.jobSearchScrollToDiscover,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.white
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
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

  Widget _buildJobsList(bool isConnected, AppLocalizations localizations) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo is ScrollEndNotification && 
            scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 50) {
          // Only try to load next page if connected
          if (isConnected) {
            _loadNextPage();
          }
        }
        return false;
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _jobs.length + (_hasMorePages && isConnected ? 1 : 0),
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizations.jobSearchAddedToFavorites(job.roleName)),
                  duration: const Duration(seconds: 2),
                  backgroundColor: const Color(0xFF22C55E),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isConnected, AppLocalizations localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            !isConnected ? Icons.wifi_off_rounded : Icons.search_off_rounded,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            !isConnected ? localizations.jobSearchNoInternetConnection : localizations.jobSearchNoJobsFound,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            !isConnected 
                ? localizations.jobSearchCheckConnection
                : localizations.jobSearchTryAdjustingFilters,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (!isConnected)
            ElevatedButton.icon(
              onPressed: () {
                // Get current connectivity and retry
                final connectivityStatus = ref.read(isConnectedProvider);
                final isConnected = connectivityStatus.when(
                  data: (value) => value,
                  loading: () => true,
                  error: (_, __) => false
                );
                _fetchJobs(reset: true, isConnected: isConnected);
              },
              icon: const Icon(Icons.refresh),
              label: Text(localizations.jobSearchRetry),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _location = null;
                  _company = null;
                  _workMode = [];
                  _field = [];
                  _selectedSkills = [];
                  _durations = [];
                  _isPaidInternship = false;
                });
                
                // Get current connectivity and reset
                final connectivityStatus = ref.read(isConnectedProvider);
                final isConnected = connectivityStatus.when(
                  data: (value) => value,
                  loading: () => true,
                  error: (_, __) => false
                );
                _fetchJobs(reset: true, isConnected: isConnected);
              },
              icon: const Icon(Icons.refresh),
              label: Text(localizations.jobSearchResetFilters),
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