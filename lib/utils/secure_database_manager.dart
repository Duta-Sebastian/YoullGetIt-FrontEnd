import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/utils/generate_random_key.dart';

class SecureDatabaseManager {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<String?> storeEncryptionKey() async {
    var encryptionKey = generateRandomKey();
    await _storage.write(key: 'encryption_key', value: encryptionKey);
    return encryptionKey;
  }

  static Future<String?> getEncryptionKey() async {
    return await _storage.read(key: 'encryption_key');
  }

  static Future<Database> openEncryptedDatabase() async {
    var key = await getEncryptionKey();
    key ??= await storeEncryptionKey();
    return await openDatabase(
        'db',
        version: 1,
        password: key,
        onCreate: (db, version) {
          return db.execute(
            r'CREATE TABLE jobs( '
            'id INTEGER PRIMARY KEY, '
            'job_data TEXT)');
    });
  }

  static Future<void> closeEncryptedDatabase(Database db) async {
    await db.close();
  }

  static Future<int> insertJobCard(Database db, JobCardModel jobCard) async {
    final jsonData = jobCard.toJson();
    final jsonString = jsonEncode(jsonData);
    print(jsonString);
    return db.insert(
      'jobs', 
      {'id': jobCard.id,'job_data': jsonString});
  }

  static Future<List<JobCardModel>> retrieveAllJobs(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('jobs');

    var list =  List.generate(maps.length, (index) {
      final jsonData = jsonDecode(maps[index]['job_data']);
      return JobCardModel.fromJson(jsonData);  
    });

    print(list);
    return list;
  }

  static Future<int> getJobCount(Database db) async {
    var result = await db.rawQuery("SELECT COUNT(*) FROM jobs");
    return Sqflite.firstIntValue(result) ?? 0;
  }

  static Future<int> deleteAllJobs(Database database) {
    return database.delete('jobs');
  }

  static Future<int> deleteJob(Database database, int id) {
    return database.delete('jobs', where: 'id = ?', whereArgs: [id]);
  }
}