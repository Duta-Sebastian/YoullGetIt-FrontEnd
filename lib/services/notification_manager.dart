import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class NotificationManager {
  NotificationManager._();
  static final NotificationManager _instance = NotificationManager._();
  static NotificationManager get instance => _instance;
  
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  
  final _userUpdatedController = StreamController<void>.broadcast();
  final _cvUpdatedController = StreamController<void>.broadcast();
  
  Stream<void> get onUserUpdated => _userUpdatedController.stream;
  Stream<void> get onCvUpdated => _cvUpdatedController.stream;
  
  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );
    
    debugPrint('NotificationManager: Initialized successfully');
  }
  
  void _onNotificationResponse(NotificationResponse response) {
    debugPrint('NotificationManager: Received notification: ${response.payload}');
    
    if (response.payload == 'user_updated') {
      _userUpdatedController.add(null);
    } else if (response.payload == 'cv_updated') {
      _cvUpdatedController.add(null);
    }
  }
  
  static Future<void> sendUserUpdatedSignal() async {
    await _sendSignal('user_updated', 'User Updated', 'User data has been updated');
  }
  
  static Future<void> sendCvUpdatedSignal() async {
    await _sendSignal('cv_updated', 'CV Updated', 'CV has been updated');
  }
  
  static Future<void> _sendSignal(String type, String title, String body) async {
    final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();
    
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'sync_channel',
      'Sync Notifications',
      channelDescription: 'Notifications for synchronization events',
      importance: Importance.low,
      priority: Priority.low,
      playSound: false,
      enableVibration: false,
      onlyAlertOnce: true,
    );
    
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    
    final int notificationId = DateTime.now().millisecondsSinceEpoch % 10000;
    await notifications.show(
      notificationId,
      title,
      body,
      platformChannelSpecifics,
      payload: type,
    );
    
    debugPrint('NotificationManager: Sent $type signal');
  }
  
  void dispose() {
    _userUpdatedController.close();
    _cvUpdatedController.close();
  }
}