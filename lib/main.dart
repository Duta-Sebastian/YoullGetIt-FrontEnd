import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/providers/auth_provider.dart';
import 'package:youllgetit_flutter/providers/background_sync_provider.dart';
import 'package:youllgetit_flutter/providers/database_provider.dart';
import 'package:youllgetit_flutter/screens/home_screen.dart';
import 'package:youllgetit_flutter/providers/job_provider.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/utils/first_time_checker.dart';  

final appInitializationProvider = StateProvider<bool>((ref) => false);

Future<void> initializeApp(ProviderContainer container) async {
  try {
    await container.read(authProvider.notifier).initialize();
    
    final database = await container.read(databaseProvider.future);
    DatabaseManager.init(database);

    final syncService = container.read(syncServiceProvider);
    await syncService.initialize(container);
    
    await Future.wait([
      _manageSyncBasedOnAuthState(container),
      _checkFirstTimeAndFetchJobs(container),
    ]);
  } catch (e) {
    debugPrint('Initialization error: $e');
  } finally {
    FlutterNativeSplash.remove();
  }
}

Future<void> _manageSyncBasedOnAuthState(ProviderContainer container) async {
  final authState = container.read(authProvider);
  final syncService = container.read(syncServiceProvider);
  
  if (authState.isLoggedIn) {
    await syncService.scheduleSync();
  } else {
    await syncService.cancelSync();
  }
  
  container.listen<AuthState>(
    authProvider, 
    (previous, next) async {
      if (previous?.isLoggedIn != next.isLoggedIn) {
        if (next.isLoggedIn) {
          await syncService.scheduleSync();
        } else {
          await syncService.cancelSync();
        }
      }
    },
  );
}

Future<void> _checkFirstTimeAndFetchJobs(ProviderContainer container) async {
  final firstTime = await isFirstTimeOpening();

  if (!firstTime) {
    await container.read(jobProvider.notifier).fetchJobs(10);
    container.read(appInitializationProvider.notifier).state = true;
  }
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final container = ProviderContainer();

  await initializeApp(container);

  Future.delayed(const Duration(seconds: 2), () {
      FlutterNativeSplash.remove();
  });

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'You\'ll Get It',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Inter',
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}