import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sehat_app/screens/adminScreens/appointments.dart';
import 'package:sehat_app/widgets/drawer.dart';

class DisplayAppointment extends StatelessWidget {
  final String full_name;
  const DisplayAppointment({super.key, required this.full_name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(
        full_name: full_name,
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        // centerTitle: true,
        backgroundColor: Colors.purple,
        title: Text(
          "List Of Doctors",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("registeredUsers")
                  .where("role", isEqualTo: "Doctor")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No doctors found.'));
                }

                // Map over documents and extract data as List<Map<String, dynamic>>
                List<Map<String, dynamic>> doctors =
                    snapshot.data!.docs.map((doc) => doc.data()).toList();

                return SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.9,
                  child: ListView.builder(
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12),
                          leading: Text(
                            "Dr.${doctor['display_name']}",
                            style: TextStyle(fontSize: 14.5),
                          ),
                          // title: Text(doctor['display_name'] ?? 'No Name'),
                          // subtitle: Text(doctor['Location'] ?? 'No Location'),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            // Navigate to doctor profile if needed.
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DoctorSpecificAppointments(
                                            docDetails: doctor)));
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
