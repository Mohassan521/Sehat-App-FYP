import 'package:flutter/material.dart';
import 'package:sehat_app/screens/medicineDetails.dart';
import 'package:sehat_app/services/database_service.dart';

class MedicineCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String image;
  final String title;
  final String description;
  final String prescription;
  final String manufacturer;
  final String category;
  final String pharmacy;
  const MedicineCard({super.key, required this.image, required this.title, required this.description, required this.prescription, required this.manufacturer, required this.category, required this.pharmacy, required this.data});

  @override
  Widget build(BuildContext context) {

    return InkWell(
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MedicineDetails(medDetails: data)));
        },
        child: Card(
            elevation: 2.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: EdgeInsets.all(14.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: image,
                  child: Stack(
                    children: [
                      Image.network(
                        image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 180.0,
                      ),
                      Positioned(
                        top: 16.0,
                        right: 16.0,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 4.0, horizontal: 25.0),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        '• Prescription Required: $prescription\n'
                        '• Manufacturer: $manufacturer\n'
                        '• Category: $category\n'
                        '• Available in: $pharmacy',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Handle PDF view tap
                            },
                            child: Text(
                              'More Details   >  ',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
    );

  }
}