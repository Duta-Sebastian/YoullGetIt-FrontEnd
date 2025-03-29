import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';

final databaseProvider = FutureProvider<void>((ref) async {
  await DatabaseManager.init();
  ref.onDispose(() async {
    await DatabaseManager.close();
  });
});