import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._();
  static NotificationManager get instance => _instance;
  NotificationManager._();

  static const String userUpdated = 'user_updated';
  static const String cvUpdated = 'cv_updated';
  static const String jobCartUpdated = 'job_cart_updated';
  
  static const String backgroundSignalPort = 'background_signal_port';
  
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  ReceivePort? _receivePort;
  
  final _userUpdatedController = StreamController<void>.broadcast();
  final _cvUpdatedController = StreamController<void>.broadcast();
  final _jobCartUpdatedController = StreamController<void>.broadcast();
  
  Stream<void> get onUserUpdated => _userUpdatedController.stream;
  Stream<void> get onCvUpdated => _cvUpdatedController.stream;
  Stream<void> get onJobCartUpdated => _jobCartUpdatedController.stream;
  
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('NotificationManager: Already initialized');
      return;
    }
    
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );
    
    _setupBackgroundMessageHandler();
    
    _isInitialized = true;
    debugPrint('NotificationManager: Initialized successfully');
  }
  
  void _setupBackgroundMessageHandler() {
    _receivePort = ReceivePort();
    
    IsolateNameServer.removePortNameMapping(backgroundSignalPort);
    
    IsolateNameServer.registerPortWithName(
      _receivePort!.sendPort, 
      backgroundSignalPort
    );
    
    _receivePort!.listen((dynamic message) {
      debugPrint('NotificationManager: Received message from background: $message');
      
      if (message is String) {
        switch (message) {
          case userUpdated:
            _userUpdatedController.add(null);
            break;
          case cvUpdated:
            _cvUpdatedController.add(null);
            break;
          case jobCartUpdated:
            _jobCartUpdatedController.add(null);
            break;
          default:
            debugPrint('NotificationManager: Unknown message: $message');
        }
      }
    });
    
    debugPrint('NotificationManager: Background message handler set up');
  }
  
  void _handleNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    debugPrint('NotificationManager: Received notification response with payload: $payload');
    
    switch (payload) {
      case userUpdated:
        _userUpdatedController.add(null);
        break;
        
      case cvUpdated:
        _cvUpdatedController.add(null);
        break;
        
      case jobCartUpdated:
        _jobCartUpdatedController.add(null);
        break;
        
      default:
        debugPrint('NotificationManager: Unknown notification payload: $payload');
    }
  }
  
  void dispose() {
    _userUpdatedController.close();
    _cvUpdatedController.close();
    _jobCartUpdatedController.close();
    
    if (_receivePort != null) {
      IsolateNameServer.removePortNameMapping(backgroundSignalPort);
      _receivePort!.close();
    }
    
    debugPrint('NotificationManager: Disposed');
  }
  
  static Future<void> initializeForBackground() async {
    debugPrint('NotificationManager: Initializing for background use');
  }
  
  static Future<void> sendUserUpdatedSignal() async {
    await _sendSignal(userUpdated, 'User Updated', 'Your profile has been synchronized');
    _sendIsolateMessage(userUpdated);
  }
  
  static Future<void> sendCvUpdatedSignal() async {
    await _sendSignal(cvUpdated, 'CV Updated', 'Your CV has been synchronized');
    _sendIsolateMessage(cvUpdated);
  }
  
  static Future<void> sendJobCartUpdatedSignal() async {
    await _sendSignal(jobCartUpdated, 'Job Cart Updated', 'Your job cart has been synchronized');
    _sendIsolateMessage(jobCartUpdated);
  }
  
  static void _sendIsolateMessage(String message) {
    final SendPort? sendPort = IsolateNameServer.lookupPortByName(backgroundSignalPort);
    
    if (sendPort != null) {
      sendPort.send(message);
      debugPrint('NotificationManager: Sent isolate message: $message');
    } else {
      debugPrint('NotificationManager: Failed to send isolate message - port not found');
    }
  }
  
  static Future<void> _initializeBackgroundNotifications(FlutterLocalNotificationsPlugin plugin) async {
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await plugin.initialize(initSettings);
    debugPrint('NotificationManager: Background notification plugin initialized');
  }
  
  static Future<void> _sendSignal(String type, String title, String body) async {
    try {
      final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();
      
      await _initializeBackgroundNotifications(notifications);
      
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'sync_channel',
        'Sync Notifications',
        channelDescription: 'Notifications for synchronization events',
        importance: Importance.low,
        priority: Priority.low,
        playSound: false,
        enableVibration: false,
        onlyAlertOnce: true,
        visibility: NotificationVisibility.secret,
        showWhen: false,
        autoCancel: true,
        silent: true,
      );
      
      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: false,
        presentBadge: false,
        presentSound: false,
        sound: null,
      );
      
      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
      
      final int notificationId = DateTime.now().millisecondsSinceEpoch % 10000;
      
      await notifications.show(
        notificationId,
        title,
        body,
        platformDetails,
        payload: type,
      );
      
      debugPrint('NotificationManager: Sent signal: $type');
    } catch (e) {
      debugPrint('NotificationManager: Error sending signal: $e');
    }
  }
}