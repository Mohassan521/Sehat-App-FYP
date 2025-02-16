import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sehat_app/Provider/provider.dart';
import 'package:sehat_app/screens/callScreen.dart';
import 'package:sehat_app/screens/chatRoom.dart';
import 'package:sehat_app/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorProfileScreen extends StatefulWidget {
  final String full_name;
  final Map<String, dynamic> docData;

  const DoctorProfileScreen(
      {super.key, required this.docData, required this.full_name});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final GetIt _getIt = GetIt.instance;

  // late AuthService _authService;
  // late NavigationService _navigationService;
  // late AlertService _alertService;
  late DatabaseService _databaseService;
  bool isAvailable = false;

  ChatUser? currentUser, otherUser;
  String _channelController = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _databaseService = _getIt.get<DatabaseService>();
    checkAvailability();

    currentUser = ChatUser(
        id: FirebaseAuth.instance.currentUser!.uid,
        firstName: widget.full_name);
  }

  void checkAvailability() {
    String fromTime =
        widget.docData['appointment_timings']['from']; // e.g., '6:00'
    String toTime = widget.docData['appointment_timings']['to']; // e.g., '8:00'

    // Convert from and to time to DateTime objects
    DateTime now = DateTime.now();
    DateTime from = _parseTimeOfDay(fromTime);
    DateTime to = _parseTimeOfDay(toTime);

    if (now.isAfter(from) && now.isBefore(to)) {
      setState(() {
        isAvailable = true;
      });
    } else {
      setState(() {
        isAvailable = false;
      });
    }
  }

  DateTime _parseTimeOfDay(String timeString) {
    final now = DateTime.now();
    final timeParts = timeString.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  @override
  Widget build(BuildContext context) {
    print("Name of current user: ${FirebaseAuth.instance.currentUser?.email}");
    DateTime? _selectedDate;

    final screenHeight = MediaQuery.of(context).size.height;

    Map<String, bool> appointmentDaysMap =
        Map<String, bool>.from(widget.docData['available_days']);

    List<String> allDays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];

    // Filter and sort the available days
    List<String> selectedDays = [];
    allDays.forEach((day) {
      if (appointmentDaysMap[day] == true) {
        selectedDays.add(day);
      }
    });

    String appointmentDaysString = selectedDays.join(', ');

    String formatAppointmentTimings(Map<String, dynamic> appointmentTimings) {
      if (appointmentTimings.containsKey('from') &&
          appointmentTimings.containsKey('to')) {
        // Convert Firestore's timestamp or string to TimeOfDay if necessary, otherwise, just use the values
        String fromTime = appointmentTimings['from']; // e.g., '6:00'
        String toTime = appointmentTimings['to']; // e.g., '8:00'

        return '$fromTime - $toTime';
      } else {
        return 'N/A'; // Return a fallback value if 'from' or 'to' is missing
      }
    }

    bool isDateAllowed(DateTime date) {
      // Get the day of the week (e.g., Monday, Tuesday)
      final dayName = DateFormat('EEEE')
          .format(date); // Converts date to a string like "Monday"

      // Check if this day is available in the doctor's schedule
      return appointmentDaysMap[dayName] == true;
    }

    void selectAppointmentDate(BuildContext context) async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(
            Duration(days: 30)), // Restrict selection to 30 days from today
        selectableDayPredicate: isDateAllowed, // Pass the allowed dates
      );

      if (pickedDate != null) {
        Provider.of<AppointmentDateProvider>(context, listen: false)
            .updateDate(pickedDate);
      }
    }

    void appointmentDialog(String docName, String patientName, String contact,
        String fees, String timings, String docLocation) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Doctor Name: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text(docName,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Patient Name: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      Text(patientName,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Patient Contact: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      Text(contact,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Doctor Fees: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      Text("Rs.$fees",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Appointment Timings: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      Text(timings.toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Select Date: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      InkWell(
                        onTap: () {
                          selectAppointmentDate(context);
                        },
                        child: Consumer<AppointmentDateProvider>(
                          builder: (context, value, child) {
                            return Text(
                                value.selectedDate != null
                                    ? "${value.selectedDate!.day}-${value.selectedDate!.month}-${value.selectedDate!.year}"
                                    : "Choose Date",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700));
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      if (Provider.of<AppointmentDateProvider>(context,
                                  listen: false)
                              .selectedDate !=
                          null) {
                        int apid = Random().nextInt(900);
                        SharedPreferences sp =
                            await SharedPreferences.getInstance();
                        CollectionReference ref = FirebaseFirestore.instance
                            .collection("Appointments");
                        ref.doc(apid.toString()).set({
                          "Appointment id": apid,
                          "Doctor Name": widget.docData["display_name"],
                          "Patient Name": widget.full_name,
                          "Patient Contact": sp.getString("contact"),
                          "Doctor Fees": widget.docData["Fees"],
                          "Patient ID": sp.getString("id"),
                          "Doctor ID": widget.docData["user_id"],
                          "Appointment Timings":
                              widget.docData['appointment_timings']["from"] +
                                  "-" +
                                  widget.docData['appointment_timings']["to"],
                          "Appointment Date":
                              "${Provider.of<AppointmentDateProvider>(context, listen: false).selectedDate?.day}-${Provider.of<AppointmentDateProvider>(context, listen: false).selectedDate?.month}-${Provider.of<AppointmentDateProvider>(context, listen: false).selectedDate?.year}",
                          "Appointment Status": "Pending",
                          // "Speciality": widget.docData['Speciality'],
                        }).then((val) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Appointment Created Successfully')),
                          );
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
                    child: const Text("Confirm Appointment"),
                    minWidth: double.infinity,
                    color: Colors.purple,
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  )
                ],
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        title: Text(
          "Dr. ${widget.docData['display_name']}",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image section
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    image: DecorationImage(
                      image: AssetImage("assets/images/doctor1.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      widget.docData['Speciality'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade800,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor Details
                  _buildDetailRow(
                      "Experience:", "${widget.docData['Experience']} years"),
                  SizedBox(height: 15),
                  _buildDetailRow("Location:", widget.docData['Location']),
                  SizedBox(height: 15),
                  _buildDetailRow(
                      "Appointment Fees:", "Rs.${widget.docData['Fees']}"),
                  SizedBox(height: 15),
                  _buildDetailRow("Appointment Days:", appointmentDaysString),
                  SizedBox(height: 15),
                  _buildDetailRow(
                    "Appointment Timings:",
                    formatAppointmentTimings(
                        widget.docData['appointment_timings']),
                  ),

                  SizedBox(height: 40),

                  // Buttons Section
                  Center(
                    child: Column(
                      children: [
                        // Book Appointment Button
                        MaterialButton(
                          onPressed: () async {
                            SharedPreferences sp =
                                await SharedPreferences.getInstance();
                            String contact = sp.getString("contact") ?? "";
                            appointmentDialog(
                              widget.docData['display_name'],
                              sp.getString("fullName") ?? "",
                              contact,
                              widget.docData['Fees'],
                              widget.docData['appointment_timings']["from"] +
                                  "-" +
                                  widget.docData['appointment_timings']["to"],
                              widget.docData['Location'],
                            );
                          },
                          child: Text(
                            'Book Appointment',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          padding: EdgeInsets.all(15),
                          textColor: Colors.white,
                          color: Colors.deepPurple,
                          minWidth: double.infinity,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        SizedBox(height: 15),

                        // Chat Button
                        MaterialButton(
                          onPressed: () async {
                            final chatExists =
                                await _databaseService.checkChatExists(
                              uid1: FirebaseAuth.instance.currentUser?.uid,
                              uid2: widget.docData['user_id'],
                            );

                            if (!chatExists) {
                              await _databaseService.createNewChat(
                                uid1: FirebaseAuth.instance.currentUser?.uid,
                                uid2: widget.docData['user_id'],
                              );
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatRoom(
                                  docData: widget.docData,
                                  full_name: widget.full_name,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.chat, size: 20),
                              SizedBox(width: 8),
                              Text("Chat"),
                            ],
                          ),
                          minWidth: double.infinity,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textColor: Colors.white,
                          color: Colors.green,
                          padding: EdgeInsets.all(15),
                        ),
                        SizedBox(height: 15),

                        // Call Button
                        isAvailable == true
                            ? MaterialButton(
                                onPressed: () {
                                  _channelController = currentUser!.id;
                                  if (_channelController.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CallScreen(
                                          channelName: _channelController,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.call_made),
                                    SizedBox(width: 8),
                                    Text("Call"),
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textColor: Colors.white,
                                color: Colors.red,
                                padding: EdgeInsets.all(15),
                              )
                            : Center(
                                child: Text(
                                  "Doctor is not available for calls. Please chat or book an appointment.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.55),
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
