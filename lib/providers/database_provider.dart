import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:youllgetit_flutter/utils/secure_database_manager.dart';

final databaseProvider = FutureProvider<Database>((ref) async {
  var db = await SecureDatabaseManager.openEncryptedDatabase();
  ref.onDispose(() => SecureDatabaseManager.closeEncryptedDatabase(db));
  return db;
});