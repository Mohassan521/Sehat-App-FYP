import 'package:flutter/material.dart';
import 'package:sehat_app/screens/userHomePage.dart';
import 'package:sehat_app/screens/frontPage.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset("assets/images/doctor_welcome.jpg")),
            SizedBox(
              height: 15,
            ),
            Center(child: Text("All Specialists in One App", style: TextStyle(fontSize: 22.5, fontWeight: FontWeight.bold),)),
            SizedBox(
              height: 15,
            ),
            Center(child: Text("Find doctor and make an appointment in one Tap", style: TextStyle(fontSize: 16),)),
        SizedBox(
              height: 25,
            ),
            MaterialButton(onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FrontPage()));
            },
            child: Text("Get Started", style: TextStyle(fontSize: 16),),

            color: Colors.blue,
            textColor: Colors.white,
            padding: EdgeInsets.all(15),
            minWidth: double.infinity,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            )
          ],
        ),
      ),
    );
  }
}