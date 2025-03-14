// job_cart_screen.dart
import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/widgets/job_tab_bar.dart';
import 'package:youllgetit_flutter/widgets/checklist_card.dart';
import 'package:youllgetit_flutter/widgets/job_option_item.dart';

class JobCartScreen extends StatefulWidget {
  const JobCartScreen({super.key});

  @override
  State<JobCartScreen> createState() => _JobCartScreenState();
}

class _JobCartScreenState extends State<JobCartScreen> {
  final List<JobOption> jobOptions = [
    JobOption(title: "Chassis Engineer", company: "RedBull", isSelected: false),
    JobOption(title: "Aerodynamics Engineer", company: "AeroDelft", isSelected: false),
    JobOption(title: "CAD Engineer", company: "Vopak", isSelected: false),
    JobOption(title: "Flight Testing Engineer", company: "Airbus", isSelected: false),
    JobOption(title: "CAD Engineer", company: "Vopak", isSelected: false),
    JobOption(title: "Aerodynamics Engineer", company: "AeroDelft", isSelected: false),
    JobOption(title: "CAD Engineer", company: "Vopak", isSelected: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with title and count
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
                        '${jobOptions.length} potential opportunities',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  CircleAvatar(
                    backgroundColor: Colors.brown.shade300,
                    child: const Icon(Icons.handshake, color: Colors.white),
                  ),
                ],
              ),
            ),
            
            // Tab Bar
            const JobTabBar(),
            
            // Divider
            const Divider(height: 1),
            
            // Checklist Card
            const ChecklistCard(),
            
            // Job Options List
            Expanded(
              child: ListView.builder(
                itemCount: jobOptions.length,
                itemBuilder: (context, index) {
                  return JobOptionItem(
                    jobOption: jobOptions[index],
                    onChanged: (bool? value) {
                      setState(() {
                        jobOptions[index].isSelected = value ?? false;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JobOption {
  final String title;
  final String company;
  bool isSelected;

  JobOption({
    required this.title,
    required this.company,
    required this.isSelected,
  });
}