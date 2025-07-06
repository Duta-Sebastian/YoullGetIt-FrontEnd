import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionsSaver {
  static const String _answersKey = 'user_answers';

  static Future<bool> saveAnswers(Map<String, dynamic> answers) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      
      final String jsonString = jsonEncode(answers);
      
      return await prefs.setString(_answersKey, jsonString);
    } catch (e) {
      debugPrint('Error saving to SharedPreferences: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getAnswers() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_answersKey);
      
      if (jsonString == null) {
        return null;
      }
      
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error retrieving from SharedPreferences: $e');
      return null;
    }
  }
  
  static Future<bool> clearAnswers() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_answersKey);
    } catch (e) {
      debugPrint('Error clearing SharedPreferences: $e');
      return false;
    }
  }
}