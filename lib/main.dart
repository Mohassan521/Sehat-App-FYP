import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sehat_app/Provider/provider.dart';
import 'package:sehat_app/Utils/Utils.dart';
import 'package:sehat_app/firebase_options.dart';
import 'package:sehat_app/screens/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Utils().registerServices();
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => StatusValueProvider())],
      child: const MyApp()));
}

// final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

// void _configureFirebaseMessaging() {
//   // Request permission for notifications (iOS)
//   _firebaseMessaging.requestPermission();

//   // Listen for messages in the foreground
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print("Foreground Notification: ${message.notification?.title}");
//     // Show a local notification or update UI
//   });

//   // Handle background messages
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
// }

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Background Notification: ${message.notification?.title}");
//   // Handle the background message (e.g., show a local notification)
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      // home: CompletedAnyTask(message: "hh", path: 'assets/images/order-placed.json'),
    );
  }
}
