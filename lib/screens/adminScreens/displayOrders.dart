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
  TextEditingController _searchController = TextEditingController();
  String searchText = "";

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
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.purple,
        title: const Text(
          "Orders",
          style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 16.5, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0), // Adjusted padding
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200, // Softer background
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400
                          .withOpacity(0.5), // Subtle shadow
                      offset: Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      searchText = value
                          .trim()
                          .toLowerCase(); // Update searchText dynamically
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0), // Adjusted vertical padding
                    hintText: "Search using Order ID",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600, // Softer hint text color
                      fontSize: 16.0, // Readable size
                    ),
                    border: InputBorder.none,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 8.0), // Icon alignment
                      child: Icon(
                        Icons.search,
                        color: Colors.grey.shade600, // Match hint text color
                        size: 24.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("Orders").snapshots(),
              builder: (context, snapshot) {
                var docs = snapshot.data?.docs;

                var filteredOrders = docs?.where((doc) {
                  String orderId = doc["order_id"].toString().toLowerCase();
                  return orderId.contains(searchText);
                }).toList();

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
                    itemCount: filteredOrders?.length,
                    itemBuilder: (context, index) {
                      var order = filteredOrders?[index].data();
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == filteredOrders!.length - 1
                              ? 100.0
                              : 9.0, // Extra space for the last item
                        ),
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
                                                    "${order?["address"]}",
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
                                                          docs: order!,
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
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                ),
                                                Text(
                                                  "${order?["username"]}",
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
                                                  "ID",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                ),
                                                Text(
                                                  "${order?["order_id"]}",
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
                                                  "Order Status",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                ),
                                                Text(
                                                  "${order?["Status"]}",
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
                                                  "Contact",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                ),
                                                Text(
                                                  "${order?["contact"]}",
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
