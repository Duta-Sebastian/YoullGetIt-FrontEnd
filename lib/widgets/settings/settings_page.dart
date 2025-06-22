import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youllgetit_flutter/utils/app_rating_helper.dart';
import 'package:youllgetit_flutter/widgets/settings/gdpr_page.dart';
import 'package:youllgetit_flutter/widgets/settings/auth_section.dart';
import 'package:youllgetit_flutter/widgets/settings/language_settings.dart';
import 'package:youllgetit_flutter/widgets/settings/privacy_policy_page.dart';
import 'package:youllgetit_flutter/widgets/settings/tos_page.dart';
import 'package:youllgetit_flutter/widgets/settings/user_settings.dart';

class SettingsPage extends ConsumerStatefulWidget {
  final VoidCallback onUsernameChanged;
  final String? currentUsername;
  const SettingsPage({
    super.key,
    required this.currentUsername,
    required this.onUsernameChanged
  });

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends ConsumerState<SettingsPage> {

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://youllgetit.eu/feedback');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch https://youllgetit.eu/feedback')),
        );
      }
    }
  }
  
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
            key: UniqueKey(),
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
                          currentUsername: widget.currentUsername,
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyPage(),
                      )
                    );
                  },
                ),
                _buildSettingsItem(
                  context, 
                  icon: Icons.document_scanner, 
                  title: 'Terms of Use',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TermsOfServicePage(),
                      )
                    );
                  },
                ),

                _buildSettingsItem(
                  context, 
                  icon: Icons.policy, 
                  title: 'GDPR Policy',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const GDPRPage(),
                      )
                    );
                  }
                ),

                _buildSettingsItem(
                  context, 
                  icon: Icons.feedback, 
                  title: 'Feedback',
                  onTap: _launchURL,
                ),
                _buildSettingsItem(
                  context, 
                  icon: Icons.star, 
                  title: 'Rate Us',
                  onTap: () {
                    AppRatingHelper.requestRating(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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