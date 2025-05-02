import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';
import 'package:youllgetit_flutter/models/db_tables.dart';
import 'package:youllgetit_flutter/providers/auth_provider.dart';
import 'package:youllgetit_flutter/services/notification_manager.dart';
import 'package:youllgetit_flutter/services/sync_api.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';

class SyncService {
  static const String SYNC_TASK = "syncTask";
  static const String SYNC_PERIODIC_TASK = "syncPeriodicTask";
  static const Duration SYNC_INTERVAL = Duration(minutes: 15);
  
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();
  
  late ProviderContainer _container;
  bool _isInitialized = false;
  bool _isSyncScheduled = false;
  
  Future<void> initialize(ProviderContainer container) async {
    if (_isInitialized) return;
    
    _container = container;   
    
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
    
    _isInitialized = true;
  }

  Future<void> startSync() async {
    final authState = _container.read(authProvider);

    if (authState.isLoggedIn && authState.credentials != null) {
      debugPrint('SyncService: User already logged in, scheduling sync at startup');
      await scheduleSync();
    }
  
    _listenToAuthChanges(_container);
  }
  
  void _listenToAuthChanges(ProviderContainer container) {
    container.listen<AuthState>(
      authProvider,
      (previous, next) async {
        if (previous?.isLoggedIn != next.isLoggedIn) {
          if (next.isLoggedIn && next.credentials != null) {
            debugPrint('SyncLogger: User logged in, scheduling sync');
            await scheduleSync();
          } else {
            debugPrint('SyncLogger: User logged out, canceling sync');
            await cancelSync();
          }
        }
      },
    );
  }
  
  Future<bool> scheduleSync() async {
    if (_isSyncScheduled) {
      debugPrint('SyncService: Sync already scheduled, skipping');
      return true;
    }
    
    final authState = _container.read(authProvider);
    
    if (!authState.isLoggedIn || authState.credentials == null) {
      debugPrint('SyncService: Cannot schedule sync - user not logged in');
      return false;
    }
    
    try {
      await cancelSync();
      
      await Workmanager().registerPeriodicTask(
        SYNC_PERIODIC_TASK,
        SYNC_TASK,
        frequency: SYNC_INTERVAL,
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
        inputData: {
          'accessToken': authState.credentials!.accessToken,
          'aesKey': authState.aesKey,
        },
        existingWorkPolicy: ExistingWorkPolicy.replace,
      );
      
      _isSyncScheduled = true;
      debugPrint('SyncService: Periodic sync scheduled');
      
      await performManualSync();
      
      return true;
    } catch (e) {
      debugPrint('SyncService: Failed to schedule sync - $e');
      return false;
    }
  }
  
  Future<bool> performManualSync() async {
    final authState = _container.read(authProvider);
    
    if (!authState.isLoggedIn || authState.credentials == null) {
      debugPrint('SyncService: Cannot perform manual sync - user not logged in');
      return false;
    }
    
    try {
      await Workmanager().registerOneOffTask(
        'manualSync${DateTime.now().millisecondsSinceEpoch}',
        SYNC_TASK,
        inputData: {
          'accessToken': authState.credentials!.accessToken,
          'aesKey': authState.aesKey,
          'manual': true,
        },
        existingWorkPolicy: ExistingWorkPolicy.replace,
      );
      
      debugPrint('SyncService: Manual sync scheduled');
      return true;
    } catch (e) {
      debugPrint('SyncService: Failed to schedule manual sync - $e');
      return false;
    }
  }
  
  Future<void> cancelSync() async {
    try {
      await Workmanager().cancelByUniqueName(SYNC_PERIODIC_TASK);
      _isSyncScheduled = false;
      debugPrint('SyncService: Sync canceled');
    } catch (e) {
      debugPrint('SyncService: Failed to cancel sync - $e');
    }
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      switch (taskName) {
        case SyncService.SYNC_TASK:
          debugPrint('SyncService: Background task triggered - $taskName');
          NotificationManager.initializeForBackground();
          final accessToken = inputData?['accessToken'] as String?;
          final aesKey = inputData?['aesKey'] as String?;
          
          if (accessToken == null || accessToken.isEmpty) {
            debugPrint('SyncService: Missing access token in background task');
            return Future.value(false);
          }

          if (aesKey == null || aesKey.isEmpty) {
            debugPrint('SyncService: Missing AES key in background task');
            return Future.value(false);
          }

          await DatabaseManager.init();

          List<Future<void>> syncTasks = [];

          for (DbTables table in DbTables.values) {
            syncTasks.add(Future<void>(() async {
              int pullResult = await SyncApi.syncPull(accessToken, aesKey, table);
              debugPrint('SyncProcessor: Sync pull result for $table: $pullResult');
              
              if (pullResult != 0) {
                switch (table) {
                  case DbTables.cv:
                    await NotificationManager.sendCvUpdatedSignal();
                    break;
                  case DbTables.auth_user:
                    await NotificationManager.sendUserUpdatedSignal();
                    break;
                  case DbTables.job_cart:
                    await NotificationManager.sendJobCartUpdatedSignal();
                    break;
                }
                int pushResult = await SyncApi.syncPush(accessToken, aesKey, table);
                debugPrint('SyncProcessor: Sync push result: $pushResult');
              }
            }));
          }

          await Future.wait(syncTasks);
          
          debugPrint('SyncProcessor: Sync completed successfully');
          return Future.value(true);
          
        default:
          debugPrint('SyncService: Unknown background task - $taskName');
          return Future.value(false);
      }
    } catch (e) {
      debugPrint('SyncService: Background task failed - $e');
      return Future.value(false);
    }
  });
}