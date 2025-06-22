import 'package:flutter/services.dart';

class SkillsRepository {
  static List<String>? _hardSkillsList, _softSkillsList;

  static Future<List<String>> getSoftSkills() async {
    if (_softSkillsList != null) return _softSkillsList!;
    
    var csvString = await rootBundle.loadString('assets/soft_skills.csv');
    _softSkillsList = csvString.split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();
    return _softSkillsList!;
  }

    static Future<List<String>> getHardSkills() async {
    if (_hardSkillsList != null) return _hardSkillsList!;
    
    var csvString = await rootBundle.loadString('assets/hard_skills.csv');
    _hardSkillsList = csvString.split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();
    return _hardSkillsList!;
  }
}