import 'package:flutter/material.dart';

class AdminOptionTiles extends StatelessWidget {
  final String tileName;
  final Function()? onTap;
  const AdminOptionTiles({super.key, required this.tileName, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 3, // Slightly more elevation for a better shadow effect
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 28, color: Colors.blueAccent),
                SizedBox(height: 10),
                Text(
                  tileName,
                  style: TextStyle(fontSize: 14.2, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
