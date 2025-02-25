import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoctorSpecificAppointments extends StatelessWidget {
  final Map<String, dynamic> docDetails;
  const DoctorSpecificAppointments({super.key, required this.docDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        // centerTitle: true,
        backgroundColor: Colors.purple,
        title: Text(
          "Dr. ${docDetails["display_name"]}",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 15,
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("Appointments")
                    .where("Doctor ID", isEqualTo: docDetails["user_id"])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No Appointments yet.'));
                  }

                  List<Map<String, dynamic>> appointments =
                      snapshot.data!.docs.map((doc) => doc.data()).toList();

                  return SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.9,
                    child: ListView.builder(
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          final appointment = appointments[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index == appointment.length - 1
                                  ? 100.0
                                  : 9.0, // Extra space for the last item
                            ),
                            // padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.location_on),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Appointment Status",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: Colors.grey,
                                                          fontSize: 12),
                                                    ),
                                                    ConstrainedBox(
                                                      constraints: BoxConstraints(
                                                          maxWidth:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width *
                                                                  0.52),
                                                      child: Text(
                                                        "${appointment["Appointment Status"]}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            // InkWell(
                                            //   onTap: () {
                                            //     Navigator.push(
                                            //         context,
                                            //         MaterialPageRoute(
                                            //             builder: (context) =>
                                            //                 EditOrderStatus(
                                            //                   docs: order!,
                                            //                   order_id:
                                            //                       order["order_id"],
                                            //                   orderStatus:
                                            //                       order["Status"],
                                            //                 )));
                                            //   },
                                            //   // child: Text(
                                            //   //   "Edit",
                                            //   //   style: TextStyle(
                                            //   //     fontSize: 12,
                                            //   //     color: Colors.blue,
                                            //   //   ),
                                            //   // ),
                                            //   child: Icon(
                                            //     Icons.arrow_forward_ios,
                                            //     size: 12,
                                            //     color: Colors.blue,
                                            //   ),
                                            // )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.person),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Patient Name",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: Colors.grey,
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      "${appointment["Patient Name"]}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.verified_user),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Appointment Time",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: Colors.grey,
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      "${appointment["Appointment Timings"]}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.delivery_dining),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Appointment Date",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: Colors.grey,
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      "${appointment["Appointment Date"]}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.phone),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Patient Contact",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: Colors.grey,
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      "${appointment["Patient Contact"]}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 13,
                                )
                              ],
                            ),
                          );
                        }),
                  );
                })
          ],
        ),
      ),
    );
  }
}
