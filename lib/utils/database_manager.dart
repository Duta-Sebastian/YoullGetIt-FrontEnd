import 'dart:convert';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';

class DatabaseManager {
  static Future<List<JobCardModel>> retrieveAllLikedJobs(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('jobs', where: 'status == ?',
                                                           whereArgs: ['liked'],orderBy: 'date_added DESC');
    return List.generate(maps.length, (index) {
      final jsonData = jsonDecode(maps[index]['job_data']);
      return JobCardModel.fromJson(jsonData);
    });
  }

  static Future<int> insertJobCard(Database db, JobCardModel jobCard) async {
    final jsonString = jsonEncode(jobCard.toJson());
    return db.insert('jobs', {
      'id': jobCard.id,
      'job_data': jsonString,
      'date_added': DateTime.now().toUtc().toIso8601String(),
      'status': "liked"
      },
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  static Future<int> getLikedJobCount(Database db) async {
    var result = await db.rawQuery("SELECT COUNT(*) FROM jobs WHERE status = 'liked'");
    return Sqflite.firstIntValue(result) ?? 0;
  }

  static Future<int> deleteAllJobs(Database db) async {
    return db.delete('jobs');
  }

  static Future<int> deleteJob(Database db, int id) async {
    return db.delete('jobs', where: 'id = ?', whereArgs: [id]);
  }
}
