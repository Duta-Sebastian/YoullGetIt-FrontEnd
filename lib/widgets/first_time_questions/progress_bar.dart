import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final String currentQuestionId;
  final int totalQuestions;

  const ProgressBar({
    super.key,
    required this.currentQuestionId,
    required this.totalQuestions,
  });

  // Define the question groups and their labels
  static const List<_ProgressStep> _steps = [
    _ProgressStep(
      label: 'Education',
      description: 'Your studies',
      questionIds: ['q1', 'q2', 'q2_yes_1', 'q2_yes_2', 'q2_no', 'q3'],
    ),
    _ProgressStep(
      label: 'Field',
      description: 'Area of study',
      questionIds: ['q4', 'q4_eng', 'q4_it', 'q5'],
    ),
    _ProgressStep(
      label: 'Experience',
      description: 'Work history',
      questionIds: ['q6', 'q7'],
    ),
    _ProgressStep(
      label: 'Skills',
      description: 'Your abilities',
      questionIds: ['q8', 'q9', 'q10'],
    ),
    _ProgressStep(
      label: 'Preferences',
      description: 'Internship details',
      questionIds: ['q11', 'q12', 'q13', 'q14', 'q15'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentStepIndex = _getCurrentStepIndex();
    
    return Container(
      height: 24,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(_steps.length, (index) {
          final isCompleted = index < currentStepIndex;
          final isCurrent = index == currentStepIndex;
          
          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress line for this step
                Container(
                  height: 8,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isCompleted || isCurrent
                        ? Color(0xFFFFDE15)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                
                SizedBox(height: 4),
                
                // Step label
                Flexible(
                  child: Text(
                    _steps[index].label,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: isCurrent || isCompleted 
                          ? FontWeight.w600 
                          : FontWeight.w400,
                      color: isCurrent || isCompleted 
                          ? Colors.black87 
                          : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
  
  int _getCurrentStepIndex() {    
    for (int i = 0; i < _steps.length; i++) {
      if (_steps[i].questionIds.contains(currentQuestionId)) {
        return i;
      }
    }
    
    debugPrint('Question $currentQuestionId not found in any step, defaulting to step 0');
    return 0;
  }
}

class _ProgressStep {
  final String label;
  final String description;
  final List<String> questionIds;
  
  const _ProgressStep({
    required this.label,
    required this.description,
    required this.questionIds,
  });
}