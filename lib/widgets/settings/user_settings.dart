import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/models/username_model.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';

class UserSettings extends StatefulWidget {
  final VoidCallback onUsernameChanged;
  const UserSettings({
    super.key,
    required this.onUsernameChanged
  });

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _saveUsername() {
    String newUsername = _usernameController.text.trim();
    if (newUsername.isNotEmpty) {
      DatabaseManager.updateUsername(UsernameModel(username: newUsername, lastChanged: DateTime.now().toUtc()))
          .then((_) {
        widget.onUsernameChanged();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username updated')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username cannot be empty')),
      );
    }
  }

  void _confirmDeleteData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete all data?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data deleted')),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            const Text("Change Username", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: "Enter new username",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _saveUsername,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.red.shade50,
              child: ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Delete all data"),
                onTap: _confirmDeleteData,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
