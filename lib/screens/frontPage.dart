import 'package:flutter/material.dart';
import 'package:sehat_app/widgets/loginScreen.dart';
import 'package:sehat_app/widgets/registerScreen.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Colors.grey.shade300,
        Colors.grey.shade100
      ],
    ),
    // image: DecorationImage(
    //         image: AssetImage("assets/images/doctor-background.jpg"),
    //         fit: BoxFit.fill,
    //       ),
  ),
  child: Stack(
    children: [
      // Center the text in the gradient background
      Align(
        alignment: Alignment.center,
        child: Text(
          "Centered Text",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        tabs: [
                          Tab(text: "Login"),
                          Tab(text: "Register"),
                        ],
                        labelColor: Colors.black,
                        labelStyle: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                        indicatorColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.tab,
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            LoginPage(),
                            RegisterPage(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  ),
)
    );
  }
}
