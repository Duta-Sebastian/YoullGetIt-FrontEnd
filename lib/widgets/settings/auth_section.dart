import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/providers/auth_provider.dart';
import 'package:youllgetit_flutter/screens/entry_screen.dart';
import 'package:youllgetit_flutter/utils/first_time_checker.dart';

class AuthSection extends ConsumerStatefulWidget {
  const AuthSection({
    super.key,
  });

  @override
  ConsumerState<AuthSection> createState() => _AuthSectionState();
}

class _AuthSectionState extends ConsumerState<AuthSection> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final localizations = AppLocalizations.of(context)!;

    return Container(
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
                  authState.isLoggedIn && authState.credentials?.user.email != null
                    ? localizations.settingsPageSignedInAs(authState.credentials!.user.email!) 
                    : localizations.settingsPageSaveProgressTitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                
                if (authState.isLoggedIn) {
                  await ref.read(authProvider.notifier).logout();
                  if (await isFirstTimeOpening() == true) {
                    if (mounted) {
                      navigator.pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const EntryScreen()),
                        (Route<dynamic> route) => false,
                      );
                    }
                  }
                } else {
                  await ref.read(authProvider.notifier).login();
                }
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
                authState.isLoggedIn ? localizations.settingsPageSignOut : localizations.settingsPageSignIn,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              authState.isLoggedIn 
                ? localizations.settingsPageYouAreSignedIn 
                : localizations.settingsPageGuestMode,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}