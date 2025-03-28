import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/providers/auth_provider.dart';

class AuthSection extends ConsumerWidget {

  const AuthSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

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
                    ? '${authState.credentials!.user.email}!' 
                    : 'Save your progress!',
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
          // Auth Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                if (authState.isLoggedIn) {
                  // Logout
                  ref.read(authProvider.notifier).logout();
                } else {
                  // Login
                  ref.read(authProvider.notifier).login();
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
                authState.isLoggedIn ? 'Sign Out' : 'Sign In or Create Account',
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
                ? 'You are signed in' 
                : '*You are currently in Guest Mode',
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