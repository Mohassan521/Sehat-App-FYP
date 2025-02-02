import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidNotificationChannel _androidChannel =
      const AndroidNotificationChannel(
    'orders_channel', // 🚨 MUST match Cloud Function
    'Order Notifications',
    importance: Importance.max,
  );

  Future<void> initialize() async {
    // Request permissions
    await FirebaseMessaging.instance.requestPermission();

    // Initialize local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    // Create notification channel (Android)
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    // ✅ Foreground notification handling
    FirebaseMessaging.onMessage.listen((message) {
      print("Foreground Notification received: ${message.notification?.title}");
      _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen(handleBackgroundNotification);
  }

  Future<void> handleBackgroundNotification(RemoteMessage message) async {
    print('Handling background notification: ${message.messageId}');

    if (message.data.containsKey('orderId')) {
      final orderId = message.data['orderId'];
      print('Background order ID: $orderId');
    }

    // Show notification when app is in the background
    await _showNotification(message);
  }

  Future<void> _showNotification(RemoteMessage message) async {
    final android = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true, // Ensure sound is played
    );

    final notificationDetails = NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      notificationDetails,
    );
  }
}
