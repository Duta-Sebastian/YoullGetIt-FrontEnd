import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/widgets/job_list_item.dart';

class JobList extends StatefulWidget {
  final List<JobCardModel> jobs;
  final Function(JobCardModel)? onJobRemoved;
  final Function(List<JobCardModel>)? onSelectionChanged;
  final Function(JobCardModel)? onJobTapped; 
  
  const JobList({
    super.key,
    required this.jobs,
    this.onJobRemoved,
    this.onSelectionChanged,
    this.onJobTapped
  });

  @override
  State<JobList> createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  Set<int> selectedJobIds = {};
  int? longPressedJobId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (longPressedJobId != null) {
          setState(() {
            longPressedJobId = null;
          });
        }
      },
      behavior: HitTestBehavior.translucent,
      child: ListView.builder(
        itemCount: widget.jobs.length,
        itemBuilder: (context, index) {
          final job = widget.jobs[index];
          final bool isSelected = selectedJobIds.contains(job.id);
          final bool isLongPressed = job.id == longPressedJobId;
          final bool isBlurred = longPressedJobId != null && !isLongPressed;
          
          return JobListItem(
            job: job,
            isSelected: isSelected,
            isLongPressed: isLongPressed,
            isBlurred: isBlurred,
            onChanged: (value) {
              setState(() {
                longPressedJobId = null;
                
                if (value == true) {
                  selectedJobIds.add(job.id);
                } else {
                  selectedJobIds.remove(job.id);
                }
                
                if (widget.onSelectionChanged != null) {
                  final selectedJobs = widget.jobs
                      .where((j) => selectedJobIds.contains(j.id))
                      .toList();
                  widget.onSelectionChanged!(selectedJobs);
                }
              });
              if (widget.onJobTapped != null) {
                widget.onJobTapped!(job);
              }
            },
            onLongPress: () {
              setState(() {
                longPressedJobId = job.id;
              });
            },
            onRemove: () {
              if (widget.onJobRemoved != null) {
                widget.onJobRemoved!(job);
              }
              setState(() {
                longPressedJobId = null;
                selectedJobIds.remove(job.id);
              });
            },
          );
        },
      ),
    );
  }
}