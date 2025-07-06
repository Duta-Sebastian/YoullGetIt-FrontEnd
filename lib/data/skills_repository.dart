import 'package:youllgetit_flutter/data/soft_skills_data.dart';
import 'package:youllgetit_flutter/data/hard_skills_data.dart';

class SkillsRepository {
  static Future<List<String>> getSoftSkills() async {
    return SoftSkillsData.getAllSoftSkills();
  }

  static Future<List<String>> getHardSkills() async {
    return HardSkillsData.getAllHardSkills();
  }

  static Future<Map<String, List<String>>> getSoftSkillsByGroup() async {
    return SoftSkillsData.softSkillsGroups;
  }

  static Future<Map<String, List<String>>> getHardSkillsByGroup() async {
    return HardSkillsData.hardSkillsGroups;
  }

  static String? getSoftSkillGroup(String skill) {
    return SoftSkillsData.getGroupForSkill(skill);
  }

  static String? getHardSkillGroup(String skill) {
    return HardSkillsData.getGroupForSkill(skill);
  }
}