import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sehat_app/Provider/provider.dart';
import 'package:sehat_app/widgets/drawer.dart';

class DisplayMedicines extends StatefulWidget {
  final String full_name;
  const DisplayMedicines({super.key, required this.full_name});

  @override
  State<DisplayMedicines> createState() => _DisplayMedicinesState();
}

class _DisplayMedicinesState extends State<DisplayMedicines> {
  String _selectedStatus = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(full_name: widget.full_name),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.purple,
        title: Text(
          "Medicines",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Medicines")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text("No Medicines Added yet"),
                  );
                }

                var docs = snapshot.data?.docs;
                return SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.9,
                  child: ListView.builder(
                    itemCount: docs?.length,
                    itemBuilder: (context, index) {
                      var data = docs?[index].data();
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 15),
                        child: Card(
                          elevation: 0.5,
                          child: ListTile(
                            leading: Image(image: NetworkImage(data?["Image"])),
                            title: Text(
                              data?["Medicine Name"],
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text(
                                "Pharmacy: ${data?["Pharmacy Name"]} Status: ${data?["Status"]}"),
                            trailing: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(
                                            20)), // Rounded corners
                                  ),
                                  backgroundColor: Colors
                                      .white, // Background color for the bottom sheet
                                  builder: (_) {
                                    _selectedStatus = data?["Status"];
                                    return Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          MaterialButton(
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection("Medicines")
                                                  .doc(data?["user_id"]
                                                      .toString())
                                                  .delete()
                                                  .then((_) {
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Text("Delete Medicine"),
                                            color: Colors.blue,
                                            textColor: Colors.white,
                                            minWidth: double.infinity,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            padding: EdgeInsets.all(15),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              showModalBottomSheet(
                                                context: context,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              20)), // Rounded corners
                                                ),
                                                backgroundColor: Colors.white,
                                                builder: (context) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .all(
                                                        16.0), // Padding around the content
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize
                                                          .min, // Adjust size to content
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Edit Status",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                20), // Space between title and dropdown
                                                        Consumer<
                                                            MedicineStockStatus>(
                                                          builder: (context,
                                                              value, child) {
                                                            value.fetchStatus(
                                                                data?[
                                                                    "user_id"]);
                                                            return DropdownButton<
                                                                String>(
                                                              value: value
                                                                      .status
                                                                      .isNotEmpty
                                                                  ? value.status
                                                                  : "",
                                                              isExpanded:
                                                                  true, // Makes the dropdown button expand to fill the width
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black), // Text color
                                                              dropdownColor: Colors
                                                                  .white, // Background color of dropdown
                                                              items: const [
                                                                DropdownMenuItem(
                                                                  value:
                                                                      "In Stock",
                                                                  child: Text(
                                                                      "In Stock"),
                                                                ),
                                                                DropdownMenuItem(
                                                                  value:
                                                                      "Out of Stock",
                                                                  child: Text(
                                                                      "Out of Stock"),
                                                                ),
                                                                DropdownMenuItem(
                                                                  value:
                                                                      "Discontinued",
                                                                  child: Text(
                                                                      "Discontinued"),
                                                                ),
                                                              ],
                                                              onChanged: (val) {
                                                                if (val !=
                                                                    null) {
                                                                  print(data![
                                                                          "user_id"]
                                                                      .toString());
                                                                  value.updateStatus(
                                                                      data["user_id"]
                                                                          .toString(),
                                                                      val);
                                                                }
                                                              },
                                                            );
                                                          },
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                20), // Space after dropdown
                                                        ElevatedButton(
                                                          onPressed: () {},
                                                          child: Text("Submit"),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor: Colors
                                                                .blue, // Button color
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        30,
                                                                    vertical:
                                                                        15), // Padding on the button
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10), // Rounded corners for button
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Text("Edit Status"),
                                            color: Colors.blue,
                                            textColor: Colors.white,
                                            minWidth: double.infinity,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            padding: EdgeInsets.all(15),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                "See Options",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
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
