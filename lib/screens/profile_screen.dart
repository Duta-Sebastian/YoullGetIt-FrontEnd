import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/services/notification_manager.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/widgets/profile/cv_section.dart';
import 'package:youllgetit_flutter/widgets/profile/profile_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  String? _username;
  bool _isLoading = true;
  String? _errorMessage;
  StreamSubscription? _userUpdateSubscription;

  @override
  void initState() {
    super.initState();
    _fetchUsername();

    _userUpdateSubscription = NotificationManager.instance.onUserUpdated.listen((_) {
      debugPrint('ProfileScreen: Received user update notification, refreshing profile');
      refreshProfile();
    });
  }

  @override
  void dispose() {
    _userUpdateSubscription?.cancel();
    super.dispose();
  }

  Future<void> _fetchUsername() async {
    try {
      final username = await DatabaseManager.getUser().then((user) {
        if (user == null) {
          return null;
        }
        return user.username;
      });

      if (!mounted) {
        return;
      }
      setState(() {
        _username = username;
        _isLoading = false;
      });
    } 
    catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load user data: $e';
      });
    }
  }

  void refreshProfile() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    _fetchUsername();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileHeader(
                      username: _username ?? 'Guest',
                      onUsernameChanged: refreshProfile,
                    ),
                    Divider(),
                    Expanded(
                      child: ListView(
                          children: [
                            CVUploadSection(),
                            SizedBox(height: 24),
                          ]
                        ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}