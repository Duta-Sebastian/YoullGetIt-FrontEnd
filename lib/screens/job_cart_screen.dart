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
          jobCart = jobs;
          // Initialize selection state
          selectedJobs.clear();
          for (var job in jobs) {
            selectedJobs[job.id] = false;
          }
        });
      }
    }
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
            _selectedIndex == 0 ? ChecklistCard() : const SizedBox(),
            Expanded(
              child: _selectedIndex == 0
              ? JobList(
                jobs: jobCart,
                onJobTapped: (job) {
                  
                  print(job.title);
                },
                onJobRemoved: (job) {
                  Future(() async {
                    await DatabaseManager.deleteJob(database!, job.id);
                    _loadJobCount();
                  }); 
                }
              )
              : SizedBox(),
            )
          ],
        ),
      ),
    );
  }
}