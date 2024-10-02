import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sehat_app/screens/adminScreens/adminHomePage.dart';
import 'package:sehat_app/screens/doctorScreens/doctorHomePage.dart';
import 'package:sehat_app/screens/frontPage.dart';
import 'package:sehat_app/screens/userHomePage.dart';
import 'package:sehat_app/screens/welcomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLogin();
  }

  void isLogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? role = sp.getString("role");

    if (role == "Admin") {
      Timer(Duration(seconds: 5), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AdminHomePage()));
      });
    } else if (role == "Patient") {
      Timer(Duration(seconds: 5), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => UserHomePage()));
      });
    } else if (role == "Doctor") {
      Timer(Duration(seconds: 5), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DoctorHomePage()));
      });
    } else if (role == null || role == "") {
      Timer(Duration(seconds: 5), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Center(child: Text("Sehat"))],
      ),
    );
  }
}
