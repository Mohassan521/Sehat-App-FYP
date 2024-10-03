import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sehat_app/screens/doctorScreens/doctorProfile.dart';
import 'package:sehat_app/widgets/doctorCategories.dart';
import 'package:sehat_app/widgets/doctorDrawer.dart';

class DoctorHomePage extends StatefulWidget {
  final String? full_name;
  const DoctorHomePage({super.key, this.full_name});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {

  // https://asset-cdn.lottiefiles
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DoctorDrawer(),
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
                      "Your Appointments",
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
                height: MediaQuery.sizeOf(context).height * 0.3,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
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
                                child: Image.asset(
                                  "assets/images/doctor1.jpg",
                                  height: 100,
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
                                Text("4.9", style: TextStyle(fontWeight: FontWeight.bold),)
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Dr. Hassan",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("Therapist, 7 y.e")
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorProfileScreen()));
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.deepPurple.shade100,
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(
                                    "assets/images/doctor1.jpg",
                                    height: 100,
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
                                  Text("4.9", style: TextStyle(fontWeight: FontWeight.bold),)
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Dr. Hannan",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text("General Physician, 4 y.e")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
