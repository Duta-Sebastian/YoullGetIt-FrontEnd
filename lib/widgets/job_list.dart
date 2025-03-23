import 'package:flutter/material.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/widgets/job_list_item.dart';

class JobList extends StatefulWidget {
  final List<JobCardModel> jobs;
  final Map<int,bool> selectedJobs;
  final Function(JobCardModel)? onJobRemoved;
  final Function(List<JobCardModel>)? onSelectionChanged;
  final Function(JobCardModel)? onJobTapped;
  final Database database;

  const JobList({
    super.key,
    required this.database,
    required this.jobs,
    required this.selectedJobs,
    this.onJobRemoved,
    this.onSelectionChanged,
    this.onJobTapped,
  });

  @override
  State<JobList> createState() => JobListState();
}

class JobListState extends State<JobList> {
  late final Database database;
  late Set<int> selectedJobIds;
  @override
  void initState() {
    super.initState();
    database = widget.database;
    selectedJobIds = widget.selectedJobs.keys.where((key) => widget.selectedJobs[key]!).toSet();
  }
  
  int? longPressedJobId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _resetLongPress,
      behavior: HitTestBehavior.translucent,
      child: ListView.builder(
        itemCount: widget.jobs.length,
        itemBuilder: _buildJobListItem,
      ),
    );
  }

  Widget _buildJobListItem(BuildContext context, int index) {
    final job = widget.jobs[index];
    final bool isSelected = selectedJobIds.contains(job.id);
    final bool isLongPressed = job.id == longPressedJobId;
    final bool isBlurred = longPressedJobId != null && !isLongPressed;
    
    return JobListItem(
      job: job,
      isSelected: isSelected,
      isLongPressed: isLongPressed,
      isBlurred: isBlurred,
      onChanged: (selected) => _handleSelectionChanged(job, selected),
      onLongPress: () => _handleLongPress(job.id),
      onRemove: () => _handleRemove(job),
    );
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
        DatabaseManager.updateJobStatus(database, job.id, 'to_apply');
      } else {
        selectedJobIds.remove(job.id);
      }
      
      _notifySelectionChanged();
    });
    
    widget.onJobTapped?.call(job);
  }

  void _notifySelectionChanged() {
    if (widget.onSelectionChanged != null) {
      final selectedJobs = widget.jobs
          .where((job) => selectedJobIds.contains(job.id))
          .toList();
      widget.onSelectionChanged!(selectedJobs);
    }
  }

  void _handleLongPress(int jobId) {
    setState(() {
      longPressedJobId = jobId;
    });
  }

  void _handleRemove(JobCardModel job) {
    widget.onJobRemoved?.call(job);
    
    setState(() {
      longPressedJobId = null;
      selectedJobIds.remove(job.id);
    });
  }
}