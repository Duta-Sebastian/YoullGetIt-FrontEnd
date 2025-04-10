import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/widgets/settings/auth_section.dart';
import 'package:youllgetit_flutter/widgets/settings/language_settings.dart';
import 'package:youllgetit_flutter/widgets/settings/user_settings.dart';

class SettingsPage extends ConsumerStatefulWidget {
  final VoidCallback onUsernameChanged;
  const SettingsPage({
    super.key,
    required this.onUsernameChanged
  });

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          AuthSection(),
          Expanded(
            child: ListView(
              children: [
                _buildSettingsItem(
                  context, 
                  icon: Icons.person,
                  title: 'User settings',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UserSettings(
                          onUsernameChanged: widget.onUsernameChanged,
                        ),
                      )
                    );
                  },
                ),
                _buildSettingsItem(
                  context, 
                  icon: Icons.language, 
                  title: 'Language',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LanguageSettings(),
                      )
                    );
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
      splashColor: Colors.transparent,
    );
  }
}