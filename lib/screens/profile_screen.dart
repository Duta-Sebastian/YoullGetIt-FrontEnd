import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/services/notification_manager.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/widgets/profile/cv_formula.dart';
import 'package:youllgetit_flutter/widgets/profile/cv_section.dart';
import 'package:youllgetit_flutter/widgets/profile/profile_header.dart';
import 'package:youllgetit_flutter/widgets/profile/account_sync_popup.dart';
import 'package:youllgetit_flutter/providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? _username;
  bool _isLoading = true;
  String? _errorMessage;
  StreamSubscription? _userUpdateSubscription;
  final GlobalKey _headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFFDE15),
        statusBarIconBrightness: Brightness.dark,
      ));

      // Show account sync popup if user is not logged in
      _showAccountSyncPopupIfNeeded();
    });

    _fetchUsername();

    _userUpdateSubscription = NotificationManager.instance.onUserUpdated.listen((_) {
      debugPrint('ProfileScreen: Received user update notification, refreshing profile');
      refreshProfile();
    });
  }

  void _showAccountSyncPopupIfNeeded() {
    final authState = ref.read(authProvider);
    
    // Only show popup if user is not logged in
    if (!authState.isLoggedIn) {
      AccountSyncPopup.showIfNeeded(
        context,
        onCreateAccount: () async {
          // Trigger the login flow through authProvider
          final success = await ref.read(authProvider.notifier).login();
          if (success) {
            debugPrint('User successfully logged in from popup');
            // Refresh profile after successful login
            refreshProfile();
          }
        },
        onDismiss: () {
          debugPrint('User dismissed account sync popup');
        },
      );
    }
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

  double _getHeaderHeight() {
    final RenderBox? renderBox = _headerKey.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size.height ?? 200.0; // Fallback to 200 if height can't be determined
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      // Main content with dynamic top padding
                      Positioned.fill(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (scrollNotification) {
                            // Force rebuild to recalculate header height if needed
                            if (scrollNotification is ScrollEndNotification) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) setState(() {});
                              });
                            }
                            return false;
                          },
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(16.0, _getHeaderHeight() + 16.0, 16.0, 16.0),
                            children: [
                              CVUploadSection(),
                              SizedBox(height: 24),
                              CVFormulaWidget(),
                            ],
                          ),
                        ),
                      ),
                      
                      // Header positioned on top of everything
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: ProfileHeader(
                          key: _headerKey,
                          username: _username ?? 'Guest',
                          onUsernameChanged: refreshProfile,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}