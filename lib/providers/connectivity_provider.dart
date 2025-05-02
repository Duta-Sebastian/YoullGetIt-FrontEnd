import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();
  
  StreamSubscription? _connectivitySubscription;
  bool _lastConnectionStatus = true;
  bool _isInitialized = false;

  ConnectivityService() {
    debugPrint('ConnectivityService: Initializing');
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
      debugPrint('ConnectivityService: Connectivity changed to $result');
      _processConnectivityResult(result);
    });
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      debugPrint('ConnectivityService: Initial connectivity status: $result');
      _processConnectivityResult(result);
      _isInitialized = true;
    } catch (e) {
      debugPrint('ConnectivityService: Error checking connectivity: $e');
      if (!_isInitialized) {
        _lastConnectionStatus = false;
        _connectionStatusController.add(false);
        _isInitialized = true;
      }
    }
  }
  
  void _processConnectivityResult(dynamic result) {
    bool isConnected = false;
    
    if (result is List<ConnectivityResult>) {
      debugPrint('ConnectivityService: Processing list result: $result');
      isConnected = result.any((r) => r != ConnectivityResult.none);
    } else if (result is ConnectivityResult) {
      debugPrint('ConnectivityService: Processing single result: $result');
      isConnected = result != ConnectivityResult.none;
    } else {
      debugPrint('ConnectivityService: Unknown result type: ${result.runtimeType}');
      return;
    }
    
    debugPrint('ConnectivityService: Determined connected = $isConnected');
    
    if (!_isInitialized || _lastConnectionStatus != isConnected) {
      _lastConnectionStatus = isConnected;
      _connectionStatusController.add(isConnected);
      debugPrint('ConnectivityService: Connection status changed to $isConnected');
    }
  }

  bool get isConnected => _lastConnectionStatus;
  
  Stream<bool> get onConnectivityChanged => _connectionStatusController.stream;

  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionStatusController.close();
  }
}

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

final isConnectedProvider = StreamProvider<bool>((ref) {
  final connectivityService = ref.watch(connectivityServiceProvider);
  
  final controller = StreamController<bool>.broadcast();
  
  controller.add(connectivityService.isConnected);
  
  final subscription = connectivityService.onConnectivityChanged.listen(
    (event) => controller.add(event)
  );
  
  ref.onDispose(() {
    subscription.cancel();
    controller.close();
  });
  
  return controller.stream;
});