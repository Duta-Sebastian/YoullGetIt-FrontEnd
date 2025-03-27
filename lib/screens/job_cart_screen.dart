import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/models/job_status.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/widgets/jobs/job_list.dart';
import 'package:youllgetit_flutter/widgets/jobs/job_tab_bar.dart';
import 'package:youllgetit_flutter/widgets/jobs/checklist_card.dart';

class JobCartScreen extends StatefulWidget {
  const JobCartScreen({super.key});

  @override
  JobCartScreenState createState() => JobCartScreenState();
}

class JobCartScreenState extends State<JobCartScreen> {
  int? jobCount;
  List<JobCardModel> allJobs = [];
  final Map<int, JobStatus> jobStatuses = {};
  int _selectedIndex = 0;
  int? longPressedJobId;
  
  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
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
    final jobs = await DatabaseManager.retrieveAllJobs();
    if (mounted) {
      setState(() {
        allJobs = jobs.map((e) => e.jobCard).toList();
        jobStatuses.clear();
        for (var job in jobs) {
          jobStatuses[job.jobCard.id] = job.status;
        }
        jobCount = allJobs.length;
      });
    }
  }
  
  void _resetLongPress() {
    if (longPressedJobId != null) {
      setState(() {
        longPressedJobId = null;
      });
    }
  }

  void _handleStatusChanged(JobCardModel job, JobStatus newStatus) {
    setState(() {
      longPressedJobId = null;
      
      jobStatuses[job.id] = newStatus;
      DatabaseManager.updateJobStatus(job.id, newStatus);
    });
  }

  void _handleLongPress(int jobId) {
    setState(() {
      longPressedJobId = jobId;
    });
  }

  void _handleRemove(JobCardModel job) {
    Future(() async {
      await DatabaseManager.deleteJob(job.id);
      _loadJobs();
    });
    
    setState(() {
      longPressedJobId = null;
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
    if (jobCount == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final filteredJobs = _getFilteredJobs();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Job Cart',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${filteredJobs.length} ${getTabTitle(_selectedIndex)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            JobTabBar(
              onTabSelected: _onTabSelected,
              selectedIndex: _selectedIndex
            ),
            const Divider(height: 1),
            _selectedIndex == 0 ? const ChecklistCard() : const SizedBox(),
            Expanded(
              child: GestureDetector(
                onTap: _resetLongPress,
                behavior: HitTestBehavior.translucent,
                child: JobList(
                  jobs: filteredJobs,
                  jobStatuses: Map.fromEntries(
                    filteredJobs.map((job) => MapEntry(job.id, jobStatuses[job.id]!))
                  ),
                  onJobRemoved: _handleRemove,
                  longPressedJobId: longPressedJobId,
                  onLongPress: _handleLongPress,
                  onStatusChanged: _handleStatusChanged,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}