import 'dart:convert';
import 'dart:typed_data';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:youllgetit_flutter/models/cv_model.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
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
      },
    );
    _database = db;
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
        jobId: maps[index]['id'],
        jobCard: JobCardModel.fromJson(jsonData),
        status: JobStatusExtension.fromString(maps[index]['status']),
        lastChanged: DateTime.parse(maps[index]['last_changed']).toUtc(),
      );
    });
  }

  static Future<int> insertJobCard(JobCardModel jobCard) async {
    final jsonString = jsonEncode(jobCard.toJson());
    return await _database.insert('jobs', {
      'id': jobCard.id,
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
      {'status': status.name, 'last_chaned': DateTime.now().toUtc().toIso8601String()},
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
    
    final List<String> jobIds = jobCart.map((job) => job.jobCard.id).toList();
    
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
        final String jobId = jobCardStatus.jobCard.id;
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
}
