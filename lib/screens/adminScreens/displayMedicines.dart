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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.purple,
        title: const Text(
          "Medicines",
          style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 16.5, color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Medicines").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Medicines Added Yet",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }

          var docs = snapshot.data!.docs;
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                var data = docs[index].data();
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Medicine Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            data["Image"],
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 15),
                        // Medicine Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data["Medicine Name"],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Pharmacy: ${data["Pharmacy Name"]}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Status: ${data["Status"]}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: data["Status"] == "In Stock"
                                      ? Colors.green
                                      : data["Status"] == "Out of Stock"
                                          ? Colors.red
                                          : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Options Button
                        IconButton(
                          onPressed: () {
                            _showOptionsBottomSheet(context, data);
                          },
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showOptionsBottomSheet(
      BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Actions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                onTap: () {
                  FirebaseFirestore.instance
                      .collection("Medicines")
                      .doc(data["user_id"].toString())
                      .delete()
                      .then((_) {
                    Navigator.pop(context);
                  });
                },
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Delete Medicine"),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  _showEditStatusBottomSheet(context, data);
                },
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text("Edit Status"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditStatusBottomSheet(
      BuildContext context, Map<String, dynamic> data) {
    String selectedStatus = data["Status"];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Edit Status",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: InputDecoration(
                  labelText: "Select Status",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "In Stock",
                    child: Text("In Stock"),
                  ),
                  DropdownMenuItem(
                    value: "Out of Stock",
                    child: Text("Out of Stock"),
                  ),
                  DropdownMenuItem(
                    value: "Discontinued",
                    child: Text("Discontinued"),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedStatus = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Provider.of<MedicineStockStatus>(context, listen: false)
                      .updateStatus(data["user_id"].toString(), selectedStatus);
                  Navigator.pop(context);
                },
                child: const Text("Save Changes"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
