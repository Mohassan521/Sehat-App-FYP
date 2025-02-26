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
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade50,
              Colors.deepPurple.shade100,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailCard(),
              const SizedBox(height: 24),
              _buildPaymentSection(context),
              const SizedBox(height: 24),
              _buildConfirmationButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDetailRow("Patient Name:", widget.patientName),
            const Divider(height: 24),
            _buildDetailRow(
              "Appointment Timings:",
              "${widget.details['appointment_timings']["from"]} - ${widget.details['appointment_timings']["to"]}",
            ),
            const Divider(height: 24),
            _buildDetailRow("Doctor Fees:", widget.details["Fees"]),
            const Divider(height: 24),
            _buildDetailRow(
              "Appointment Day:",
              _formattedSelectedDate(context),
            ),
            const Divider(height: 24),
            _buildDetailRow("Payment Number:", number),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Account Details",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.deepPurple.shade800,
          ),
        ),
        const SizedBox(height: 16),
        _buildBankDropdown(context),
        const SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelText: "Account Number",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            prefixIcon: const Icon(Icons.account_balance_wallet,
                color: Colors.deepPurple),
          ),
        ),
      ],
    );
  }

  Widget _buildBankDropdown(BuildContext context) {
    final banks = [
      'Meezan Bank Ltd.',
      'Dubai Islamic Bank',
      'Bank Alfalah',
      'NBP',
      'HBL',
      'UBL',
      'MCB',
      'Allied Bank Ltd.',
      'Askari Bank Ltd.',
      'Standard Chartered',
      'JazzCash',
      'Nayapay',
      'Sadapay',
      'Easypaisa',
      'Al Baraka Bank',
    ];

    return DropdownButtonFormField<String>(
      value: bankAccount,
      decoration: InputDecoration(
        // labelText: "Bank Account Holder",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        prefixIcon: const Icon(Icons.account_balance, color: Colors.deepPurple),
      ),
      items: [
        const DropdownMenuItem(
            value: '',
            child: Text("Select Bank", style: TextStyle(color: Colors.grey))),
        ...banks
            .map((bank) => DropdownMenuItem(
                  value: bank,
                  child: Text(bank),
                ))
            .toList(),
      ],
      onChanged: (String? newValue) {
        setState(() {
          bankAccount = newValue ?? bankAccount;
        });
      },
    );
  }

  Widget _buildConfirmationButton() {
    return MaterialButton(
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
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Text(
            "Confirm Appointment",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ],
      ),
      minWidth: double.infinity,
      height: 52,
      color: Colors.deepPurple,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  String _formattedSelectedDate(BuildContext context) {
    final dateProvider =
        Provider.of<AppointmentDateProvider>(context, listen: false);
    final date = dateProvider.selectedDate;
    return date != null
        ? "${date.day}-${date.month}-${date.year}"
        : "Not selected";
  }
}
