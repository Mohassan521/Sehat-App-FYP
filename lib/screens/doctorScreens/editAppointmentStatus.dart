import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sehat_app/Provider/provider.dart';
import 'package:sehat_app/screens/chatRoom.dart';
import 'package:sehat_app/services/database_service.dart';

class EditAppointmentStatus extends StatefulWidget {
  final Map<String, dynamic> data;
  const EditAppointmentStatus({super.key, required this.data});

  @override
  State<EditAppointmentStatus> createState() => _EditAppointmentStatusState();
}

class _EditAppointmentStatusState extends State<EditAppointmentStatus> {
  DatabaseService _databaseService = DatabaseService();
  late String _selectedStatus;
  final List<String> appointmentStatus = [
    'Pending',
    'Completed',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointment Summary"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Patient Name: ",
                  style: TextStyle(fontSize: 18),
                ),
                Text(widget.data["Patient Name"],
                    style: TextStyle(fontSize: 18))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Patient Contact: ", style: TextStyle(fontSize: 18)),
                Text(widget.data["Patient Contact"],
                    style: TextStyle(fontSize: 18))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Appointment Date: ", style: TextStyle(fontSize: 18)),
                Text(widget.data["Appointment Date"],
                    style: TextStyle(fontSize: 18))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Appointment ID: ", style: TextStyle(fontSize: 18)),
                Text(widget.data["Appointment id"].toString(),
                    style: TextStyle(fontSize: 18))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Status",
                  style: TextStyle(fontSize: 16.5),
                ),
                Consumer<AppointmentStatusValueProvider>(
                  builder: (context, value, child) {
                    return SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.5,
                      child: DropdownButtonFormField<String>(
                        padding: EdgeInsets.all(5),
                        value: value.selectedValue,
                        items: appointmentStatus.map((String status) {
                          return DropdownMenuItem(
                            alignment: Alignment.center,
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          value.updateValue(newValue ?? "Pending");
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 35,
            ),
            MaterialButton(
              onPressed: () {
                Provider.of<AppointmentStatusValueProvider>(context,
                        listen: false)
                    .updateOrderStatus(
                        widget.data["Appointment id"].toString(), context);
              },
              child: Text("Update Status"),
              color: Colors.purple,
              textColor: Colors.white,
              minWidth: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            SizedBox(
              height: 15,
            ),
            MaterialButton(
              onPressed: () async {
                final patientId = widget.data['Patient ID'];
                final doctorName = widget.data['Patient Name'];
                final currentUserId = FirebaseAuth.instance.currentUser?.uid;

                if (patientId == null ||
                    doctorName == null ||
                    currentUserId == null) {
                  print("One of the required fields is null:");
                  print("Patient ID: $patientId");
                  print("Doctor Name: $doctorName");
                  print("Current User ID: $currentUserId");
                  return; // Exit if any value is null
                }

                print("Your user ID: $currentUserId");
                print("Other person ID: $patientId");
                print("Name of doctor: $doctorName");

                try {
                  final chatExists = await _databaseService.checkChatExists(
                    uid1: patientId,
                    uid2: currentUserId,
                  );

                  if (!chatExists) {
                    await _databaseService.createNewChat(
                      uid1: patientId,
                      uid2: currentUserId,
                    );
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoom(
                        docData: widget.data,
                        full_name: doctorName,
                      ),
                    ),
                  );
                } catch (error) {
                  print("An error occurred: $error");
                }
              },
              child: Text("Chat"),
              color: Colors.purple,
              textColor: Colors.white,
              minWidth: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            MaterialButton(
              onPressed: () {},
              child: Text("Call"),
              color: Colors.purple,
              textColor: Colors.white,
              minWidth: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ],
        ),
      ),
    );
  }
}
