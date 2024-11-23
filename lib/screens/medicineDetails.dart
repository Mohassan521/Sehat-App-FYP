import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sehat_app/Utils/Utils.dart';
import 'package:sehat_app/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicineDetails extends StatelessWidget {
  final Map<String, dynamic> medDetails;
  const MedicineDetails({super.key, required this.medDetails});

  @override
  Widget build(BuildContext context) {

    final DatabaseService _databaseService = DatabaseService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Hero(
              tag: medDetails["Image"],
              child: Image.network(medDetails["Image"])),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Name: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                      Text(medDetails["Medicine Name"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      
                    ],
                  ),
                  SizedBox(
              height: 10,
            ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Manufacturer: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width * 0.45),
                        child: Text(medDetails["Manufacturer"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
                      
                    ],
                  ),
                  SizedBox(
              height: 10,
            ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Dosage Form: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                      Text(medDetails["Dosage Form"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      
                    ],
                  ),
                  SizedBox(
              height: 10,
            ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Description: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width * 0.65),
                        child: Text(medDetails["Description"], textAlign: TextAlign.end ,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
                      
                    ],
                  ),
                  SizedBox(
              height: 10,
            ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Category: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                      Text(medDetails["Medicine Category"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      
                    ],
                  ),
                  SizedBox(
              height: 10,
            ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Available in: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width * 0.65),
                        child: Text(medDetails["Pharmacy Name"], textDirection: TextDirection.rtl, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
                      
                    ],
                  ),
                  SizedBox(
              height: 10,
            ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Prescription Required: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                      Text(medDetails["Prescription Required"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      
                    ],
                  ),
                  SizedBox(
              height: 10,
            ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Price: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                      Text("Rs.${medDetails["Price (per strip)"].toString()}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  MaterialButton(onPressed: () async {
                    SharedPreferences sp = await SharedPreferences.getInstance();
                    String user_id =  sp.getString("id") ?? "";
                    _databaseService.insertCartItem({
  'userId': user_id,
  'medName': medDetails["Medicine Name"],
  'medPrice': medDetails["Price (per strip)"],
  'qty': 1,
  'medImage': medDetails["Image"],
}).then((value){
  Utils().toastMessage("Medicine Added to Cart", Colors.orange, Colors.white);
});
                  },
                  child: Center(child: Text("Add To Cart")),
                  padding: EdgeInsets.all(15),
                  color: Colors.orange,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}