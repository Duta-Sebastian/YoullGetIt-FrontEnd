import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/services/background_sync_service.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService();
});