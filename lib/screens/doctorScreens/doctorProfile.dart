import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sehat_app/screens/callScreen.dart';
import 'package:sehat_app/screens/chatRoom.dart';
import 'package:sehat_app/services/database_service.dart';

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

    return Scaffold(
        appBar: AppBar(
          title: Text("Dr. ${widget.docData['display_name']}"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Image section (fixed height)
              Container(
                height: screenHeight * 0.3,
                width: double.infinity,
                child: Hero(
                  tag: widget.docData["user_id"],
                  child: Image.asset(
                    "assets/images/doctor1.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Content section (scrollable)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Speciality:", style: TextStyle(fontSize: 16)),
                        Text(
                          widget.docData['Speciality'],
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Experience:", style: TextStyle(fontSize: 16)),
                        Text(
                          '${widget.docData['Experience']} years',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Location:", style: TextStyle(fontSize: 16)),
                        Text(
                          widget.docData['Location'],
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Appointment Fees:",
                            style: TextStyle(fontSize: 16)),
                        Text(
                          'Rs.${widget.docData['Fees']}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Appointment Days:",
                            style: TextStyle(fontSize: 16)),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.sizeOf(context).width * 0.45),
                          child: Text(
                            appointmentDaysString,
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Appointment Timings",
                            style: TextStyle(fontSize: 16)),
                        Text(
                          formatAppointmentTimings(
                              widget.docData['appointment_timings']),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),

                    SizedBox(height: 50),

                    // Book Appointment Button
                    Center(
                      child: MaterialButton(
                        onPressed: () {
                          // Handle book appointment action
                        },
                        child: Text('Book Appointment'),
                        padding: EdgeInsets.all(17),
                        textColor: Colors.white,
                        color: Colors.deepPurple.shade300,
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),

                    SizedBox(height: 15),

                    // Chat Button
                    MaterialButton(
                      onPressed: () async {
                        print(
                            "Your user ID: ${FirebaseAuth.instance.currentUser?.uid}");
                        print("Other person ID: ${widget.docData['user_id']}");
                        final chatExists =
                            await _databaseService.checkChatExists(
                                uid1: FirebaseAuth.instance.currentUser?.uid,
                                uid2: widget.docData['user_id']);

                        if (!chatExists) {
                          await _databaseService.createNewChat(
                              uid1: FirebaseAuth.instance.currentUser?.uid,
                              uid2: widget.docData['user_id']);
                        }

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatRoom(
                                      docData: widget.docData,
                                      full_name: widget.full_name,
                                    )));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text("Chat"),
                        ],
                      ),
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.5)),
                      textColor: Colors.white,
                      color: Colors.green,
                      padding: EdgeInsets.all(17),
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
                                            )));
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
                                borderRadius: BorderRadius.circular(9.5)),
                            textColor: Colors.white,
                            color: Colors.red,
                            padding: EdgeInsets.all(17),
                          )
                        : Center(
                            child: const Text(
                              "Doctor is not available in this time slot for call, however you can chat or book appointment in his fixed hours",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
