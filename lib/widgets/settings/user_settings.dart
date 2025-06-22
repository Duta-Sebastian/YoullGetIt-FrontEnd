import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/models/user_model.dart';
import 'package:youllgetit_flutter/screens/entry_screen.dart';
import 'package:youllgetit_flutter/screens/view_answers_screen.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/utils/first_time_checker.dart';

class UserSettings extends StatefulWidget {
  final VoidCallback onUsernameChanged;
  final String? currentUsername;
  const UserSettings({
    super.key,
    required this.currentUsername,
    required this.onUsernameChanged
  });

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  static const _titleStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const _dangerTitleStyle = TextStyle(
    fontSize: 18, 
    fontWeight: FontWeight.bold,
    color: Colors.red,
  );
  static const _usernameStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static const _textFieldStyle = TextStyle(fontSize: 16);
  static const _inputDecoration = InputDecoration(
    border: InputBorder.none,
    hintText: "Enter username",
    isDense: true,
  );

  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  bool _isEditing = false;
  bool _isLoading = false;
  String? _currentUsername;

  @override
  void initState() {
    super.initState();
    _loadCurrentUsername();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameFocus.dispose();
    super.dispose();
  }

  void _loadCurrentUsername() {
    setState(() {
      _currentUsername = widget.currentUsername ?? 'No username set';
      _usernameController.text = _currentUsername ?? '';
    });
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
    _usernameFocus.requestFocus();
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _usernameController.text = _currentUsername ?? '';
    });
    _usernameFocus.unfocus();
  }

  void _saveUsername() async {
    String newUsername = _usernameController.text.trim();
    
    if (newUsername.isEmpty) {
      _showErrorMessage('Username cannot be empty');
      _cancelEditing();
      return;
    }

    if (newUsername == _currentUsername) {
      setState(() {
        _isEditing = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await DatabaseManager.updateUser(
        UserModel(username: newUsername, lastChanged: DateTime.now().toUtc())
      );
      
      if (mounted) {
        setState(() {
          _currentUsername = newUsername;
          _isEditing = false;
          _isLoading = false;
        });
        widget.onUsernameChanged();
        _showSuccessMessage('Username updated successfully');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorMessage('Failed to update username');
        _cancelEditing();
      }
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _confirmDeleteData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Delete all data?"),
        content: const Text("This action cannot be undone. You will be returned to the welcome screen."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              
              navigator.pop();
              
              try {
                await DatabaseManager.deleteAllDataWithTransaction();
                await resetFirstTimeOpening();
                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const EntryScreen()),
                  (route) => false,
                );
              } catch (e) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Error deleting data: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text("Delete All", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('User Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Username", 
              style: _titleStyle
            ),
            const SizedBox(height: 12),
            
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.grey),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _isEditing 
                            ? TextField(
                                controller: _usernameController,
                                focusNode: _usernameFocus,
                                enabled: !_isLoading,
                                decoration: _inputDecoration,
                                style: _textFieldStyle,
                                onSubmitted: (_) => _saveUsername(),
                              )
                            : Text(
                                _currentUsername ?? 'No username set',
                                style: _usernameStyle,
                              ),
                        ),
                        if (_isLoading)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else if (_isEditing)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check, color: Colors.green),
                                onPressed: _saveUsername,
                                tooltip: 'Save',
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: _cancelEditing,
                                tooltip: 'Cancel',
                              ),
                            ],
                          )
                        else
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: _startEditing,
                            tooltip: 'Edit username',
                          ),
                      ],
                    ),
                    if (_isEditing)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 36),
                        child: Text(
                          'Tap ✓ to save or ✗ to cancel',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),

            // Questions Section
            Text(
              "Questions", 
              style: _titleStyle
            ),
            
            const SizedBox(height: 12),

            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.question_answer, color: Colors.blue),
                title: const Text("Review answered questions"),
                subtitle: const Text("Tap to view your answers"),
                splashColor: Colors.transparent,
                onTap: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ViewAnswersScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),
            // Danger Zone
            Text(
              "Danger Zone", 
              style: _dangerTitleStyle
            ),
            const SizedBox(height: 12),
            Card(
              color: Colors.red.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.red.shade200),
              ),
              child: ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Delete all data"),
                subtitle: const Text("This action cannot be undone"),
                onTap: _confirmDeleteData,
              ),
            ),
          ],
        ),
      ),
    );
  }
}