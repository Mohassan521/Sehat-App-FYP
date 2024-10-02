import 'package:flutter/material.dart';

class DoctorCategories extends StatelessWidget {
  const DoctorCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
        color: Colors.deepPurple.shade200,
        ),
        
        child: Row(
          children: [
            Image.asset(
              "assets/images/tooth.png",
              height: 35,
            ),
            SizedBox(
              width: 5,
            ),
            Text("Dentist"),
          ],
        ),
      ),
    );
  }
}
