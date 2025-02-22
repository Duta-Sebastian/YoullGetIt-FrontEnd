import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:youllgetit_flutter/screens/internship_selector_screen.dart';
import 'package:youllgetit_flutter/utils/first_time_checker.dart';
import 'package:youllgetit_flutter/widgets/my_home_page';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  bool isFirstTime = await isFirstTimeOpening();

  Future.delayed(const Duration(seconds: 2), () {
    FlutterNativeSplash.remove();
  });

  runApp(MyApp(isFirstTime: isFirstTime));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;

  const MyApp({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: true ? const InternshipSelectorScreen() : const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
