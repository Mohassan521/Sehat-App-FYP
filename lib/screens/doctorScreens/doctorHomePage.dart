import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sehat_app/screens/doctorScreens/doctorProfile.dart';
import 'package:sehat_app/screens/doctorScreens/editAppointmentStatus.dart';
import 'package:sehat_app/widgets/doctorCategories.dart';
import 'package:sehat_app/widgets/doctorDrawer.dart';
import 'package:sehat_app/widgets/drawer.dart';

class DoctorHomePage extends StatefulWidget {
  final String uid;
  final String? full_name;
  const DoctorHomePage({super.key, this.full_name, required this.uid});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  // https://asset-cdn.lottiefiles
  @override
  Widget build(BuildContext context) {
    print(widget.uid);
    return Scaffold(
      drawer: MyDrawer(
        full_name: widget.full_name!,
      ),
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Column(
            children: [
              // appbar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hello,",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          "Dr.${widget.full_name}",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.deepPurple.shade100,
                            borderRadius: BorderRadius.circular(12)),
                        child: Icon(Icons.person)),
                  ],
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.pink.shade100,
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      // animation or image

                      Container(
                          height: 100,
                          width: 100,
                          child: LottieBuilder.network(
                              "https://lottie.host/4dfc91ff-dd16-4617-803f-85cb4e4f0c7f/ceb4eLE4ap.json")),

                      SizedBox(
                        width: 20,
                      ),

                      // text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "How do you feel?",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Fill out your Medical Card Right Now",
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                  child: Text(
                                "Get Started",
                                style: TextStyle(color: Colors.white),
                              )),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // search area

              SizedBox(
                height: 25,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "How can we help you?",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search)),
                  ),
                ),
              ),

              SizedBox(
                height: 25,
              ),

              // Container(
              //   height: MediaQuery.sizeOf(context).height * 0.08,
              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     children: [

              //       DoctorCategories(),
              //       DoctorCategories(),
              //     ],
              //   ),
              // )

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your Appointments",
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "See All",
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade700),
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 5,
              ),

              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.8,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("Appointments")
                      .where("Doctor ID",
                          isEqualTo: widget.uid) // Query by doctor ID
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData ||
                        snapshot.data == null ||
                        snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          "No Appointments Yet",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                      );
                    }

                    // Retrieve the list of documents
                    var appointments = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        var data = appointments[index].data();

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 8.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.person),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Patient Name",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              "${data["Patient Name"]}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditAppointmentStatus(
                                              data: data,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 12,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.phone),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Patient Contact",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              "${data["Patient Contact"]}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.date_range),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Appointment Date",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              "${data["Appointment Date"]}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.medical_services),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Appointment Status",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              "${data["Appointment Status"]}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.timer),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Appointment Timings",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              "${data["Appointment Timings"]}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
