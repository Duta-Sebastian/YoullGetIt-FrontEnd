import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/providers/auth_provider.dart';
import 'package:youllgetit_flutter/providers/background_sync_provider.dart';
import 'package:youllgetit_flutter/providers/connectivity_provider.dart';
import 'package:youllgetit_flutter/providers/database_provider.dart';
import 'package:youllgetit_flutter/screens/entry_screen.dart';
import 'package:youllgetit_flutter/screens/home_screen.dart';
import 'package:youllgetit_flutter/providers/job_provider.dart';
import 'package:youllgetit_flutter/services/job_api.dart';
import 'package:youllgetit_flutter/services/notification_manager.dart';
import 'package:youllgetit_flutter/utils/first_time_checker.dart';
import 'package:youllgetit_flutter/utils/unique_id.dart';

final appInitializationProvider = StateProvider<bool>((ref) => false);

Future<void> initializeApp(ProviderContainer container) async {
  try {
    debugPrint('Starting app initialization...');

    container.read(connectivityServiceProvider);
    debugPrint('Connectivity service initialized successfully');
    
    await container.read(databaseProvider.future);
    debugPrint('Database initialized successfully');

    await container.read(authProvider.notifier).initialize();
    debugPrint('Auth initialized successfully');

    JobApi.initialize(container);
    debugPrint('JobApi initialized successfully');

    final parallelInitializationTasks = <Future>[];

    parallelInitializationTasks.addAll([
      NotificationManager.instance.initialize().then((_) {
        debugPrint('NotificationManager initialized successfully');
      }),

      () async {
        final syncService = container.read(syncServiceProvider);
        await syncService.initialize(container);
        await syncService.startSync();
        debugPrint('Sync service initialized successfully');
      }(),
      _checkFirstTimeAndFetchJobs(container)
    ]);

    await Future.wait(parallelInitializationTasks);
    debugPrint('Initialization tasks completed successfully');
  } catch (e) {
    debugPrint('Initialization error: $e');
  } finally {
    FlutterNativeSplash.remove();
  }
}

Future<void> _checkFirstTimeAndFetchJobs(ProviderContainer container) async {
  final isFirstTime = await isFirstTimeOpening();

  if (isFirstTime){
    generateAndStoreUniqueId();
  }
  else {
    final coordinator = container.read(jobCoordinatorProvider);
    await coordinator.initialize();

    container.read(activeJobsProvider.notifier);
    container.read(appInitializationProvider.notifier).state = true;
  }
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final container = ProviderContainer();

  await initializeApp(container);
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyApp(
        isFirstTimeOpening: await isFirstTimeOpening(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final bool isFirstTimeOpening;
  const MyApp({
    super.key,
    required this.isFirstTimeOpening,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'You\'ll Get It',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Inter',
      ),
      debugShowCheckedModeBanner: false,
      
      // ADD COMPREHENSIVE EU LOCALIZATION SUPPORT
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      // COMPREHENSIVE EU LOCALES - covers all EU languages
      supportedLocales: const [
        // Western Europe
        Locale('en', 'US'), // English (US)
        Locale('en', 'GB'), // English (UK)
        Locale('de', 'DE'), // German
        Locale('fr', 'FR'), // French
        Locale('es', 'ES'), // Spanish
        Locale('it', 'IT'), // Italian
        Locale('pt', 'PT'), // Portuguese
        Locale('nl', 'NL'), // Dutch
        Locale('da', 'DK'), // Danish
        Locale('sv', 'SE'), // Swedish
        Locale('no', 'NO'), // Norwegian
        Locale('fi', 'FI'), // Finnish
        Locale('is', 'IS'), // Icelandic
        Locale('ga', 'IE'), // Irish
        Locale('mt', 'MT'), // Maltese
        Locale('lb', 'LU'), // Luxembourgish
        
        // Central/Eastern Europe
        Locale('pl', 'PL'), // Polish
        Locale('cs', 'CZ'), // Czech
        Locale('sk', 'SK'), // Slovak
        Locale('hu', 'HU'), // Hungarian
        Locale('ro', 'RO'), // Romanian
        Locale('bg', 'BG'), // Bulgarian
        Locale('hr', 'HR'), // Croatian
        Locale('sl', 'SI'), // Slovenian
        Locale('et', 'EE'), // Estonian
        Locale('lv', 'LV'), // Latvian
        Locale('lt', 'LT'), // Lithuanian
        
        // Southeastern Europe
        Locale('el', 'GR'), // Greek
        Locale('cy', 'CY'), // Greek (Cyprus)
        
        // Additional useful locales
        Locale('tr', 'TR'), // Turkish (candidate country)
        Locale('uk', 'UA'), // Ukrainian
        Locale('ru', 'RU'), // Russian (for certain regions)
      ],
      
      // Fallback to English if locale not supported
      locale: const Locale('en', 'US'),
      
      home: isFirstTimeOpening ? EntryScreen() : HomeScreen(),
    );
  }
}