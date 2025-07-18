import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart' as crypto;
import 'package:pointycastle/api.dart';
import 'package:pointycastle/random/fortuna_random.dart';
import 'package:youllgetit_flutter/models/cv_model.dart';
import 'package:youllgetit_flutter/models/db_tables.dart';
import 'package:youllgetit_flutter/models/job_card_status_model.dart';
import 'package:youllgetit_flutter/models/question_sync_model.dart';
import 'package:youllgetit_flutter/models/user_model.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';

class SyncApi {
  static const apiBaseUrl = 'https://api1.youllgetit.eu/api/sync';
  static const apiPullUrl = '$apiBaseUrl/pull';
  static const apiPushUrl = '$apiBaseUrl/push';

  static List<int> encryptCvData(List<int> cvData, String aesKey) {
    final secureRandom = FortunaRandom();
    final seedSource = Random.secure();
    final seeds = <int>[];
    for (var i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    
    final iv = Uint8List(16);
    for (var i = 0; i < 16; i++) {
      iv[i] = secureRandom.nextUint8();
    }
    
    final keyBytes = _createKeyBytes(aesKey);
    final keyParam = KeyParameter(keyBytes);
    
    final params = ParametersWithIV(keyParam, iv);
    
    final BlockCipher paddedCipher = PaddedBlockCipher(
      "AES/CBC/PKCS7"
    );
    paddedCipher.init(true, params);

    final Uint8List inputData = Uint8List.fromList(cvData);
    
    final encryptedData = paddedCipher.process(inputData);
    
    final result = Uint8List(iv.length + encryptedData.length);
    result.setRange(0, iv.length, iv);
    result.setRange(iv.length, result.length, encryptedData);
    
    return result.toList();
  }
  
  static List<int> decryptCvData(List<int> encryptedData, String aesKey) {
    final data = Uint8List.fromList(encryptedData);
    
    final iv = data.sublist(0, 16);
    
    final encData = data.sublist(16);
    
    final keyBytes = _createKeyBytes(aesKey);
    final keyParam = KeyParameter(keyBytes);
    
    final params = ParametersWithIV(keyParam, iv);
    
    final BlockCipher paddedCipher = PaddedBlockCipher(
      "AES/CBC/PKCS7"
    );
    paddedCipher.init(false, params);
    
    final decryptedData = paddedCipher.process(encData);
    
    return decryptedData.toList();
  }
  
  static Uint8List _createKeyBytes(String aesKey) {
    final Uint8List keyBytes;
    final utf8Key = utf8.encode(aesKey);
    
    if (utf8Key.length == 16 || utf8Key.length == 24 || utf8Key.length == 32) {
      keyBytes = Uint8List.fromList(utf8Key);
    } else {
      keyBytes = Uint8List.fromList(crypto.sha256.convert(utf8Key).bytes);
    }
    
    return keyBytes;
  }

  static Future<int> syncPull (String accessToken, String aesKey, DbTables dbTable) async {
    final response = await http.get(Uri.parse("$apiPullUrl?table=${dbTable.name}"),
      headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"},
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      debugPrint("SyncProcessor: Sync pull ( ${dbTable.name} ) with status code: ${response.statusCode}");
      return 0;
    }

    if (response.statusCode == 204) {
      return 1;
    }

    if (response.body.isEmpty) {
      debugPrint("SyncProcessor: Sync pull ( ${dbTable.name} ) response body is empty");
      return 0;
    }
    try {
      switch (dbTable) {
        case DbTables.cv:
            final decodedJson = json.decode(response.body) as List<dynamic>;
            if (decodedJson.isNotEmpty) {
              final List<int> encodedData = base64Decode(decodedJson[0]['cv_data']);
              final List<int> decryptedData = decryptCvData(encodedData, aesKey);
              decodedJson[0]['cv_data'] = decryptedData;
            }
            var pulledCv = CvModel.fromJson(decodedJson);
            var result = DatabaseManager.updateCV(pulledCv);
            return await result;
        case DbTables.auth_user:
            var user = UserModel.fromJson(json.decode(response.body));
            if (user.lastChanged == null) {
              debugPrint("SyncProcessor: No user data to pull");
              return 1;
            }
            var result = DatabaseManager.updateUser(user);
            debugPrint("SyncProcessor: User data pulled successfully");
            return await result;
        case DbTables.job_cart:
            var jobCart = JobCardStatusModel.listFromJson(json.decode(response.body));
            debugPrint('SyncLogger: Sync pull ( ${dbTable.name} ) response: ${jobCart.toString()}');
            var result = DatabaseManager.syncPullJobs(jobCart);
            return await result;
        case DbTables.questions:
            var questionsJson = QuestionSyncModel.fromJson(json.decode(response.body));
            if (questionsJson.lastChanged == null ) {
              return 1;
            }
            var result = DatabaseManager.updateQuestions(questionsJson);
            debugPrint('SyncProcessor: Sync pull ( ${dbTable.name} ) response: ${questionsJson.toString()}');
            return await result;
      }
    }
    catch (e) {
      debugPrint("SyncProcessor: Error parsing sync pull ( ${dbTable.name} ) response: $e");
      return 0;
    }
  }

  static Future<int> syncPush(String accessToken, String aesKey, DbTables dbTable) async {
    try {
      String requestBody;
      switch (dbTable) {
        case DbTables.cv:
          final cvModel = await DatabaseManager.getCv();
          
          if (cvModel == null) {
            debugPrint("SyncProcessor: No CV data to push");
            return 0;
          }

          final List<int> encryptedCvData = encryptCvData(cvModel.cvData, aesKey);
          
          requestBody = json.encode([{
            "cv_data": base64Encode(encryptedCvData),
            "last_changed": cvModel.lastChanged.toIso8601String()
          }]);
        case DbTables.auth_user:
          final userModel = await DatabaseManager.getUser();

          if (userModel == null) {
            debugPrint("SyncProcessor: No user data to push");
            return 0;
          }

          requestBody = json.encode([{
            "username": userModel.username,
            "last_changed": userModel.lastChanged!.toIso8601String()
          }]);
        case DbTables.job_cart:
          final jobCart = await DatabaseManager.retrieveAllJobs();

          if (jobCart.isEmpty) {
            debugPrint('SyncProcessor: No job data to push');
            return 0;
          }
          requestBody = JobCardStatusModel.encodeJobCartToJson(jobCart);
        case DbTables.questions:
          final questionsModel = await DatabaseManager.getQuestions();

          if (questionsModel == null || questionsModel.lastChanged == null) {
            debugPrint("SyncProcessor: No questions data to push");
            return 0;
          }

          requestBody = json.encode([{
            "question_json": questionsModel.questionJson,
            "last_changed": questionsModel.lastChanged!.toIso8601String(),
            "is_short_questionnaire": questionsModel.isShortQuestionnaire ? 1 : 0
          }]);
      }
      
      final response = await http.post(
      Uri.parse("$apiPushUrl?table=${dbTable.name}"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $accessToken",
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: requestBody,
      );
          
      
      if (response.statusCode != 200) {
        debugPrint("SyncProcessor: Sync push ( ${dbTable.name} ) failed with status code: ${response.body}");
        return 0; 
      }
      
      debugPrint("SyncProcessor: Sync push ( ${dbTable.name} ) successful with status code: ${response.statusCode}");
      return 1;
    } 
    catch (e) {
      debugPrint("SyncProcessor: Error in sync push: $e");
      return 0;
    }
  }
}