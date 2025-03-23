import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/providers/database_provider.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/widgets/job_list.dart';
import 'package:youllgetit_flutter/widgets/job_tab_bar.dart';
import 'package:youllgetit_flutter/widgets/checklist_card.dart';

class JobCartScreen extends ConsumerStatefulWidget {
  const JobCartScreen({super.key});

  @override
  JobCartScreenState createState() => JobCartScreenState();
}

class JobCartScreenState extends ConsumerState<JobCartScreen> {
  int? jobCount;
  List<JobCardModel> jobCart = [];
  final Map<int, bool> selectedJobs = {};
  Database? database;
  int _selectedIndex = 0;
  Set<int> selectedJobIds = {};
  int? longPressedJobId;
  
  @override
  void initState() {
    super.initState();
    _loadDatabase();
    _loadJobCount();
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _loadDatabase() async {
    database = ref.read(databaseProvider).value;
  }

  Future<void> _loadJobCount() async {
    if (database != null) {
      final count = await DatabaseManager.getLikedJobCount(database!);
      final jobs = await DatabaseManager.retrieveAllLikedJobs(database!);
      if (mounted) {
        setState(() {
          jobCount = count;
          jobCart = jobs.map((e) => e.jobCard).toList();
          selectedJobs.clear();
          for (var job in jobs) {
            bool isSelected = false;
            if (job.status == 'to_apply') {
              isSelected = true;
            }
            selectedJobs[job.jobCard.id] = isSelected;
          }
          selectedJobIds = selectedJobs.keys.where((key) => selectedJobs[key]!).toSet();
        });
      }
    }
  }
  
  void _resetLongPress() {
    if (longPressedJobId != null) {
      setState(() {
        longPressedJobId = null;
      });
    }
  }

  void _handleSelectionChanged(JobCardModel job, bool selected) {
    setState(() {
      longPressedJobId = null;
      
      if (selected) {
        selectedJobIds.add(job.id);
        selectedJobs[job.id] = true;
        if (database != null) {
          DatabaseManager.updateJobStatus(database!, job.id, 'to_apply');
        }
      } else {
        selectedJobIds.remove(job.id);
        selectedJobs[job.id] = false;
        if (database != null) {
          DatabaseManager.updateJobStatus(database!, job.id, 'liked');
        }
      }
    });
  }

  void _handleLongPress(int jobId) {
    setState(() {
      longPressedJobId = jobId;
    });
  }

  void _handleRemove(JobCardModel job) {
    Future(() async {
      if (database != null) {
        await DatabaseManager.deleteJob(database!, job.id);
        _loadJobCount();
      }
    });
    
    setState(() {
      longPressedJobId = null;
      selectedJobIds.remove(job.id);
      selectedJobs.remove(job.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (jobCount == null || database == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
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
                        '$jobCount potential jobs',
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
              child: _selectedIndex == 0
              ? GestureDetector(
                  onTap: _resetLongPress,
                  behavior: HitTestBehavior.translucent,
                  child: JobList(
                    jobs: jobCart,
                    selectedJobs: selectedJobs,
                    onJobTapped: (job) {},
                    onJobRemoved: _handleRemove,
                    database: database!,
                    longPressedJobId: longPressedJobId,
                    onLongPress: _handleLongPress,
                    onSelectionChanged: _handleSelectionChanged,
                  ),
                )
              : const SizedBox(),
            )
          ],
        ),
      ),
    );
  }
}