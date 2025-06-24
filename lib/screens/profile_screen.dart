import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youllgetit_flutter/services/notification_manager.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/widgets/profile/XYZ_formula.dart';
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
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFFDE15),
        statusBarIconBrightness: Brightness.dark,
      ));
    });

    _fetchUsername();

    _userUpdateSubscription = NotificationManager.instance.onUserUpdated.listen((_) {
      debugPrint('ProfileScreen: Received user update notification, refreshing profile');
      refreshProfile();
    });
  }

  @override
  void dispose() {
    _userUpdateSubscription?.cancel();
    
    // Restore to default when leaving the screen
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    
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
    } catch (e) {
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
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full-width header with no padding
                  ProfileHeader(
                    username: _username ?? 'Guest',
                    onUsernameChanged: refreshProfile,
                  ),
                  // Content with padding
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: [
                                CVUploadSection(),
                                SizedBox(height: 24),
                                XyzFormulaWidget()
                              ]
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}