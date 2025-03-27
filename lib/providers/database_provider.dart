import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:youllgetit_flutter/utils/secure_storage_manager.dart';

final databaseProvider = FutureProvider<Database>((ref) async {
  final key = await SecureStorageManager.getEncryptionKey();
  final db = await openDatabase(
    'db',
    version: 1,
    password: key,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE jobs (
          id INTEGER PRIMARY KEY,
          job_data TEXT,
          date_added DATETIME,
          status TEXT CHECK(status IN ('liked', 'toApply', 'applied', 'unknown'))
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
  ref.onDispose(() async {
    await db.close();
  });
  return db;
});