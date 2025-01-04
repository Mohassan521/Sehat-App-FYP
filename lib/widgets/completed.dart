import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CompletedAnyTask extends StatelessWidget {
  final String path;
  final String message;
  const CompletedAnyTask(
      {super.key,
      required this.message, required this.path,
});

  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Lottie.asset(path)),
          Center(
              child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                        )),
        ],
      ),
    );
  }
}
