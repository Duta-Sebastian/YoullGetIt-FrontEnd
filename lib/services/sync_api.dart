import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youllgetit_flutter/models/cv_model.dart';
import 'package:youllgetit_flutter/models/db_tables.dart';
import 'package:youllgetit_flutter/models/job_card_status_model.dart';
import 'package:youllgetit_flutter/models/user_model.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';

class SyncApi {
  static const API_BASE_URL = 'https://api1.youllgetit.eu/api/sync';
  static const API_PULL_URL = '$API_BASE_URL/pull';
  static const API_PUSH_URL = '$API_BASE_URL/push';

  static Future<int> syncPull (String accessToken, DbTables dbTable) async {
    final response = await http.get(Uri.parse("$API_PULL_URL?table=${dbTable.name}"),
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
              decodedJson[0]['cv_data'] = base64Decode(decodedJson[0]['cv_data']);
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
      }
    }
    catch (e) {
      debugPrint("SyncProcessor: Error parsing sync pull ( ${dbTable.name} ) response: $e");
      return 0;
    }
  }

  static Future<int> syncPush(String accessToken, DbTables dbTable) async {
    try {
      String requestBody;
      switch (dbTable) {
        case DbTables.cv:
          final cvModel = await DatabaseManager.getCv();
          
          if (cvModel == null) {
            debugPrint("SyncProcessor: No CV data to push");
            return 0;
          }
          
          requestBody = json.encode([{
            "cv_data": base64Encode(cvModel.cvData),
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
        }
      

      final response = await http.post(
      Uri.parse("$API_PUSH_URL?table=${dbTable.name}"),
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