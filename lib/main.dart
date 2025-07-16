import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/data/question_repository.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/providers/auth_provider.dart';
import 'package:youllgetit_flutter/providers/background_sync_provider.dart';
import 'package:youllgetit_flutter/providers/connectivity_provider.dart';
import 'package:youllgetit_flutter/providers/database_provider.dart';
import 'package:youllgetit_flutter/providers/locale_provider.dart';
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

    await container.read(localeProvider.notifier).loadSavedLocale();
    debugPrint('Locale provider initialized successfully');

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
      () async {
        await QuestionRepository.initialize();
      }
      (),
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
    final currentLocale = ref.watch(localeProvider);
    
    return MaterialApp(
      title: 'You\'ll Get It',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        fontFamily: 'Inter',
      ),
      debugShowCheckedModeBanner: false,
      
      locale: currentLocale,
      
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      supportedLocales: const [
        Locale('en'), // English
        Locale('ro'), // Romanian
        Locale('fr'), // French
        Locale('de'), // German
        Locale('it'), // Italian
        Locale('es'), // Spanish
        Locale('nl'), // Dutch
      ],
      home: Builder(
        builder: (context) {
          final auth = ref.watch(authProvider);
          return (isFirstTimeOpening == true && !auth.isLoggedIn)
              ? EntryScreen()
              : HomeScreen();
        },
      ),
    );
  }
}