import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sehat_app/widgets/completed.dart';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({super.key});

  @override
  State<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController experience = TextEditingController();
  TextEditingController speciality = TextEditingController();
  TextEditingController job_location = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController feesController = TextEditingController();

  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  Map<String, bool> selectedDays = {};

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  // Function to display the time picker and update the selected time
  Future<void> _pickTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          startTime = pickedTime;
          endTime = null; // Reset end time when new start time is selected
        } else {
          // Ensure end time is after start time
          if (pickedTime.hour > startTime!.hour ||
              (pickedTime.hour == startTime!.hour &&
                  pickedTime.minute > startTime!.minute)) {
            endTime = pickedTime;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('End time must be after start time.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      });
    }
  }

  // Function to format the TimeOfDay to display it as a string
  String _formatTime(TimeOfDay? time) {
    if (time == null) return "Select Time";
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var day in days) {
      selectedDays[day] = false; // Default all days to unselected
    }
  }

  var role = "Doctor";
  bool isLoading = false;

  final _auth = FirebaseAuth.instance;

  postDetailsToFirestore(
      String email,
      String role,
      String display_name,
      String speciality,
      String experience,
      String location,
      String dob,
      String fees) async {
    var user = _auth.currentUser;

    String formattedStartTime =
        "${startTime?.hour.toString().padLeft(2, '0')}:${startTime?.minute.toString().padLeft(2, '0')}";
    String formattedEndTime =
        "${endTime?.hour.toString().padLeft(2, '0')}:${endTime?.minute.toString().padLeft(2, '0')}";

    CollectionReference ref =
        FirebaseFirestore.instance.collection('registeredUsers');
    ref.doc(user!.uid).set({
      'user_id': user.uid,
      'email': emailController.text,
      'role': role,
      'display_name': display_name,
      'Speciality': speciality,
      'Experience': experience,
      "Fees": fees,
      'Location': location,
      'Date_of_birth': dob,
      'appointment_timings': {
        'from': formattedStartTime,
        'to': formattedEndTime,
      },
      'available_days': selectedDays
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CompletedAnyTask(
                path: 'assets/images/done.json',
                message: "Doctor Added Succesfully")));
  }

  void signUp(
      String email,
      String password,
      String role,
      String displayName,
      String speciality,
      String experience,
      String location,
      String dob,
      String fees) async {
    setState(() {
      isLoading = true; // Show loader
    });

    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await postDetailsToFirestore(email, role, displayName, speciality,
          experience, location, dob, fees);

      setState(() {
        isLoading = false; // Hide loader when done
      });

      // Show success message or navigate to another screen
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Signup successful!")));
    } catch (e) {
      setState(() {
        isLoading = false; // Hide loader on error
      });

      // Show error message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text("Sign Up")),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Full Name"),
                  SizedBox(height: 5),
                  TextFormField(
                      controller: name,
                      decoration:
                          InputDecoration(border: OutlineInputBorder())),
                  SizedBox(height: 10),
                  Text("Email"),
                  SizedBox(height: 5),
                  TextFormField(
                      controller: emailController,
                      decoration:
                          InputDecoration(border: OutlineInputBorder())),
                  SizedBox(height: 10),
                  Text("Contact Number"),
                  SizedBox(height: 5),
                  TextFormField(
                      controller: contact,
                      decoration:
                          InputDecoration(border: OutlineInputBorder())),
                  SizedBox(height: 10),
                  Text("Date Of Birth"),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: dob,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        dob.text =
                            "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  Text("Years Of Experience"),
                  SizedBox(height: 5),
                  TextFormField(
                      controller: experience,
                      keyboardType: TextInputType.number,
                      decoration:
                          InputDecoration(border: OutlineInputBorder())),
                  SizedBox(height: 10),
                  Text("Speciality"),
                  SizedBox(height: 5),
                  TextFormField(
                      controller: speciality,
                      decoration:
                          InputDecoration(border: OutlineInputBorder())),
                  SizedBox(height: 10),
                  Text("Job Location (Mention Hospital Name)"),
                  SizedBox(height: 5),
                  TextFormField(
                      controller: job_location,
                      decoration:
                          InputDecoration(border: OutlineInputBorder())),
                  SizedBox(height: 10),
                  Text("Appointment Fees"),
                  SizedBox(height: 5),
                  TextFormField(
                      controller: feesController,
                      keyboardType: TextInputType.number,
                      decoration:
                          InputDecoration(border: OutlineInputBorder())),
                  SizedBox(height: 10),
                  Text("Select Days of Appointment"),
                  SizedBox(height: 5),
                  Column(
                    children: days.map((day) {
                      return CheckboxListTile(
                        title: Text(day),
                        value: selectedDays[day],
                        onChanged: (bool? value) {
                          setState(() {
                            selectedDays[day] = value!;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  Text("Appointment Timings"),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Start Time"),
                          ElevatedButton(
                            onPressed: () => _pickTime(context, true),
                            child: Text(_formatTime(startTime)),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("End Time"),
                          ElevatedButton(
                            onPressed: startTime == null
                                ? null
                                : () => _pickTime(context, false),
                            child: Text(_formatTime(endTime)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  startTime == null ? Colors.grey : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("Password"),
                  SizedBox(height: 5),
                  TextFormField(
                      controller: passwordController,
                      decoration:
                          InputDecoration(border: OutlineInputBorder())),
                  SizedBox(height: 20),
                  MaterialButton(
                    onPressed: isLoading
                        ? null // Disable button while loading
                        : () {
                            signUp(
                              emailController.text,
                              passwordController.text,
                              role,
                              name.text,
                              speciality.text,
                              experience.text,
                              job_location.text,
                              dob.text,
                              feesController.text,
                            );
                          },
                    child: isLoading
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                              SizedBox(width: 10),
                              Text("Processing..."),
                            ],
                          )
                        : Text("Submit"),
                    minWidth: double.infinity,
                    height: 50,
                    color: isLoading ? Colors.grey : Colors.purple,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        if (isLoading) // Show full-screen loader
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }
}
