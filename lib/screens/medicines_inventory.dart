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
                          value: 'Agha Khan Hospital',
                          child: Center(child: Text('Agha Khan Hospital'))),
                      DropdownMenuItem<String>(
                          value: 'Liaquat National Hospital',
                          child:
                              Center(child: Text('Liaquat National Hospital'))),
                      DropdownMenuItem<String>(
                          value: 'South City Hospital',
                          child: Center(child: Text('South City Hospital'))),
                      DropdownMenuItem<String>(
                          value: 'Darul Sehat Hospital',
                          child: Center(child: Text('Darul Sehat Hospital'))),
                      DropdownMenuItem<String>(
                          value: 'CFH Pharmacy',
                          child: Center(child: Text('CFH Pharmacy'))),
                      DropdownMenuItem<String>(
                          value: 'Dvago', child: Center(child: Text('Dvago'))),
                      DropdownMenuItem<String>(
                          value: 'Servaid',
                          child: Center(child: Text('Servaid'))),
                      DropdownMenuItem<String>(
                          value: 'Time Medical Center',
                          child: Center(child: Text('Time Medical Center'))),
                      DropdownMenuItem<String>(
                          value: 'RIMS Trauma Hospital',
                          child: Center(child: Text('RIMS Trauma Hospital'))),
                      DropdownMenuItem<String>(
                          value: 'The Modern Hospital',
                          child: Center(child: Text('The Modern Hospital'))),
                      DropdownMenuItem<String>(
                          value: 'Mehmood Memorial Hospital',
                          child:
                              Center(child: Text('Mehmood Memorial Hospital'))),
                      DropdownMenuItem<String>(
                          value: 'Dr.Ziauddin Hospital Pharmacy',
                          child: Center(
                              child: Text('Dr.Ziauddin Hospital Pharmacy'))),
                      DropdownMenuItem<String>(
                          value: 'PAF Hospital Pharmacy',
                          child: Center(child: Text('PAF Hospital Pharmacy'))),
                      DropdownMenuItem<String>(
                          value: 'Patel Hospital Pharmacy',
                          child:
                              Center(child: Text('Patel Hospital Pharmacy'))),
                      DropdownMenuItem<String>(
                          value: 'National Medical Center',
                          child:
                              Center(child: Text('National Medical Center'))),
                      DropdownMenuItem<String>(
                          value: 'HOPES Pharmacy',
                          child: Center(child: Text('HOPES Pharmacy'))),
                      DropdownMenuItem<String>(
                          value: 'Park Lane Hospital Pharmacy',
                          child: Center(
                              child: Text('Park Lane Hospital Pharmacy'))),
                      DropdownMenuItem<String>(
                          value: 'NIBD Pharmacy',
                          child: Center(child: Text('NIBD Pharmacy'))),
                      DropdownMenuItem<String>(
                          value: 'Dr.Essa Pharmacy',
                          child: Center(child: Text('Dr.Essa Pharmacy'))),
                      DropdownMenuItem<String>(
                          value: 'Abbasi Shaheed Pharmacy',
                          child:
                              Center(child: Text('Abbasi Shaheed Pharmacy'))),
                      DropdownMenuItem<String>(
                          value: 'Mumtaz Medicos',
                          child: Center(child: Text('Mumtaz Medicos'))),
                      DropdownMenuItem<String>(
                          value: 'KKF Medical Store',
                          child: Center(child: Text('KKF Medical Store'))),
                      DropdownMenuItem<String>(
                          value: 'Usman Medical & General Store',
                          child: Center(
                              child: Text('Usman Medical & General Store'))),
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
