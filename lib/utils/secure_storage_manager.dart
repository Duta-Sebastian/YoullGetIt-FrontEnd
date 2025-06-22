import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:youllgetit_flutter/utils/generate_random_key.dart';

class SecureStorageManager {
  static final _storage = FlutterSecureStorage();

  static const _databaseEncryptionKey = 'encryption_key';
  static const String _privateKeyModulusKey = 'rsa_private_modulus';
  static const String _privateKeyPrivateExponentKey = 'rsa_private_exponent';
  static const String _privateKeyPKey = 'rsa_private_p';
  static const String _privateKeyQKey = 'rsa_private_q';
  static const String _publicKeyModulusKey = 'rsa_public_modulus';
  static const String _publicKeyExponentKey = 'rsa_public_exponent';


  static Future<String?> _storeEncryptionKey() async {
    var encryptionKey = generateRandomKey();
    await _storage.write(key: _databaseEncryptionKey, value: encryptionKey);
    return encryptionKey;
  }

  static Future<String?> getEncryptionKey() async {
    return await _storage.read(key: _databaseEncryptionKey) ?? await _storeEncryptionKey();
  }

  static Future<void> storeRsaPrivateKey({
    required String modulus,
    required String privateExponent,
    required String p,
    required String q,
  }) async {
    await _storage.write(key: _privateKeyModulusKey, value: modulus);
    await _storage.write(key: _privateKeyPrivateExponentKey, value: privateExponent);
    await _storage.write(key: _privateKeyPKey, value: p);
    await _storage.write(key: _privateKeyQKey, value: q);
  }

  static Future<void> storeRsaPublicKey({
    required String modulus,
    required String exponent,
  }) async {
    await _storage.write(key: _publicKeyModulusKey, value: modulus);
    await _storage.write(key: _publicKeyExponentKey, value: exponent);
  }

  static Future<Map<String, String?>> getRsaPrivateKeyComponents() async {
    final modulus = await _storage.read(key: _privateKeyModulusKey);
    final privateExponent = await _storage.read(key: _privateKeyPrivateExponentKey);
    final p = await _storage.read(key: _privateKeyPKey);
    final q = await _storage.read(key: _privateKeyQKey);
    
    return {
      'modulus': modulus,
      'privateExponent': privateExponent,
      'p': p,
      'q': q,
    };
  }

  static Future<Map<String, String?>> getRsaPublicKeyComponents() async {
    final modulus = await _storage.read(key: _publicKeyModulusKey);
    final exponent = await _storage.read(key: _publicKeyExponentKey);
    
    return {
      'modulus': modulus,
      'exponent': exponent,
    };
  }
  
  static Future<bool> hasRsaKeys() async {
    final privateComponents = await getRsaPrivateKeyComponents();
    final publicComponents = await getRsaPublicKeyComponents();
    
    return privateComponents.values.every((value) => value != null) &&
           publicComponents.values.every((value) => value != null);
  }

  static Future<void> clearRsaKeys() async {
    await _storage.delete(key: _privateKeyModulusKey);
    await _storage.delete(key: _privateKeyPrivateExponentKey);
    await _storage.delete(key: _privateKeyPKey);
    await _storage.delete(key: _privateKeyQKey);
    await _storage.delete(key: _publicKeyModulusKey);
    await _storage.delete(key: _publicKeyExponentKey);
  }
}
