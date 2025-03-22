import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:youllgetit_flutter/utils/secure_storage_manager.dart';

final databaseProvider = FutureProvider<Database>((ref) async {
  final key = await SecureStorageManager.getEncryptionKey();
  final db = await openDatabase(
      'db',
      version: 1,
      password: key,
      onCreate: (db, version) {
        return db.execute(
          r'CREATE TABLE jobs ( '
          'id INTEGER PRIMARY KEY, '
          'job_data TEXT, '
          'date_added DATE, '
          'status TEXT CHECK(status IN ("liked", "to_apply", "applied")))'
        );
      },
    );
  ref.onDispose(() async {
    await db.close();
  });
  return db;
});