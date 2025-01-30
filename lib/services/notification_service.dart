import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final _androidChannel = const AndroidNotificationChannel(
    'orders_channel', // 🚨 MUST match Cloud Function
    'Order Notifications',
    importance: Importance.max,
  );

  Future<void> initialize() async {
    // Request permissions
    await FirebaseMessaging.instance.requestPermission();

    // Setup foreground handler
    FirebaseMessaging.onMessage.listen((message) {
      // Show notification even if app is open
      _showNotification(message);
    });

    // Create notification channel (Android)
    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
  }

  Future<void> _showNotification(RemoteMessage message) async {
    final android = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      importance: Importance.max,
      priority: Priority.high,
    );

    await FlutterLocalNotificationsPlugin().show(
      0,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(android: android),
    );
  }
}
