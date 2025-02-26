import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sehat_app/Provider/provider.dart';
import 'package:sehat_app/widgets/completed.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> details;
  final String patientName;
  const PaymentScreen(
      {super.key, required this.details, required this.patientName});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String bankAccount = "";
  final String number = "090078601";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Appointment Details",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Patient Name: "),
                Text(widget.patientName),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Appointment Timings: "),
                Text(
                    "${widget.details['appointment_timings']["from"]} - ${widget.details['appointment_timings']["to"]}"),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Doctor Fees: "),
                Text(widget.details["Fees"]),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Appointment Day: "),
                Text(
                    "${Provider.of<AppointmentDateProvider>(context, listen: false).selectedDate?.day}-${Provider.of<AppointmentDateProvider>(context, listen: false).selectedDate?.month}-${Provider.of<AppointmentDateProvider>(context, listen: false).selectedDate?.year}"),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Easy Paisa / Jazzcash (for Payment): "),
                Text(number),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text("Your Bank Account Holder"),
            SizedBox(
              height: 5,
            ),
            Container(
              height: MediaQuery.sizeOf(context).height * 0.055,
              padding: EdgeInsets.only(left: 9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.5),
                // color: Colors.white,

                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: DropdownButton<String>(
                alignment: Alignment.center,
                isExpanded: true,
                underline: SizedBox(),
                value: bankAccount,
                onChanged: (String? newValue) {
                  setState(() {
                    bankAccount = newValue ?? bankAccount;
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                      value: '',
                      child: Center(
                          child: Text(
                        '',
                        style: TextStyle(fontSize: 12),
                      ))),
                  DropdownMenuItem<String>(
                      value: 'Meezan Bank Ltd.',
                      child: Center(
                          child: Text(
                        'Meezan Bank Ltd.',
                        style: TextStyle(fontSize: 12),
                      ))),
                  DropdownMenuItem<String>(
                      value: 'Dubai Islamic Bank',
                      child: Center(
                          child: Text('Dubai Islamic Bank',
                              style: TextStyle(fontSize: 12)))),
                  DropdownMenuItem<String>(
                      value: 'Bank Alfalah',
                      child: Center(
                          child: Text('Bank Alfalah',
                              style: TextStyle(fontSize: 12)))),
                  DropdownMenuItem<String>(
                      value: 'NBP',
                      child: Center(
                          child: Text('NBP', style: TextStyle(fontSize: 12)))),
                  DropdownMenuItem<String>(
                      value: 'HBL',
                      child: Center(
                          child: Text('HBL', style: TextStyle(fontSize: 12)))),
                  DropdownMenuItem<String>(
                      value: 'UBL',
                      child: Center(
                          child: Text('UBL', style: TextStyle(fontSize: 12)))),
                  DropdownMenuItem<String>(
                      value: 'MCB',
                      child: Center(
                          child: Text('MCB', style: TextStyle(fontSize: 12)))),
                  DropdownMenuItem<String>(
                      value: 'Allied Bank Ltd.',
                      child: Center(
                          child: Text('Allied Bank Ltd.',
                              style: TextStyle(fontSize: 12)))),
                  DropdownMenuItem<String>(
                      value: 'Askari Bank Ltd.',
                      child: Center(
                          child: Text('Askari Bank Ltd.',
                              style: TextStyle(fontSize: 12)))),
                  DropdownMenuItem<String>(
                      value: 'Standard Chartered',
                      child: Center(
                          child: Text('Standard Chartered',
                              style: TextStyle(fontSize: 12)))),
                  DropdownMenuItem<String>(
                      value: 'JazzCash',
                      child: Center(
                          child: Text('JazzCash',
                              style: TextStyle(fontSize: 12)))),
                  DropdownMenuItem<String>(
                      value: 'Nayapay',
                      child: Center(
                          child:
                              Text('Nayapay', style: TextStyle(fontSize: 12)))),
                  DropdownMenuItem<String>(
                      value: 'Sadapay',
                      child: Center(
                          child:
                              Text('Sadapay', style: TextStyle(fontSize: 12)))),
                  DropdownMenuItem<String>(
                      value: 'Easypaisa',
                      child: Center(
                          child: Text('Easypaisa',
                              style: TextStyle(fontSize: 12)))),
                  DropdownMenuItem<String>(
                      value: 'Al Baraka Bank',
                      child: Center(
                          child: Text('Al Baraka Bank',
                              style: TextStyle(fontSize: 12)))),
                ],
              ),
            ),

            SizedBox(
              height: 15,
            ),
            Text("Your Account Number"),
            SizedBox(height: 5),
            TextFormField(
                // controller: name,
                decoration: InputDecoration(border: OutlineInputBorder())),
            SizedBox(
              height: 20,
            ),
            // Text("Full Name"),
            // SizedBox(height: 5),
            // TextFormField(
            //     // controller: name,
            //     decoration: InputDecoration(border: OutlineInputBorder())),
            MaterialButton(
              onPressed: () async {
                if (Provider.of<AppointmentDateProvider>(context, listen: false)
                        .selectedDate !=
                    null) {
                  int apid = Random().nextInt(900);
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  CollectionReference ref =
                      FirebaseFirestore.instance.collection("Appointments");
                  ref.doc(apid.toString()).set({
                    "Appointment id": apid,
                    "Doctor Name": widget.details["display_name"],
                    "Patient Name": widget.patientName,
                    "Patient Contact": sp.getString("contact"),
                    "Doctor Fees": widget.details["Fees"],
                    "Patient ID": sp.getString("id"),
                    "Doctor ID": widget.details["user_id"],
                    "Appointment Timings": widget.details['appointment_timings']
                            ["from"] +
                        "-" +
                        widget.details['appointment_timings']["to"],
                    "Appointment Date":
                        "${Provider.of<AppointmentDateProvider>(context, listen: false).selectedDate?.day}-${Provider.of<AppointmentDateProvider>(context, listen: false).selectedDate?.month}-${Provider.of<AppointmentDateProvider>(context, listen: false).selectedDate?.year}",
                    "Appointment Status": "Pending",
                    // "Speciality": widget.docData['Speciality'],
                  }).then((val) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompletedAnyTask(
                                message: "Appointment Confirmed",
                                path: "assets/images/done.json",
                                name: widget.patientName)));
                    // Navigator.pop(context);
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //       content: Text('Appointment Created Successfully')),
                    // );
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        'You need to select appointment date',
                        style: TextStyle(color: Colors.white),
                      )));
                }
              },
              child: Text("Confirm Appointment"),
              minWidth: double.infinity,
              color: Colors.purple,
              textColor: Colors.white,
              padding: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            )
          ],
        ),
      ),
    );
  }
}
