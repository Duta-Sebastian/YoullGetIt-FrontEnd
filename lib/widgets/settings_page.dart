import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha((255 * 0.2).toInt()),
                  spreadRadius: 1,
                  blurRadius: 5,
                )
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(Icons.account_circle, size: 40),
                      SizedBox(height: 12),
                      Text(
                        'Save your progress!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement sign in or create account logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(244, 217, 0, 1),
                      foregroundColor: Colors.black,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      'Sign In or Create Account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '*You are currently in Guest Mode',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // General Settings
          Expanded(
            child: ListView(
              children: [
                _buildSettingsItem(
                  context, 
                  icon: Icons.language, 
                  title: 'Language',
                  onTap: () {
                    // TODO: Implement language selection
                  },
                ),
                _buildSettingsItem(
                  context, 
                  icon: Icons.privacy_tip, 
                  title: 'Privacy Policy',
                  onTap: () {
                    // TODO: Implement privacy policy navigation
                  },
                ),
                _buildSettingsItem(
                  context, 
                  icon: Icons.document_scanner, 
                  title: 'Terms of Use',
                  onTap: () {
                    // TODO: Implement terms of use navigation
                  },
                ),
                _buildSettingsItem(
                  context, 
                  icon: Icons.feedback, 
                  title: 'Feedback',
                  onTap: () {
                    // TODO: Implement feedback mechanism
                  },
                ),
                _buildSettingsItem(
                  context, 
                  icon: Icons.star, 
                  title: 'Rate Us',
                  onTap: () {
                    // TODO: Implement app rating logic
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create settings list items
  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}