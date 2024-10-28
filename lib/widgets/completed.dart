import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CompletedAnyTask extends StatelessWidget {
  final String message;
  const CompletedAnyTask(
      {super.key,
      required this.message,
});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Lottie.asset('assets/images/done.json')),
          Center(
              child: Text(
            message,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          )),
        ],
      ),
    );
  }
}
