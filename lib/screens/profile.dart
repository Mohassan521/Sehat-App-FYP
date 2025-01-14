import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sehat_app/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final String full_name;
  const ProfileScreen({super.key, required this.full_name});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? role = "";

  Future<void> showEditDetailsDialogDoctor(
      BuildContext context, Map<String, dynamic> order, String uid) {
    final TextEditingController usernameController =
        TextEditingController(text: order["display_name"]);
    final TextEditingController specialityController =
        TextEditingController(text: order["Speciality"]);
    final TextEditingController experience =
        TextEditingController(text: order["Experience"]);
    final TextEditingController location =
        TextEditingController(text: order["Location"]);
    final TextEditingController fees =
        TextEditingController(text: order["Fees"]);

    final TextEditingController emailController =
        TextEditingController(text: order["email"]);

    TimeOfDay parseTimeOfDay(String time) {
      final parts = time.split(":");
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    }

// Initialize with parsed values
    TimeOfDay? fromTime = order["appointment_timings"]["from"] != null
        ? parseTimeOfDay(order["appointment_timings"]["from"])
        : TimeOfDay.now();

    TimeOfDay? toTime = order["appointment_timings"]["to"] != null
        ? parseTimeOfDay(order["appointment_timings"]["to"])
        : TimeOfDay.now();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit User Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Username Field
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                // Contact Field
                TextField(
                  controller: specialityController,
                  decoration: InputDecoration(labelText: 'Speciality'),
                ),
                // Address Field
                TextField(
                  controller: experience,
                  decoration: InputDecoration(labelText: 'Experience'),
                ),
                TextField(
                  controller: location,
                  decoration: InputDecoration(labelText: 'Location'),
                ),
                TextField(
                  controller: fees,
                  decoration: InputDecoration(labelText: 'Fees'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                ListTile(
                  title: Text('Appointment From'),
                  trailing: Text(fromTime!.format(context)),
                  onTap: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: fromTime!,
                    );
                    if (picked != null) {
                      fromTime = picked;
                    }
                  },
                ),
                ListTile(
                  title: Text('Appointment To'),
                  trailing: Text(toTime!.format(context)),
                  onTap: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: toTime!,
                    );
                    if (picked != null) {
                      toTime = picked;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Prepare updated data
                final updatedData = {
                  'display_name': usernameController.text,
                  'Speciality': specialityController.text,
                  'Experience': experience.text,
                  'Location': location.text,
                  "Fees": fees.text,
                  'appointment_timings': {
                    'from':
                        "${fromTime!.hour.toString().padLeft(2, '0')}:${fromTime?.minute.toString().padLeft(2, '0')}",
                    'to':
                        '${toTime!.hour.toString().padLeft(2, '0')}:${toTime?.minute.toString().padLeft(2, '0')}',
                  },
                  "email": emailController.text
                };

                // Call Firestore to update the document
                FirebaseFirestore.instance
                    .collection('registeredUsers')
                    .doc(uid)
                    .update(updatedData)
                    .then((_) {
                  print('User details updated');
                  Navigator.of(context).pop();
                }).catchError((error) {
                  print('Failed to update user details: $error');
                });
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showEditDetailsDialogNonDoctor(
      Map<String, dynamic> order, String uid) {
    final TextEditingController usernameController =
        TextEditingController(text: order["display_name"]);
    final TextEditingController contactController =
        TextEditingController(text: order["contact"]);
    final TextEditingController addressController =
        TextEditingController(text: order["parmanent_address"]);
    final TextEditingController emailController =
        TextEditingController(text: order["email"]);

    // TimeOfDay? fromTime = TimeOfDay.fromDateTime(DateTime.parse(order["appointment_timings"]["from"]));
    // TimeOfDay? toTime = TimeOfDay.fromDateTime(DateTime.parse(order["appointment_timings"]["to"]));

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit User Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Username Field
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                // Contact Field
                TextField(
                  controller: contactController,
                  decoration: InputDecoration(labelText: 'Contact'),
                  keyboardType: TextInputType.phone,
                ),
                // Address Field
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Prepare updated data
                final updatedData = {
                  'display_name': usernameController.text,
                  'contact': contactController.text,
                  'parmanent_address': addressController.text,
                  'email': emailController.text
                };

                // Call Firestore to update the document
                FirebaseFirestore.instance
                    .collection('registeredUsers')
                    .doc(uid)
                    .update(updatedData)
                    .then((_) {
                  print('User details updated');
                  Navigator.of(context).pop();
                }).catchError((error) {
                  print('Failed to update user details: $error');
                });
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void preferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    role = sp.getString("role") ?? "";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      preferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyDrawer(full_name: widget.full_name),
        appBar: AppBar(),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("registeredUsers")
              .where("user_id",
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "Loading Data",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              );
            }

            var order = snapshot.data!.docs.first.data();

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: CircleAvatar(
                      maxRadius: 60,
                      backgroundImage: NetworkImage(
                          "https://avatars.githubusercontent.com/u/35440139?v=4"),
                    ),
                  ),
                  SizedBox(height: 45),
                  buildInfoRow(Icons.person_2_outlined, "Username",
                      order["display_name"]),
                  SizedBox(height: 15),
                  if (role == "Patient") ...[
                    Divider(color: Colors.grey),
                    SizedBox(height: 15),
                    buildInfoRow(
                        Icons.call,
                        "Contact",
                        order["contact"] != null
                            ? "${order["contact"]}"
                            : "Not Applicable"),
                    SizedBox(height: 15),
                    Divider(color: Colors.grey),
                    SizedBox(height: 15),
                    buildInfoRow(
                      Icons.location_history,
                      "Address",
                      order["parmanent_address"] != null
                          ? "${order["parmanent_address"]}"
                          : "Not Applicable",
                    ),
                    SizedBox(height: 15),
                  ],
                  if (role == "Doctor") ...[
                    Divider(color: Colors.grey),
                    SizedBox(height: 15),
                    buildInfoRow(
                      Icons.lock_clock,
                      "Appointment Timings",
                      order["appointment_timings"] != null
                          ? "${order["appointment_timings"]["from"] ?? 'N/A'} - ${order["appointment_timings"]["to"] ?? 'N/A'}"
                          : "Not Applicable",
                    ),
                    SizedBox(height: 15),
                    Divider(color: Colors.grey),
                    SizedBox(height: 15),
                    buildInfoRow(
                      Icons.medication_outlined,
                      "Speciality",
                      order["Speciality"] ?? "N/A",
                    ),
                    SizedBox(height: 15),
                    Divider(color: Colors.grey),
                    SizedBox(height: 15),
                    buildInfoRow(
                      Icons.timeline,
                      "Experience",
                      "${order["Experience"]} years" ?? "N/A",
                    ),
                    SizedBox(height: 15),
                    Divider(color: Colors.grey),
                    SizedBox(height: 15),
                    buildInfoRow(Icons.location_history, "Location",
                        "${order["Location"]}"),
                    SizedBox(height: 15),
                    Divider(color: Colors.grey),
                    SizedBox(height: 15),
                    buildInfoRow(Icons.price_check, "Appointment Fees",
                        "Rs.${order["Fees"]}"),
                    SizedBox(height: 15),
                  ],
                  Divider(color: Colors.grey),
                  SizedBox(height: 15),
                  buildInfoRow(Icons.email, "Email", order["email"]),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: MaterialButton(
                      onPressed: () async {
                        SharedPreferences sp =
                            await SharedPreferences.getInstance();
                        Map<String, dynamic> data = order;
                        role == "Patient" || role == "Admin"
                            ? showEditDetailsDialogNonDoctor(
                                data, sp.getString("id")!)
                            : showEditDetailsDialogDoctor(
                                context, data, sp.getString("id")!);
                      },
                      child: Text("Edit Details"),
                      color: Colors.blue,
                      textColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            );
          },
        ));
  }

  Widget buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon),
              SizedBox(width: 10),
              Text(label, style: TextStyle(fontSize: 15.5)),
            ],
          ),
          Row(
            children: [
              ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width * 0.6),
                  child: Text(value,
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 15.5))),
            ],
          ),
        ],
      ),
    );
  }
}
