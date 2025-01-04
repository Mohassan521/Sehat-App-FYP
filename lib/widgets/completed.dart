import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sehat_app/screens/medicines_inventory.dart';
import 'package:sehat_app/screens/userHomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      // appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Lottie.asset(path)),
          Center(
              child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.green),
                        )),
          SizedBox(
            height: 90,
          ),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserHomePage(
                    full_name: sp.getString("fullName"),
                  )));
                },
                child: const Column(
                  children: [
                    Icon(Icons.home_outlined, size: 32,),
                    Text("Home Screen", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),)
                  ],
                ),
              ),
              SizedBox(
                width: 35,
              ),
              InkWell(
                onTap: () async {
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MedicineInventory(full_name: sp.getString("fullName")!)));
                },
                child: Column(
                  children: [
                    Icon(Icons.local_pharmacy_outlined,size: 32,),
                    Text("Medicines Inventory", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
