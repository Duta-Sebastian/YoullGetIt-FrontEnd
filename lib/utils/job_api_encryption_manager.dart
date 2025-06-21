import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/oaep.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/block/modes/cbc.dart';
import 'package:pointycastle/padded_block_cipher/padded_block_cipher_impl.dart';
import 'package:pointycastle/paddings/pkcs7.dart';
import 'package:pointycastle/key_generators/api.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/random/fortuna_random.dart';
import 'package:youllgetit_flutter/utils/secure_storage_manager.dart';

class JobApiEncryptionManager {
  final http.Client _client = http.Client();

  final String _baseUrl = 'https://api2.youllgetit.eu';

  RSAPublicKey? _serverPublicKey;
  RSAPublicKey? _clientPublicKey;
  RSAPrivateKey? _clientPrivateKey;
  bool _fetchingKey = false;
  Completer<void>? _fetchingKeyCompleter;

  Future<void> initialize() async {
    await _loadOrGenerateClientKeyPair();
    await getServerPublicKey();
  }

  Future<void> _loadOrGenerateClientKeyPair() async {
    try {
      if (await SecureStorageManager.hasRsaKeys()) {
        await _loadKeyPairFromSecureStorage();
        return;
      }

      await _generateAndStoreClientKeyPair();
    } catch (e) {
      debugPrint('Error loading/generating client key pair: $e');
      await _generateAndStoreClientKeyPair();
    }
  }

  Future<void> _generateAndStoreClientKeyPair() async {
    try {
      final keyPair = await compute(_generateRSAKeyPair, null);

      _clientPublicKey = keyPair['public'] as RSAPublicKey;
      _clientPrivateKey = keyPair['private'] as RSAPrivateKey;

      await _storeKeyPairInStorage(_clientPrivateKey!, _clientPublicKey!);
    } catch (e) {
      debugPrint('Failed to generate or store key pair: $e');
      throw Exception('RSA key generation failed: ${e.toString()}');
    }
  }

  Future<void> _storeKeyPairInStorage(RSAPrivateKey privateKey, RSAPublicKey publicKey) async {
    try {
      await SecureStorageManager.storeRsaPrivateKey(
        modulus: privateKey.modulus.toString(),
        privateExponent: privateKey.privateExponent.toString(),
        p: privateKey.p.toString(),
        q: privateKey.q.toString()
      );
      
      await SecureStorageManager.storeRsaPublicKey(
        modulus: publicKey.modulus.toString(),
        exponent: publicKey.exponent.toString()
      );
    } catch (e) {
      throw Exception('Failed to store RSA keys in secure storage: ${e.toString()}');
    }
  }

  Future<void> _loadKeyPairFromSecureStorage() async {
    try {
      final privateComponents = await SecureStorageManager.getRsaPrivateKeyComponents();
      final publicComponents = await SecureStorageManager.getRsaPublicKeyComponents();
      
      _clientPrivateKey = RSAPrivateKey(
        BigInt.parse(privateComponents['modulus']!),
        BigInt.parse(privateComponents['privateExponent']!),
        BigInt.parse(privateComponents['p']!),
        BigInt.parse(privateComponents['q']!)
      );
      
      _clientPublicKey = RSAPublicKey(
        BigInt.parse(publicComponents['modulus']!),
        BigInt.parse(publicComponents['exponent']!)
      );
    } catch (e) {
      debugPrint('Error loading key pair from storage: $e');
      throw Exception('Failed to load RSA keys from secure storage: ${e.toString()}');
    }
  }

  String? getClientPublicKeyAsJson() {
    if (_clientPublicKey == null) return null;
    
    return jsonEncode({
      'modulus': _clientPublicKey!.modulus.toString(),
      'exponent': _clientPublicKey!.exponent?.toInt(),
    });
  }

  Future<RSAPublicKey?> getServerPublicKey({bool forceRefresh = false}) async {
    if (_serverPublicKey != null && !forceRefresh) {
      return _serverPublicKey!;
    }
    
    if (_fetchingKey) {
      await _fetchingKeyCompleter?.future;
      if (_serverPublicKey != null) {
        return _serverPublicKey!;
      }
    }
    
    _fetchingKey = true;
    _fetchingKeyCompleter = Completer<void>();

    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/public-key'),
        headers: {
          'Accept': 'application/json; charset=utf-8',
        },
      );
      
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(responseBody);
        final modulus = BigInt.parse(data['modulus'], radix: 16);
        final exponent = BigInt.from(data['exponent']);
        
        _serverPublicKey = RSAPublicKey(modulus, exponent);
      } else {
        debugPrint('Failed to load public key: ${response.statusCode}');
      }
    
    } catch (e){
        debugPrint('Error encountered while trying to connect to the api server: $e');
    }
    finally {
      _fetchingKey = false;
      _fetchingKeyCompleter?.complete();
      _fetchingKeyCompleter = null;
    }
    
    return _serverPublicKey;
  }

  Uint8List generateAesKey() {
    return Uint8List.fromList(
      List<int>.generate(32, (_) => _getSecureRandom().nextUint8())
    );
  }
  
  Map<String, String> encryptWithAes(String data, Uint8List key) {
    final iv = Uint8List.fromList(
      List<int>.generate(16, (_) => _getSecureRandom().nextUint8())
    );
    
    final cipher = PaddedBlockCipherImpl(
      PKCS7Padding(),
      CBCBlockCipher(AESEngine())
    );
    
    cipher.init(
      true, 
      PaddedBlockCipherParameters<CipherParameters, CipherParameters>(
        ParametersWithIV<KeyParameter>(KeyParameter(key), iv),
        null
      )
    );
    
    final inputBytes = Uint8List.fromList(utf8.encode(data));
    final outputBytes = cipher.process(inputBytes);
    
    return {
      'encrypted': base64.encode(outputBytes),
      'iv': base64.encode(iv)
    };
  }
  
  String decryptWithAes(String encryptedData, String iv, Uint8List key) {
    final encryptedBytes = base64.decode(encryptedData);
    final ivBytes = base64.decode(iv);
    
    final cipher = PaddedBlockCipherImpl(
      PKCS7Padding(),
      CBCBlockCipher(AESEngine())
    );
    
    cipher.init(
      false, 
      PaddedBlockCipherParameters<CipherParameters, CipherParameters>(
        ParametersWithIV<KeyParameter>(KeyParameter(key), ivBytes),
        null
      )
    );
    
    final decryptedBytes = cipher.process(Uint8List.fromList(encryptedBytes));
    
    return utf8.decode(decryptedBytes);
  }
  
  Future<String> encryptAesKey(Uint8List aesKey) async {
    final publicKey = await getServerPublicKey();
    if (publicKey == null) throw Exception("Server's public key not found");
    final cipher = OAEPEncoding.withSHA256(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
    
    final cipherText = cipher.process(aesKey);
    return base64.encode(cipherText);
  }
  
  Uint8List decryptAesKey(String encryptedKey) {
    if (_clientPrivateKey == null) {
      throw Exception('Client private key not initialized');
    }
    
    try {
      final cipher = OAEPEncoding.withSHA256(RSAEngine())
        ..init(false, PrivateKeyParameter<RSAPrivateKey>(_clientPrivateKey!));
      
      final encryptedBytes = base64.decode(encryptedKey);
      final decryptedKey = cipher.process(Uint8List.fromList(encryptedBytes));
    
      
      return decryptedKey;
    } catch (e) {
      debugPrint('Error decrypting AES key: $e');
      throw Exception('Failed to decrypt AES key: ${e.toString()}');
    }
  }
  
  Future<Map<String, String>> encryptData(String data) async {
    final aesKey = generateAesKey();
    final encryptedData = encryptWithAes(data, aesKey);
    final encryptedKey = await encryptAesKey(aesKey);
    
    return {
      'encrypted_data': encryptedData['encrypted']!,
      'iv': encryptedData['iv']!,
      'encrypted_key': encryptedKey
    };
  }
  
  T decryptResponse<T>(Map<String, dynamic> encryptedResponse, T Function(String) parser) {
    try {
      final String encryptedData = encryptedResponse['encrypted_data'];
      final String iv = encryptedResponse['iv'];
      final String encryptedKey = encryptedResponse['encrypted_key'];
      
      final aesKey = decryptAesKey(encryptedKey);
      final decryptedJson = decryptWithAes(encryptedData, iv, aesKey);
      
      return parser(decryptedJson);
    } catch (e) {
      debugPrint('Error decrypting response: $e');
      throw Exception('Failed to decrypt response: ${e.toString()}');
    }
  }
  
  Future<T> encryptedPost<T>(
    String endpoint, 
    Map<String, dynamic> data, 
    T Function(String) responseParser
  ) async {
    final String jsonData = jsonEncode(data);
    final encryptedPayload = await encryptData(jsonData);
    
    final String? clientPublicKeyJson = getClientPublicKeyAsJson();
  final Map<String, String> headers = {
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json; charset=utf-8',
    if (clientPublicKeyJson != null) 'X-Client-Public-Key': clientPublicKeyJson,
  };
    
    final response = await _client.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(encryptedPayload),
    );
    
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final responseData = jsonDecode(responseBody);
      
      if (responseData is Map<String, dynamic> && 
          responseData.containsKey('encrypted_data') && 
          responseData.containsKey('iv') &&
          responseData.containsKey('encrypted_key')) {
        return decryptResponse(responseData, responseParser);
      } else {
        return responseParser(response.body);
      }
    } else {
      throw Exception('API error: ${response.statusCode}');
    }
  }
  
  Future<http.StreamedResponse> encryptedMultipart(
    String endpoint,
    Map<String, String> fields
  ) async {
    final encryptedData = await encryptData(jsonEncode(fields));
    
    final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl$endpoint'));
    
    request.fields['encrypted_data'] = encryptedData['encrypted_data']!;
    request.fields['iv'] = encryptedData['iv']!;
    request.fields['encrypted_key'] = encryptedData['encrypted_key']!;
    
    final String? clientPublicKeyJson = getClientPublicKeyAsJson();
    if (clientPublicKeyJson != null) {
      request.headers['X-Client-Public-Key'] = clientPublicKeyJson;
    }
    
    return await request.send();
  }

  static Map<String, dynamic> _generateRSAKeyPair(_) {
    final secureRandom = _getSecureRandom();
    final keyParams = RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 64);
    final keyGenerator = RSAKeyGenerator();
    keyGenerator.init(ParametersWithRandom(keyParams, secureRandom));
    
    final keyPair = keyGenerator.generateKeyPair();
    final publicKey = keyPair.publicKey;
    final privateKey = keyPair.privateKey;
    
    return {
      'public': publicKey,
      'private': privateKey,
    };
  }

  static SecureRandom _getSecureRandom() {
    final secureRandom = FortunaRandom();
    final seedSource = Random.secure();
    final seeds = List<int>.generate(32, (_) => seedSource.nextInt(256));
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom;
  }
  
  void dispose() {
    _client.close();
  }
}