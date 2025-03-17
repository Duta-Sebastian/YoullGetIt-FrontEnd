import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/providers/database_provider.dart';
import 'package:youllgetit_flutter/screens/home_screen.dart';
import 'package:youllgetit_flutter/providers/job_provider.dart';
import 'package:youllgetit_flutter/utils/first_time_checker.dart';

// Define a provider to track loading state
final appInitializationProvider = StateProvider<bool>((ref) => false);

void main() async{
  // Preserve the splash screen until initialization is complete
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  var firstTime = await isFirstTimeOpening();
  // Create a ProviderContainer for initializing data before the app starts
  final container = ProviderContainer();

  container.read(databaseProvider.future);
  
  if(!firstTime){
    // Fetch jobs and update initialization state
    container.read(jobProvider.notifier).fetchJobs(10).then((_) {
      // Mark initialization as complete
      container.read(appInitializationProvider.notifier).state = true;
      FlutterNativeSplash.remove();
    });
  }
  else {
    
  }
  // Set a maximum time for the splash screen
  Future.delayed(const Duration(seconds: 2), () {
    FlutterNativeSplash.remove();
  });

  // Run the app with the initialized container
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