import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:youllgetit_flutter/utils/generate_random_key.dart';

class SecureStorageManager {
  static final _storage = FlutterSecureStorage();

  static Future<String?> _storeEncryptionKey() async {
    var encryptionKey = generateRandomKey();
    await _storage.write(key: 'encryption_key', value: encryptionKey);
    return encryptionKey;
  }

  static Future<String?> getEncryptionKey() async {
    return await _storage.read(key: 'encryption_key') ?? await _storeEncryptionKey();
  }
}
