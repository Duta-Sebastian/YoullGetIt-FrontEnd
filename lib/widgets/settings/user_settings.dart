import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
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

  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _usernameCardKey = GlobalKey();
  
  bool _isEditing = false;
  bool _isLoading = false;
  String? _currentUsername;

  @override
  void initState() {
    super.initState();
    _usernameFocus.addListener(_onFocusChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCurrentUsername();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_usernameFocus.hasFocus) {
      // Small delay to ensure keyboard is fully shown
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && _usernameCardKey.currentContext != null) {
          Scrollable.ensureVisible(
            _usernameCardKey.currentContext!,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: 0.1, // Show card near top of visible area
          );
        }
      });
    }
  }

  void _loadCurrentUsername() {
    final localizations = AppLocalizations.of(context)!;
    setState(() {
      _currentUsername = widget.currentUsername ?? localizations.settingsPageNoUsernameSet;
      _usernameController.text = widget.currentUsername ?? '';
    });
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
    // Request focus after state update
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _usernameFocus.requestFocus();
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _usernameController.text = widget.currentUsername ?? '';
    });
    _usernameFocus.unfocus();
  }

  void _saveUsername() async {
    final localizations = AppLocalizations.of(context)!;
    String newUsername = _usernameController.text.trim();
    
    if (newUsername.isEmpty) {
      _showErrorMessage(localizations.settingsPageUsernameCannotBeEmpty);
      return;
    }

    if (newUsername == widget.currentUsername) {
      setState(() {
        _isEditing = false;
      });
      _usernameFocus.unfocus();
      return;
    }

    // Dismiss keyboard before showing loading state
    _usernameFocus.unfocus();
    
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
        _showSuccessMessage(localizations.settingsPageUsernameUpdatedSuccessfully);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorMessage(localizations.settingsPageFailedToUpdateUsername);
        _cancelEditing();
      }
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _confirmDeleteData() {
    final localizations = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(child: Text(localizations.settingsPageDeleteAllDataConfirm)),
          ],
        ),
        content: Text(localizations.settingsPageDeleteAllDataMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              localizations.settingsPageCancel,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              
              navigator.pop();
              
              // Show loading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Deleting data...'),
                        ],
                      ),
                    ),
                  ),
                ),
              );
              
              try {
                await DatabaseManager.deleteAllDataWithTransaction();
                await resetFirstTimeOpening();
                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const EntryScreen()),
                  (route) => false,
                );
              } catch (e) {
                navigator.pop(); // Dismiss loading dialog
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(child: Text(localizations.settingsPageErrorDeletingData(e.toString()))),
                      ],
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(localizations.settingsPageDeleteAll),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside
        if (_usernameFocus.hasFocus) {
          _usernameFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Dismiss keyboard before navigating back
              if (_usernameFocus.hasFocus) {
                _usernameFocus.unfocus();
              }
              Navigator.of(context).pop();
            },
          ),
          title: Text(localizations.settingsPageUserSettings),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16.0),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.settingsPageUsername, 
                style: _titleStyle
              ),
              const SizedBox(height: 12),
              
              Card(
                key: _usernameCardKey,
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
                                  maxLength: 30, // Add reasonable limit
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: localizations.settingsPageEnterUsername,
                                    isDense: true,
                                    counterText: '', // Hide character counter
                                  ),
                                  style: _textFieldStyle,
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (_) => _saveUsername(),
                                )
                              : Text(
                                  _currentUsername ?? localizations.settingsPageNoUsernameSet,
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
                                  onPressed: _isLoading ? null : _saveUsername,
                                  tooltip: localizations.settingsPageSave,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: _isLoading ? null : _cancelEditing,
                                  tooltip: localizations.settingsPageCancel,
                                ),
                              ],
                            )
                          else
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: _startEditing,
                              tooltip: localizations.settingsPageEditUsername,
                            ),
                        ],
                      ),
                      if (_isEditing)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 36),
                          child: Text(
                            localizations.settingsPageTapToSaveOrCancel,
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
                localizations.settingsPageQuestions, 
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
                  title: Text(localizations.settingsPageReviewAnsweredQuestions),
                  subtitle: Text(localizations.settingsPageTapToViewAnswers),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    // Dismiss keyboard before navigation
                    if (_usernameFocus.hasFocus) {
                      _usernameFocus.unfocus();
                    }
                    
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
                localizations.settingsPageDangerZone, 
                style: _dangerTitleStyle
              ),
              const SizedBox(height: 12),
              
              Card(
                color: Colors.red.shade50,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.red.shade200),
                ),
                child: ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: Text(
                    localizations.settingsPageDeleteAllData,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(localizations.settingsPageActionCannotBeUndone),
                  trailing: const Icon(Icons.warning, color: Colors.red, size: 20),
                  onTap: () {
                    // Dismiss keyboard before showing dialog
                    if (_usernameFocus.hasFocus) {
                      _usernameFocus.unfocus();
                    }
                    _confirmDeleteData();
                  },
                ),
              ),
              
              // Bottom padding for better scrolling experience
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}