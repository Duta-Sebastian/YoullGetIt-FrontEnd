import 'dart:convert';
import 'dart:typed_data';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:youllgetit_flutter/models/cv_model.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/models/job_card_status_model.dart';
import 'package:youllgetit_flutter/models/job_status.dart';
import 'package:youllgetit_flutter/models/username_model.dart';

class DatabaseManager {
  static late Database _database;
  
  static void init(Database db) {
    _database = db;
  }

  static void close() async {
    await _database.close();
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
    return await _database.insert('jobs', {
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
    return await _database.delete('jobs');
  }

  static Future<int> deleteJob(int id) async {
    return await _database.delete('jobs', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> updateJobStatus(int id, JobStatus status) async {
    return await _database.update('jobs', {'status': status.name}, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> updateUsername(UsernameModel currentUser) async {
    UsernameModel? oldUser = await _database.query('user').then((results) {
      if (results.isEmpty) {
        return null;
      }
      return UsernameModel(
        username: results.first['username'] as String,
        lastChanged: DateTime.parse(results.first['last_changed'] as String)
      );
    });
    if (oldUser == null){
      return _database.insert('user', {
        'username': currentUser.username,
        'last_changed': currentUser.lastChanged.toUtc().toIso8601String()
      });
    }
    else if (currentUser.lastChanged.isAfter(oldUser.lastChanged)){
      return _database.update('user', {
        'username': currentUser.username,
        'last_changed': currentUser.lastChanged.toUtc().toIso8601String()
      });
    }
    return 0;
  }

  static Future<String?> getUsername() async {
    return await _database.query('user').then((results) {
      if (results.isEmpty) {
        return null;
      }
      return results.first['username'] as String;
    });
  }

  static Future<int> updateCV(CvModel cv) async {
    CvModel? oldCV = await _database.query('cv').then((results) {
      if (results.isEmpty) {
        return null;
      }
      return CvModel(
        cvData: results.first['cv_data'] as Uint8List,
        lastChanged: DateTime.parse(results.first['last_changed'] as String)
      );
    });
    if (oldCV == null){
      _database.insert('cv', {
        'cv_data': cv.cvData,
        'last_changed': cv.lastChanged.toUtc().toIso8601String()
      });
      return 1;
    }
    else if (cv.lastChanged.isAfter(oldCV.lastChanged)){
      _database.update('cv', {
        'cv_data': cv.cvData,
        'last_changed': cv.lastChanged.toUtc().toIso8601String()
      });
      return 2;
    }
    return 0;
  }

  static Future<CvModel?> getCv() async {
    return await _database.query('cv').then((results) {
      if (results.isEmpty) {
        return null;
      }
      return CvModel(
        cvData: results.first['cv_data'] as Uint8List,
        lastChanged: DateTime.parse(results.first['last_changed'] as String)
      );
    });
  }

  static Future<int> deleteCV() async {
    return await _database.delete('cv');
  }
}
