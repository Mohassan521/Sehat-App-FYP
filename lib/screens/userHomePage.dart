import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sehat_app/Provider/provider.dart';
import 'package:sehat_app/screens/doctorScreens/doctorProfile.dart';
import 'package:sehat_app/widgets/doctorCategories.dart';
import 'package:sehat_app/widgets/doctorsTile.dart';
import 'package:sehat_app/widgets/drawer.dart';

class UserHomePage extends StatefulWidget {
  final String? full_name;
  const UserHomePage({super.key, this.full_name});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {

  // https://asset-cdn.lottiefiles
  @override
  Widget build(BuildContext context) {
    print("getting full name in patient home page: ${widget.full_name}");
    return Scaffold(
      drawer: MyDrawer(full_name: widget.full_name!,),
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Column(
            children: [
              // appbar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hello,",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          "Random User",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.deepPurple.shade100,
                            borderRadius: BorderRadius.circular(12)),
                        child: Icon(Icons.person)),
                  ],
                ),
              ),
        
              SizedBox(
                height: 20,
              ),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.pink.shade100,
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      // animation or image
        
                      Container(
                        height: 100,
                        width: 100,
                        child: LottieBuilder.network("https://lottie.host/4dfc91ff-dd16-4617-803f-85cb4e4f0c7f/ceb4eLE4ap.json")
                      ),
        
                      SizedBox(
                        width: 20,
                      ),
        
                      // text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "How do you feel?",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Fill out your Medical Card Right Now",
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                  child: Text(
                                "Get Started",
                                style: TextStyle(color: Colors.white),
                              )),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        
              // search area
        
              SizedBox(
                height: 25,
              ),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "How can we help you?",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search)),
                  ),
                ),
              ),
        
              SizedBox(
                height: 25,
              ),
        
              // Container(
              //   height: MediaQuery.sizeOf(context).height * 0.08,
              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     children: [
        
              //       DoctorCategories(),
              //       DoctorCategories(),
              //     ],
              //   ),
              // )
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Doctors List",
                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "See All",
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                    )
                  ],
                ),
              ),
        
              SizedBox(
                height: 25,
              ),
        
              Container(
                height: MediaQuery.sizeOf(context).height * 0.35,
                child: StreamBuilder(stream: FirebaseFirestore.instance.collection("registeredUsers").where("role", isEqualTo: "Doctor").snapshots(), builder: (context, snapshot){

                  if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Data is being loaded..."));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No doctors found.'));
          }

          List<Widget> doctorTiles = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() ;
            String name = data['display_name'];
            String role = data['Speciality'] ;
            String location = data['Location'];
             // Assuming 'speciality' exists in your Firestore
            String imageUrl = "assets/images/doctor1.jpg"; // Static image, you can modify this to fetch from Firestore if available

            print("Doctor data object: ${data['display_name']}");

            return DoctorsTile(image: imageUrl, name: name, role: role, location: location,onTap: () {
              
              Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorProfileScreen(
                docData: data,
                full_name: widget.full_name!,
              )));
            },);
          }).toList();

          return ListView(
            scrollDirection: Axis.horizontal,
            children: doctorTiles,
          );
                }),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
