import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/models/job_status.dart';
import 'package:youllgetit_flutter/services/notification_manager.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/widgets/jobs/job_list.dart';
import 'package:youllgetit_flutter/widgets/jobs/job_tab_bar.dart';
import 'package:youllgetit_flutter/widgets/jobs/checklist_card.dart';

class JobCartScreen extends StatefulWidget {
  const JobCartScreen({super.key});

  @override
  JobCartScreenState createState() => JobCartScreenState();
}

class JobCartScreenState extends State<JobCartScreen> with SingleTickerProviderStateMixin {
  int? jobCount;
  List<JobCardModel> allJobs = [];
  final Map<String, JobStatus> jobStatuses = {};
  int _selectedIndex = 0;
  StreamSubscription? _jobCartUpdateSubscription;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _loadJobs();

    _jobCartUpdateSubscription = NotificationManager.instance.onJobCartUpdated.listen((_) {
      debugPrint('JobCartScreen: Received job cart update notification, refreshing data');
      _loadJobs();
    });
  }

  @override
  void dispose() {
    _jobCartUpdateSubscription?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _animationController.reset();
      _animationController.forward();
    });
  }

  String getTabTitle(int index) {
    switch (index) {
      case 0:
        return 'potential opportunities';
      case 1:
        return 'applications remaining';
      case 2:
        return 'applications completed';
      default:
        return '';
    }
  }

  Future<void> _loadJobs() async {
    setState(() {
      _isLoading = true;
    });
    
    final jobs = await DatabaseManager.retrieveAllJobs();
    if (mounted) {
      setState(() {
        allJobs = jobs.map((e) => e.jobCard).toList();
        jobStatuses.clear();
        for (var job in jobs) {
          jobStatuses[job.jobCard.id] = job.status;
        }
        jobCount = allJobs.length;
        _isLoading = false;
        _animationController.forward();
      });
    }
  }

  void _handleStatusChanged(JobCardModel job, JobStatus newStatus) {
    setState(() {
      jobStatuses[job.id] = newStatus;
      DatabaseManager.updateJobStatus(job.id, newStatus);
    });
  }

  void _handleRemove(JobCardModel job, JobStatus status) {
    final previousStatus = status;
    
    Future(() async {
      await DatabaseManager.deleteJob(job.id);
      _loadJobs();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Text('${job.title} removed'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            DatabaseManager.insertJobCard(job);
            DatabaseManager.updateJobStatus(job.id, previousStatus);
            _loadJobs();
          },
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(8),
      ),
    );
    
    setState(() {
      jobStatuses.remove(job.id);
    });
  }

  List<JobCardModel> _getFilteredJobs() {
    switch (_selectedIndex) {
      case 0:
        return allJobs.where((job) => jobStatuses[job.id] == JobStatus.liked).toList();
      case 1:
        return allJobs.where((job) => jobStatuses[job.id] == JobStatus.toApply).toList();
      case 2:
        return allJobs.where((job) => jobStatuses[job.id] == JobStatus.applied).toList();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Loading your job cart...',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final filteredJobs = _getFilteredJobs();
    final bool hasJobs = filteredJobs.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(filteredJobs),
            JobTabBar(
              onTabSelected: _onTabSelected,
              selectedIndex: _selectedIndex
            ),
            const Divider(height: 1),
            _selectedIndex == 0 ? const ChecklistCard() : const SizedBox(),
            Expanded(
              child: hasJobs 
                ? FadeTransition(
                    opacity: _fadeAnimation,
                    child: JobList(
                      jobs: filteredJobs,
                      jobStatuses: Map.fromEntries(
                        filteredJobs.map((job) => MapEntry(job.id, jobStatuses[job.id]!))
                      ),
                      onJobRemoved: _handleRemove,
                      onStatusChanged: _handleStatusChanged,
                    ),
                  )
                : _buildEmptyState(),
            )
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader(List<JobCardModel> filteredJobs) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.03).round()),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Job Cart',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getTabColor(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${filteredJobs.length}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        getTabTitle(_selectedIndex),
                        style: TextStyle(
                          fontSize: 16,
                          color: _getTabColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: _loadJobs,
                icon: const Icon(Icons.refresh_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  foregroundColor: Colors.grey.shade700,
                ),
                tooltip: 'Refresh',
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
    String message;
    IconData icon;
    
    switch (_selectedIndex) {
      case 0:
        message = "You haven't liked any jobs yet";
        icon = Icons.thumb_up_outlined;
        break;
      case 1:
        message = "No applications to complete";
        icon = Icons.edit_document;
        break;
      case 2:
        message = "You haven't completed any applications";
        icon = Icons.check_circle_outline;
        break;
      default:
        message = "No jobs found";
        icon = Icons.work_outline;
    }
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedIndex == 0 
                ? "Start browsing jobs to build your collection"
                : "Move jobs to this stage to see them here",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getTabColor() {
    switch (_selectedIndex) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}