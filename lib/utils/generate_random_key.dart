import 'dart:convert';
import 'dart:math';

String generateRandomKey() {
  final random = Random.secure();
  final keyBytes = List<int>.generate(32, (_) => random.nextInt(256));

  final base64Key = base64Encode(keyBytes);
  return base64Key; 
}