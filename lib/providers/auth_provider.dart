import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/foundation.dart';

class AuthState {
  final bool isLoggedIn;
  final Credentials? credentials;

  AuthState({this.isLoggedIn = false, this.credentials});

  AuthState copyWith({bool? isLoggedIn, Credentials? credentials}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      credentials: credentials ?? this.credentials,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Auth0 auth0;

  AuthNotifier() 
    : auth0 = Auth0('dev-noubkiybttkpdcu4.eu.auth0.com', 'cC4B6I0iUEzZnHr0geeWePJyapl0Ghm3'),
      super(AuthState()) {
    initialize();
  }

  Future<void> initialize() async {
    try {
      final credentials = await auth0.credentialsManager.credentials();
      print(credentials);
      state = AuthState(
        isLoggedIn: credentials != null,
        credentials: credentials,
      );
    } catch (e) {
      debugPrint('No stored credentials: $e');
      state = AuthState(isLoggedIn: false);
    }
  }

  Future<bool> login() async {
    try {
      final credentials = await auth0.webAuthentication().login(
        scopes: const {'openid', 'profile', 'email', 'offline_access', 'sync:read', 'sync:pull', 'sync:push'},
        audience: 'https://api.youllgetit.com/user_db', 
        useHTTPS: true,
      );

      await auth0.credentialsManager.storeCredentials(credentials);
      state = AuthState(
        isLoggedIn: true,
        credentials: credentials,
      );
      return true;
    } catch (e) {
      debugPrint('Login failed: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await auth0.webAuthentication().logout(useHTTPS: true);
      await auth0.credentialsManager.clearCredentials();
      state = AuthState(isLoggedIn: false);
    } catch (e) {
      debugPrint('Logout failed: $e');
    }
  }
}

// Provider for the AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});