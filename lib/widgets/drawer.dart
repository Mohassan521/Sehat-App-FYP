import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sehat_app/screens/adminScreens/adminHomePage.dart';
import 'package:sehat_app/screens/doctorScreens/chatsScreen.dart';
import 'package:sehat_app/screens/doctorScreens/doctorHomePage.dart';
import 'package:sehat_app/screens/frontPage.dart';
import 'package:sehat_app/screens/medicines_inventory.dart';
import 'package:sehat_app/screens/orders.dart';
import 'package:sehat_app/screens/patientChats.dart';
import 'package:sehat_app/screens/profile.dart';
import 'package:sehat_app/screens/userHomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  final String full_name;
  const MyDrawer({super.key, required this.full_name});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String role = "";
  String id = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    preferences();
  }

  void preferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      id = sp.getString("id") ?? "";
      role = sp.getString("role") ?? "";
    });
  }

  void logout() async {
    FirebaseAuth.instance.signOut();
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear().then((v) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FrontPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    print(role);

    return SafeArea(
      child: Drawer(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25.0,
            vertical: 25,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        maxRadius: 45,
                        backgroundColor: Colors.grey,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        widget.full_name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: role == "Patient" ? 28 : 24,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => role == "Patient"
                                  ? UserHomePage(
                                      full_name: widget.full_name,
                                    )
                                  : role == "Doctor"
                                      ? DoctorHomePage(
                                          full_name: widget.full_name,
                                          uid: id,
                                        )
                                      : AdminHomePage(
                                          full_name: widget.full_name)));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.home,
                          color: Colors.black,
                          size: 24,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Home",
                          style: TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: role == "Doctor" ? 20 : 0,
                  ),
                  Visibility(
                    visible: role == "Doctor" ? true : false,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrdersScreen(
                                      full_name: widget.full_name,
                                    )));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.production_quantity_limits,
                            color: Colors.black,
                            size: 24,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Completed Appointments",
                            style: TextStyle(
                              fontSize: 17.5,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: role == "Patient" ? true : false,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrdersScreen(
                                      full_name: widget.full_name,
                                    )));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.production_quantity_limits,
                            color: Colors.black,
                            size: 24,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Orders",
                            style: TextStyle(
                              fontSize: 17.5,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: role == "Patient" ? 20 : 0,
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(sid: sid)));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                    full_name: widget.full_name,
                                  )));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 24,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Profile",
                          style: TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: role == "Patient"
                        ? 20
                        : role == "Doctor"
                            ? 20
                            : 0,
                  ),
                  Visibility(
                    visible: role == "Patient"
                        ? true
                        : role == "Doctor"
                            ? true
                            : false,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => role == "Patient"
                                    ? PatientChats(
                                        fullName: widget.full_name,
                                      )
                                    : role == "Doctor"
                                        ? ChatsScreen(
                                            fullName: widget.full_name)
                                        : Container()));
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.chat,
                            color: Colors.black,
                            size: 24,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Chats",
                            style: TextStyle(
                              fontSize: 17.5,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => WalletScreen(
                  //                     sid: sid,
                  //                   )));
                  //   },
                  //   child: Row(
                  //     children: [
                  //       Icon(
                  //         Icons.wallet,
                  //         color: Colors.black,
                  //         size: 24,
                  //       ),
                  //       SizedBox(
                  //         width: 10,
                  //       ),
                  //       Text(
                  //         Localization.of(context)!.translate('wallet')!,
                  //         style: TextStyle(
                  //           fontSize: 17.5,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => PharmacyForDoctors(

                  //                   )));
                  //   },
                  //   child: Row(
                  //     children: [
                  //       Icon(
                  //         Icons.inventory,
                  //         color: Colors.black,
                  //         size: 24,
                  //       ),
                  //       SizedBox(
                  //         width: 10,
                  //       ),
                  //       Text(
                  //         Localization.of(context)!.translate('inventory')!,
                  //         style: TextStyle(
                  //           fontSize: 17.5,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => EBookForDoctors(

                  //                   )));
                  //   },
                  //   child: Row(
                  //     children: [
                  //       Icon(
                  //         Icons.book,
                  //         color: Colors.black,
                  //         size: 24,
                  //       ),
                  //       SizedBox(
                  //         width: 10,
                  //       ),
                  //       Text(
                  //         Localization.of(context)!.translate('book')!,
                  //         style: TextStyle(
                  //           fontSize: 17.5,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     // Navigator.push(
                  //     //       context,
                  //     //       MaterialPageRoute(
                  //     //           builder: (context) => WalletScreen(
                  //     //                 sid: sid,
                  //     //               )));
                  //   },
                  //   child: Row(
                  //     children: [
                  //       Icon(
                  //         Icons.share,
                  //         color: Colors.black,
                  //         size: 24,
                  //       ),
                  //       SizedBox(
                  //         width: 10,
                  //       ),
                  //       Text(
                  //         Localization.of(context)!.translate('share')!,
                  //         style: TextStyle(
                  //           fontSize: 17.5,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => ChatForDoctors(

                  //                   )));
                  //   },
                  //   child: Row(
                  //     children: [
                  //       Icon(
                  //         Icons.chat,
                  //         color: Colors.black,
                  //         size: 24,
                  //       ),
                  //       SizedBox(
                  //         width: 10,
                  //       ),
                  //       Text(
                  //         Localization.of(context)!.translate('chat')!,
                  //         style: TextStyle(
                  //           fontSize: 17.5,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     // Navigator.push(
                  //     //       context,
                  //     //       MaterialPageRoute(
                  //     //           builder: (context) => WalletScreen(
                  //     //                 sid: sid,
                  //     //               )));
                  //   },
                  //   child: Row(
                  //     children: [
                  //       Icon(
                  //         Icons.location_searching,
                  //         color: Colors.black,
                  //         size: 24,
                  //       ),
                  //       SizedBox(
                  //         width: 10,
                  //       ),
                  //       Text(
                  //         Localization.of(context)!.translate('location-control')!,
                  //         style: TextStyle(
                  //           fontSize: 17.5,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => SalesForDoctors(

                  //                   )));
                  //   },
                  //   child: Row(
                  //     children: [
                  //       Icon(
                  //         Icons.shop_two,
                  //         color: Colors.black,
                  //         size: 24,
                  //       ),
                  //       SizedBox(
                  //         width: 10,
                  //       ),
                  //       Text(
                  //         Localization.of(context)!.translate('sales')!,
                  //         style: TextStyle(
                  //           fontSize: 17.5,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: role == "Patient" ? 20 : 0,
                  ),
                  Visibility(
                    visible: role == "Patient" ? true : false,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MedicineInventory(
                                      full_name: widget.full_name,
                                    )));
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.medication,
                            color: Colors.black,
                            size: 24,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Medicines Inventory",
                            style: TextStyle(
                              fontSize: 17.5,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      // NetworkApiServices().logout();
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (context) => FrontPage()));
                      logout();
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.black,
                          size: 24,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
