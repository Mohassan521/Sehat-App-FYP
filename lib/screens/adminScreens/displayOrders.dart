import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sehat_app/screens/adminScreens/editOrderStatusPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplayOrders extends StatefulWidget {
  const DisplayOrders({super.key});

  @override
  State<DisplayOrders> createState() => _DisplayOrdersState();
}

class _DisplayOrdersState extends State<DisplayOrders> {
  String user_id = "";

  Future<void> preferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    user_id = sp.getString("id")!;
  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    preferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Orders",
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
                var docs = snapshot.data?.docs;

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
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var order = docs[index].data();
                      // var rawTimestamp = order['timestamp'];
                      // DateTime orderDate = (rawTimestamp as Timestamp).toDate();
                      // String formattedDate =
                      //     "${orderDate.day.toString().padLeft(2, '0')} ${_getMonthName(orderDate.month)} ${orderDate.year}";
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
                                          Icon(Icons.location_on),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Shipping Address",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                              ),
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.52),
                                                child: Text(
                                                  "${order["address"]}",
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
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditOrderStatus(
                                                        docs: order,
                                                        order_id:
                                                            order["order_id"],
                                                        orderStatus:
                                                            order["Status"],
                                                      )));
                                        },
                                        // child: Text(
                                        //   "Edit",
                                        //   style: TextStyle(
                                        //     fontSize: 12,
                                        //     color: Colors.blue,
                                        //   ),
                                        // ),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 12,
                                          color: Colors.blue,
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
                                          Icon(Icons.person),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Customer Name",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                "${order["username"]}",
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
                                          Icon(Icons.currency_exchange),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Total Price",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                "${order["total_price"]}",
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
                                                "Order Status",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                "${order["Status"]}",
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
                                          Icon(Icons.phone),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Contact",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                "${order["contact"]}",
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
