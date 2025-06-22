import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isFirstTimeOpening() async {
  final prefs = await SharedPreferences.getInstance();
  bool? isFirstTime = prefs.getBool('first_time');

  if (isFirstTime == null) {
    isFirstTime = true;
    await prefs.setBool('first_time', true);
  } 

  return isFirstTime;
}

Future<void> setFirstTimeOpening() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('first_time', false);
}

Future<void> resetFirstTimeOpening() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('first_time', true);
}