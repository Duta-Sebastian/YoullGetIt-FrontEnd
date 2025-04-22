import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

const String _uniqueIdKey = 'unique_id';

Future<String> generateAndStoreUniqueId() async {
  final seed = DateTime.now().millisecondsSinceEpoch;
  final random = Random(seed);
  final List<int> bytes = List.generate(32, (_) => random.nextInt(256));
  
  final String uniqueId = base64Encode(bytes);
  
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_uniqueIdKey, uniqueId);
  return uniqueId;
}

Future<String> getUniqueId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_uniqueIdKey)!;
}