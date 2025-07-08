import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/widgets/settings/settings_page.dart';
import 'package:youllgetit_flutter/widgets/animations/animated_pufferfish.dart';

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
    final localizations = AppLocalizations.of(context)!;
    
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFFFDE15),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main content (lowest layer)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 120, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${localizations.greeting},',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '$username!',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  localizations.internshipSearchQuestion,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Settings icon (middle layer)
          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(
                      currentUsername: username,
                      onUsernameChanged: onUsernameChanged,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.settings, color: Colors.black87, size: 24),
              ),
            ),
          ),

          // Animated Pufferfish (highest layer - always on top)
          Positioned(
            right: -30,
            bottom: -40,
            child: Container(
              // Add a semi-transparent background to ensure visibility
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFFDE15).withAlpha((0.3 * 255).toInt()),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const AnimatedPufferfish(
                rotation: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}