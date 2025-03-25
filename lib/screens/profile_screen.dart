import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/widgets/profile/cv_section.dart';
import 'package:youllgetit_flutter/widgets/profile/profile_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(),
              Divider(),
              CVUploadSection(),
              SizedBox(height: 24),
              // RecommendationsTitle(),
              // SizedBox(height: 16),
              // RecommendationCards(),
            ],
          ),
        ),
      ),
    );
  }
}