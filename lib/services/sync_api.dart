import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SyncApi {
  static const API_BASE_URL = 'https://youllgetit.eu/api/sync';
  static const API_PULL_URL = '$API_BASE_URL/pull';
  static const API_PUSH_URL = '$API_BASE_URL/push';

  static Future<int> syncPull (String accessToken) async {
    debugPrint("Access token: $accessToken");
    final response = await http.get(Uri.parse(API_PULL_URL),
      headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"},
    );

    debugPrint("Response status code: ${response.statusCode}");

    if (response.statusCode == 200) {
      return 0; // Success
    } else if (response.statusCode == 401) {
      return 1; // Unauthorized
    } else if (response.statusCode == 500) {
      return 2; // Server error
    } else {
      return 3; // Unknown error
    }
  }

    static Future<int> syncPush (String accessToken) async {
    final response = await http.get(Uri.parse(API_PUSH_URL),
      headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"},
    );
    
    if (response.statusCode == 200) {
      return 0; // Success
    } else if (response.statusCode == 401) {
      return 1; // Unauthorized
    } else if (response.statusCode == 500) {
      return 2; // Server error
    } else {
      return 3; // Unknown error
    }
  }

}