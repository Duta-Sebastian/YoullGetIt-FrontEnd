import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isFirstTimeOpening() async {
  final prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('first_time') ?? true;

  if (isFirstTime) {
    await prefs.setBool('first_time', false);
  }

  return isFirstTime;
}