import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sehat_app/screens/adminScreens/addDoctor.dart';
import 'package:sehat_app/screens/adminScreens/addMedicines.dart';
import 'package:sehat_app/screens/adminScreens/displayMedicines.dart';
import 'package:sehat_app/screens/adminScreens/displayOrders.dart';
import 'package:sehat_app/widgets/adminCard.dart';
import 'package:sehat_app/widgets/drawer.dart';

class AdminHomePage extends StatefulWidget {
  final String full_name;
  const AdminHomePage({super.key, required this.full_name});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received a message while in the foreground: ${message.messageId}");
      // Handle the message here (show a notification, etc.)
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message clicked!");
    });

    // Request permissions for iOS
    FirebaseMessaging.instance.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(
        full_name: widget.full_name,
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        // centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Spacing between cards
              children: [
                AdminOptionTiles(
                  tileName: "Add Doctor",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddDoctorScreen()));
                  },
                ),
                SizedBox(width: 10), // Add space between the two cards
                AdminOptionTiles(
                  tileName: "Add Admin",
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(height: 20), // Space between rows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AdminOptionTiles(
                  tileName: "Add Medicines",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddMedicines()));
                  },
                ),
                SizedBox(width: 10), // Add space between the cards
                AdminOptionTiles(
                  tileName: "Display Orders",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DisplayOrders()));
                  },
                ),
              ],
            ),
            SizedBox(height: 20), // Space between rows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AdminOptionTiles(
                  tileName: "Display Medicines",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DisplayMedicines(
                                  full_name: widget.full_name,
                                )));
                  },
                ),
                // SizedBox(width: 10), // Add space between the cards
                Container()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
