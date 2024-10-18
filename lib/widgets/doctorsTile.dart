import 'package:flutter/material.dart';
import 'package:sehat_app/screens/doctorScreens/doctorProfile.dart';

class DoctorsTile extends StatelessWidget {
  final String image;
  final String name;
  final String role;
  final String location;
  final Function()? onTap;
  final String tag;
  const DoctorsTile({super.key, required this.image, required this.name, required this.role, required this.location, this.onTap, required this.tag});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
                  height: MediaQuery.sizeOf(context).height * 0.3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple.shade100,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Hero(
                                tag: tag,
                                child: Image.asset(
                                  image,
                                  height: 100,
                                ),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow.shade600,
                              ),
                              Text("4.6", style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Dr. $name",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(role),
                          SizedBox(
                            height: 5,
                          ),
                          Text(location),
                        ],
                      ),
                    ),
                  ),
                ),
    );

  }
}