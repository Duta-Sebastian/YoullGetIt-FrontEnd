import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:youllgetit_flutter/models/cv_model.dart';
import 'package:youllgetit_flutter/models/job_card/job_card_model.dart';
import 'package:youllgetit_flutter/models/job_card_status_model.dart';
import 'package:youllgetit_flutter/models/job_status.dart';
import 'package:youllgetit_flutter/models/user_model.dart';
import 'package:youllgetit_flutter/utils/secure_storage_manager.dart';

class DatabaseManager {
  static late Database _database;
  
  static Future<void> init() async  {
    final key = await SecureStorageManager.getEncryptionKey();
    final db = await openDatabase(
      'db',
      version: 1,
      password: key,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE jobs (
            id TEXT PRIMARY KEY,
            job_data TEXT,
            status TEXT CHECK (status IN ('liked', 'toApply', 'applied', 'unknown')),
            last_changed DATETIME,
            is_deleted INTEGER DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE user (
            username TEXT,
            last_changed DATETIME,
            PRIMARY KEY (username, last_changed)
          )
        ''');

        await db.execute('''
          CREATE TABLE cv (
            cv_data BLOB,
            last_changed DATETIME,
            PRIMARY KEY (cv_data, last_changed)
          )
        ''');

        await db.execute('''
          CREATE TABLE question_answers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            answers_json TEXT NOT NULL,
            last_changed DATETIME NOT NULL,
            is_short_questionnaire INTEGER DEFAULT 0
          )
        ''');
      },
    );
    _database = db;
  }

  static Future<Map<String, int>> deleteAllDataWithTransaction() async {
  try {
      late Map<String, int> results;
      
      await _database.transaction((txn) async {
        final jobsDeleted = await txn.delete('jobs');
        final usersDeleted = await txn.delete('user');
        final cvsDeleted = await txn.delete('cv');
        final questionAnswersDeleted = await txn.delete('question_answers');
        
        results = {
          'jobs': jobsDeleted,
          'users': usersDeleted,
          'cvs': cvsDeleted,
          'question_answers': questionAnswersDeleted,
        };
      });
      
      return results;
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> close() async {
    await _database.close();
  }

  static Future<List<JobCardStatusModel>> retrieveAllJobs() async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'jobs', where: "is_deleted = ?", whereArgs: [0], orderBy: 'last_changed DESC');
    return List.generate(maps.length, (index) {
      final jsonData = jsonDecode(maps[index]['job_data']);
      return JobCardStatusModel(
        feedbackId: maps[index]['id'],
        jobCard: JobCardModel.fromJson(jsonData),
        status: JobStatusExtension.fromString(maps[index]['status']),
        lastChanged: DateTime.parse(maps[index]['last_changed']).toUtc(),
      );
    });
  }

  static Future<int> insertJobCard(JobCardModel jobCard) async {
    final jsonString = jsonEncode(jobCard.toJson());
    return await _database.insert('jobs', {
      'id': jobCard.feedbackId,
      'job_data': jsonString,
      'last_changed': DateTime.now().toUtc().toIso8601String(),
      'status': "liked"
      },
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }
  
  static Future<int> deleteAllJobs() async {
    return await _database.delete('jobs');
  }

  static Future<int> deleteJob(String id) async {
    return await _database.update('jobs', {'is_deleted': 1}, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> updateJobStatus(String id, JobStatus status) async {
    return await _database.update('jobs',
      {'status': status.name, 'last_changed': DateTime.now().toUtc().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id]);
  }

  static Future<int> updateUser(UserModel currentUser) async {
    UserModel? oldUser = await _database.query('user').then((results) {
      if (results.isEmpty) {
        return null;
      }
      return UserModel(
        username: results.first['username'] as String,
        lastChanged: DateTime.parse(results.first['last_changed'] as String)
      );
    });
    if (oldUser == null){
      return _database.insert('user', {
        'username': currentUser.username,
        'last_changed': currentUser.lastChanged!.toUtc().toIso8601String()
      });
    }
    else if (currentUser.lastChanged!.isAfter(oldUser.lastChanged!)){
      return _database.update('user', {
        'username': currentUser.username,
        'last_changed': currentUser.lastChanged!.toUtc().toIso8601String()
      });
    }
    return 0;
  }

  static Future<UserModel?> getUser() async {
    return await _database.query('user').then((results) {
      if (results.isEmpty) {
        return null;
      }
      return UserModel(
        username: results.first['username'] as String,
        lastChanged: DateTime.parse(results.first['last_changed'] as String)
      );
    });
  }

  static Future<int> updateCV(CvModel cv) async {
    final Uint8List cvDataBytes = cv.cvData is Uint8List 
      ? cv.cvData as Uint8List 
      : Uint8List.fromList(cv.cvData);
    CvModel? oldCV = await _database.query('cv').then((results) {
      if (results.isEmpty) {
        return null;
      }
      return CvModel(
        cvData: results.first['cv_data'] == null ? Uint8List(0) : results.first['cv_data'] as Uint8List,
        lastChanged: DateTime.parse(results.first['last_changed'] as String)
      );
    });

    if (oldCV == null){
      await _database.insert('cv', {
        'cv_data': cvDataBytes,
        'last_changed': cv.lastChanged.toUtc().toIso8601String()
      });
      return 0;
    }
    else if (cv.lastChanged.isAfter(oldCV.lastChanged)){
      await _database.update('cv', {
        'cv_data': cvDataBytes,
        'last_changed': cv.lastChanged.toUtc().toIso8601String()
      });
      return 0;
    }
    return 1;
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
    return await _database.update('cv', {
      'cv_data': Uint8List(0),
      'last_changed': DateTime.now().toUtc().toIso8601String()
    });
  }

  static Future<int> syncPullJobs(List<JobCardStatusModel> jobCart) async {
    if (jobCart.isEmpty) {
      return 0;
    }
    
    int syncedCount = 0;
    
    final List<String> jobIds = jobCart.map((job) => job.jobCard.feedbackId).toList();
    
    final List<Map<String, dynamic>> existingJobs = await _database.query(
      'jobs',
      where: 'id IN (${List.filled(jobIds.length, '?').join(', ')})',
      whereArgs: jobIds,
    );
    
    final Map<String, Map<String, dynamic>> existingJobsMap = {
      for (var job in existingJobs) job['id'] as String: job
    };
    await _database.transaction((txn) async {
      for (var jobCardStatus in jobCart) {
        final String jobId = jobCardStatus.jobCard.feedbackId;
        if (!existingJobsMap.containsKey(jobId)) {
          final jsonString = jsonEncode(jobCardStatus.jobCard.toJson());
          await txn.insert('jobs', {
            'id': jobId,
            'job_data': jsonString,
            'status': jobCardStatus.status.name,
            'last_changed': jobCardStatus.lastChanged?.toUtc().toIso8601String() ?? 
                          DateTime.now().toUtc().toIso8601String(),
            'is_deleted': jobCardStatus.isDeleted,
          });
          syncedCount++;
        } else {
          final existingJob = existingJobsMap[jobId]!;
          final existingLastChanged = existingJob['last_changed'] != null 
              ? DateTime.parse(existingJob['last_changed'] as String).toUtc() 
              : null;
          if (jobCardStatus.lastChanged != null && 
              (existingLastChanged == null || 
              jobCardStatus.lastChanged!.isAfter(existingLastChanged))) {
            await txn.update(
              'jobs',
              {
                'status': jobCardStatus.status.name,
                'last_changed': jobCardStatus.lastChanged!.toUtc().toIso8601String(),
                'is_deleted': jobCardStatus.isDeleted ? 1 : 0,
              },
              where: 'id = ?',
              whereArgs: [jobId],
            );
            syncedCount++;
          }
        }
      }
    });
    
    return syncedCount;
  }

  static Future<int> saveQuestionAnswers(Map<String, dynamic> answers, bool isShortQuestionnaire) async {
    final answersJson = jsonEncode(answers);

    await _database.delete('question_answers');
    
    return await _database.insert('question_answers', {
      'answers_json': answersJson,
      'last_changed': DateTime.now().toUtc().toIso8601String(),
      'is_short_questionnaire': isShortQuestionnaire ? 1 : 0,
    });
  }

  static Future<bool> isShortQuestionnaire() async {
    final results = await _database.query(
      'question_answers',
      columns: ['is_short_questionnaire'],
      orderBy: 'last_changed DESC',
      limit: 1,
    );

    if (results.isEmpty) {
      return false;
    }

    return results.first['is_short_questionnaire'] == 1;
  }

  static Future<Map<String, dynamic>?> getQuestionAnswersMap() async {
    final results = await _database.query(
      'question_answers',
      orderBy: 'last_changed DESC',
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }

    final answersJson = results.first['answers_json'] as String;
    final Map<String, dynamic> decodedMap = jsonDecode(answersJson) as Map<String, dynamic>;

    return decodedMap;
  }

  static Future<List<MapEntry<String, dynamic>>?> getQuestionAnswers() async {
    final decodedMap = await getQuestionAnswersMap();
    if (decodedMap == null) {
      return null;
    }
    final entries = decodedMap.entries.toList();

    return entries;
  }

  static Future<int> deleteQuestionAnswers() async {
    return await _database.delete('question_answers');
  }
}
