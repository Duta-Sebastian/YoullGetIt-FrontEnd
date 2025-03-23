import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/models/job_status.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/widgets/job_list.dart';
import 'package:youllgetit_flutter/widgets/job_tab_bar.dart';
import 'package:youllgetit_flutter/widgets/checklist_card.dart';

class JobCartScreen extends StatefulWidget {
  const JobCartScreen({super.key});

  @override
  JobCartScreenState createState() => JobCartScreenState();
}

class JobCartScreenState extends State<JobCartScreen> {
  int? jobCount;
  List<JobCardModel> jobCart = [];
  final Map<int, bool> selectedJobs = {};
  int _selectedIndex = 0;
  int? longPressedJobId;
  
  @override
  void initState() {
    super.initState();
    _loadJobCount();
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _loadJobCount() async {
    final count = await DatabaseManager.getLikedJobCount();
    final jobs = await DatabaseManager.retrieveAllJobs();
    if (mounted) {
      setState(() {
        jobCount = count;
        jobCart = jobs.map((e) => e.jobCard).toList();
        selectedJobs.clear();
        for (var job in jobs) {
          bool isSelected = false;
          if (job.status == JobStatus.toApply) {
            isSelected = true;
          }
          selectedJobs[job.jobCard.id] = isSelected;
        }
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

  void _handleSelectionChanged(JobCardModel job, bool selected) {
    setState(() {
      longPressedJobId = null;
      
      if (selected) {
        selectedJobs[job.id] = true;
        DatabaseManager.updateJobStatus(job.id, JobStatus.toApply);
      } else {
        selectedJobs[job.id] = false;
        DatabaseManager.updateJobStatus(job.id, JobStatus.liked);
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
      await DatabaseManager.deleteJob(job.id);
      _loadJobCount();
    });
    
    setState(() {
      longPressedJobId = null;
      selectedJobs.remove(job.id);
    });
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