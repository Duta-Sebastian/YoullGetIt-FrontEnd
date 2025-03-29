import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youllgetit_flutter/models/cv_model.dart';
import 'package:youllgetit_flutter/models/db_tables.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';

class SyncApi {
  static const API_BASE_URL = 'https://youllgetit.eu/api/sync';
  static const API_PULL_URL = '$API_BASE_URL/pull';
  static const API_PUSH_URL = '$API_BASE_URL/push';

  static Future<int> syncPull (String accessToken, DbTables dbTable) async {
    debugPrint("SyncProcessor: Sync pull URL: ${API_PULL_URL}?table=${dbTable.name}");
    final response = await http.get(Uri.parse("${API_PULL_URL}?table=${dbTable.name}"),
      headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"},
    );

    debugPrint("Response status code: ${response.statusCode}");

    if (response.statusCode != 200) {
      debugPrint("SyncProcessor: Sync pull failed with status code: ${response.statusCode}");
      return 0; // No data to sync
    }

    if (response.body.isEmpty) {
      debugPrint("SyncProcessor: Sync pull response body is empty");
      return 0; // No data to sync
    }
    try {
      switch (dbTable) {
        case DbTables.cv:
            var pulledCv = CvModel.fromJson(json.decode(response.body));
            DatabaseManager.updateCV(pulledCv);
            final directory = await getApplicationDocumentsDirectory();
            final tempFile = File('${directory.path}/temp_cv_${DateTime.now().millisecondsSinceEpoch}.pdf');
            await tempFile.writeAsBytes(pulledCv.cvData);
            
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('cv_temp_file_path', tempFile.path);
            await prefs.setBool('cv_updated_in_background', true);

            debugPrint("CV synced and temp PDF saved at: ${tempFile.path}");
            return 1;
        default:
          debugPrint("SyncProcessor: Unsupported table for sync: ${dbTable.name}");
          return 0; // No data to sync
      }
    }
    catch (e) {
      debugPrint("SyncProcessor: Error parsing sync pull response: $e");
      return 0; // No data to sync
    }
  }

  static Future<int> syncPush(String accessToken, DbTables dbTable) async {
    try {
      // Only prepare and send data for supported tables
      switch (dbTable) {
        case DbTables.cv:
          // Get the CV from the database
          final cvModel = await DatabaseManager.getCv();
          
          // If no CV data is available, return early
          if (cvModel == null) {
            debugPrint("SyncProcessor: No CV data to push");
            return 0; // No data to sync
          }
          debugPrint("SyncProcessor: Sync push URL: ${cvModel.lastChanged.toIso8601String()}");
          
          final requestBody = json.encode([{
            "cv_data": base64Encode(cvModel.cvData),
            "last_changed": cvModel.lastChanged.toIso8601String()
          }]);
          
          // Send the POST request
          final response = await http.post(
            Uri.parse("$API_PUSH_URL?table=${dbTable.name}"),
            headers: {
              HttpHeaders.authorizationHeader: "Bearer $accessToken",
              HttpHeaders.contentTypeHeader: "application/json",
            },
            body: requestBody,
          );
          
          debugPrint("Response status code: ${response.statusCode}");
          
          if (response.statusCode != 200) {
            debugPrint("SyncProcessor: Sync push failed with status code: ${response.body}");
            return 0; // Error in sync
          }
          
          debugPrint("SyncProcessor: CV successfully pushed to server");
          return 1; // Success
          
        default:
          debugPrint("SyncProcessor: Unsupported table for sync push: ${dbTable.name}");
          return 0; // No data to sync
      }
    } catch (e) {
      debugPrint("SyncProcessor: Error in sync push: $e");
      return 0; // Error in sync
    }
  }
}