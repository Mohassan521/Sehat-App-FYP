import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sehat_app/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersScreen extends StatefulWidget {
  final String full_name;
  const OrdersScreen({super.key, required this.full_name});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String user_id = "";

  String _getMonthName(int month) {
    const monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return monthNames[month - 1];
  }

  Future<void> preferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    user_id = sp.getString("id")!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    preferences();
  }

  @override
  Widget build(BuildContext context) {
    print("user id $user_id");

    return Scaffold(
      drawer: MyDrawer(full_name: widget.full_name),
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.5),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("Orders").snapshots(),
              builder: (context, snapshot) {
                var docs = snapshot.data?.docs.where((doc) {
                  return doc['user_id'] == user_id;
                }).toList();

                docs?.sort((a, b) {
                  DateTime aDate = (a["timestamp"] as Timestamp).toDate();
                  DateTime bDate = (b["timestamp"] as Timestamp).toDate();
                  return bDate.compareTo(aDate);
                });

                if (docs == null || docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Orders Found",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  );
                }

                return SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.9,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var order = docs[index].data();
                      var rawTimestamp = order['timestamp'];
                      DateTime orderDate = (rawTimestamp as Timestamp).toDate();
                      String formattedDate =
                          "${orderDate.day.toString().padLeft(2, '0')} ${_getMonthName(orderDate.month)} ${orderDate.year}";
                      return Column(
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
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.access_time),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                order["Status"],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.blue,
                                                    fontSize: 15.5),
                                              ),
                                              Text(
                                                formattedDate,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 14,
                                        ),
                                      )
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
                                          Icon(Icons.receipt_long),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Order",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                "CWT${order["order_id"]}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_month),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Shipping Date",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                formattedDate,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
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
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
