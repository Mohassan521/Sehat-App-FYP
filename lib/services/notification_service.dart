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

    FirebaseMessaging.onMessageOpenedApp.listen(handleBackgroundNotification);

    // Create notification channel (Android)
    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
  }

  Future<void> handleBackgroundNotification(RemoteMessage message) async {
    print('Handling background notification: ${message.messageId}');

    // Add your logic here (e.g., update local database)
    if (message.data.containsKey('orderId')) {
      final orderId = message.data['orderId'];
      print('Background order ID: $orderId');
    }

    // Show notification in system tray
    await _showNotification(message);
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
