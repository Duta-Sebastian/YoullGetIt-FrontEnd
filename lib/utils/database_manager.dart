import 'dart:convert';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/models/job_card_status_model.dart';
import 'package:youllgetit_flutter/models/job_status.dart';

class DatabaseManager {
  static late Database _database;
  
  static void init(Database db) {
    _database = db;
  }

  static Future<List<JobCardStatusModel>> retrieveAllJobs() async {
    final List<Map<String, dynamic>> maps = await _database.query('jobs',orderBy: 'date_added DESC');
    return List.generate(maps.length, (index) {
      final jsonData = jsonDecode(maps[index]['job_data']);
      return JobCardStatusModel(
        jobCard: JobCardModel.fromJson(jsonData),
        status: JobStatusExtension.fromString(maps[index]['status'])
      );
    });
  }

  static Future<int> insertJobCard(JobCardModel jobCard) async {
    final jsonString = jsonEncode(jobCard.toJson());
    return _database.insert('jobs', {
      'id': jobCard.id,
      'job_data': jsonString,
      'date_added': DateTime.now().toUtc().toIso8601String(),
      'status': "liked"
      },
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  static Future<int> getLikedJobCount() async {
    var result = await _database.rawQuery("SELECT COUNT(*) FROM jobs");
    return Sqflite.firstIntValue(result) ?? 0;
  }

  static Future<int> deleteAllJobs() async {
    return _database.delete('jobs');
  }

  static Future<int> deleteJob(int id) async {
    return _database.delete('jobs', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> updateJobStatus(int id, JobStatus status) async {
    return _database.update('jobs', {'status': status.name}, where: 'id = ?', whereArgs: [id]);
  }
}
