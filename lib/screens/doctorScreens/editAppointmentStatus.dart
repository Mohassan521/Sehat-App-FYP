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
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Appointment Summary",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [Colors.purple, Colors.deepPurple],
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomRight,
        //     ),
        //   ),
        // ),
        // elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Text
            Text(
              "Appointment Details",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 20),

            // Card for Details
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    DetailRow(
                      icon: Icons.person,
                      label: "Patient Name:",
                      value: widget.data["Patient Name"],
                    ),
                    Divider(),
                    DetailRow(
                      icon: Icons.phone,
                      label: "Patient Contact:",
                      value: widget.data["Patient Contact"],
                    ),
                    Divider(),
                    DetailRow(
                      icon: Icons.calendar_today,
                      label: "Appointment Date:",
                      value: widget.data["Appointment Date"],
                    ),
                    Divider(),
                    DetailRow(
                      icon: Icons.assignment,
                      label: "Appointment ID:",
                      value: widget.data["Appointment id"].toString(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),

            // Status Dropdown
            Text(
              "Appointment Status",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 10),
            Consumer<AppointmentStatusValueProvider>(
              builder: (context, value, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.deepPurple, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: value.selectedValue,
                      items: appointmentStatus.map((String status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Row(
                            children: [
                              Icon(
                                status == "Pending"
                                    ? Icons.hourglass_empty
                                    : status == "Completed"
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                color: status == "Pending"
                                    ? Colors.orange
                                    : status == "Completed"
                                        ? Colors.green
                                        : Colors.red,
                              ),
                              SizedBox(width: 10),
                              Text(status),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        value.updateValue(newValue ?? "Pending");
                      },
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ActionButton(
                    label: "Update Status",
                    color: Colors.purple,
                    icon: Icons.update,
                    onPressed: () {
                      Provider.of<AppointmentStatusValueProvider>(context,
                              listen: false)
                          .updateOrderStatus(
                              widget.data["Appointment id"].toString(),
                              context);
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ActionButton(
                    label: "Chat",
                    color: Colors.deepPurple,
                    icon: Icons.chat,
                    onPressed: () async {
                      final patientId = widget.data['Patient ID'];
                      final doctorName = widget.data['Patient Name'];
                      final currentUserId =
                          FirebaseAuth.instance.currentUser?.uid;

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
                        final chatExists =
                            await _databaseService.checkChatExists(
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
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            ActionButton(
              label: "Call",
              color: Colors.green,
              icon: Icons.call,
              onPressed: () {
                // Call logic here
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 28),
        SizedBox(width: 15),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}

// Reusable ActionButton Widget
class ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  ActionButton(
      {required this.label,
      required this.color,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
