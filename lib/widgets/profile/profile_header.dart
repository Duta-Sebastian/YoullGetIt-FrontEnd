import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/widgets/settings/settings_page.dart';

class ProfileHeader extends StatelessWidget {
  final VoidCallback onUsernameChanged;
  final String username;

  const ProfileHeader({
    super.key,
    required this.username,
    required this.onUsernameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          Positioned(
            top: -8,
            right: -8,
            child: IconButton(
              icon: Icon(Icons.settings, color: Colors.grey[700], size: 30),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(
                      onUsernameChanged: onUsernameChanged,
                    ),
                  ),
                );
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, \n$username',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'In search for an internship?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}