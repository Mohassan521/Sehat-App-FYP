import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sehat_app/widgets/drawer.dart';
import 'package:sehat_app/widgets/medicineCard.dart';

class MedicineInventory extends StatefulWidget {
  final String full_name;
  const MedicineInventory({super.key, required this.full_name});

  @override
  State<MedicineInventory> createState() => _MedicineInventoryState();
}

class _MedicineInventoryState extends State<MedicineInventory> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(full_name: widget.full_name),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "House of Medicines",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Filter By: "),
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.035,
                  padding: EdgeInsets.only(left: 9),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.5),
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 0.5)),
                  child: DropdownButton<String>(
                    alignment: Alignment.center,
                    isExpanded: false,
                    value: selectedValue,
                    underline: SizedBox(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue ?? selectedValue;
                      });
                    },
                    items: [
                      DropdownMenuItem<String>(
                          value: '',
                          child: Center(child: Text('show all medicines'))),
                      DropdownMenuItem<String>(
                          value: 'Aga Khan Hospital',
                          child: Center(child: Text('Aga Khan Hospital'))),
                      DropdownMenuItem<String>(
                          value: 'Liaquat National Hospital',
                          child:
                              Center(child: Text('Liaquat National Hospital'))),
                      DropdownMenuItem<String>(
                          value: 'South City Hospital',
                          child: Center(child: Text('South City Hospital'))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Medicines")
                  .snapshots(),
              builder: (context, snapshot) {
                // Handle loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                // Handle errors
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // Handle empty data
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text('No Medicines available right now.'));
                }

                final filteredData = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final pharmacyName = data["Pharmacy Name"] ?? "";

                  return selectedValue == null || selectedValue == ''
                      ? true // Show all medicines if no pharmacy is selected
                      : pharmacyName
                          .toLowerCase()
                          .contains(selectedValue!.toLowerCase());
                }).toList();

                if (filteredData.isEmpty) {
                  return const Center(
                      child: Text('No Medicines available for this pharmacy.'));
                }

                // Extract and map the Firestore data
                final medData = filteredData.map((doc) {
                  final data = doc.data();
                  return MedicineCard(
                    data: data,
                    image: data["Image"] ?? "", // Image URL
                    title: data["Status"] ?? "Unknown Medicine",
                    description:
                        data["Description"] ?? "No description available",
                    prescription: data["Prescription Required"] ?? "No",
                    manufacturer:
                        data["Manufacturer"] ?? "Unknown Manufacturer",
                    category: data["Medicine Category"] ?? "Uncategorized",
                    pharmacy: data["Pharmacy Name"] ?? "Unknown Pharmacy",
                  );
                }).toList();

                // Display the list of medicines
                return ListView(
                  children: medData,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
