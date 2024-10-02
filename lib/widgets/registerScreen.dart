import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sehat_app/Provider/provider.dart';
import 'package:sehat_app/Utils/Utils.dart';
import 'package:sehat_app/screens/frontPage.dart';
// import 'package:pashusevak/widgets/loginScreen.dart';
// import 'package:simple_icons/simple_icons.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController fullName = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController passworController = TextEditingController();

  bool passwordVisibility = false;
  var role = "Patient";

  final _auth = FirebaseAuth.instance;

  

  @override
  Widget build(BuildContext context) {
    final userIdProvider = Provider.of<UserIdProvider>(context);

    postDetailsToFirestore(String email, String role, String display_name) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref =
        FirebaseFirestore.instance.collection('registeredUsers');
    ref.doc(user!.uid).set({
      'user_id' : user.uid,
      'email': _emailController.text,
      'role': role,
      'display_name': display_name
    });
    Utils().toastMessage("User Registered Successfully", Colors.green, Colors.white);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => FrontPage()));
    
  }
   
    void signUp(String email, String password, String role, String displayName) async {
    CircularProgressIndicator();
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => {
          postDetailsToFirestore(email, role, displayName),
          
        }
        )
        .catchError((e) {
      print(e.toString());
    });
  }

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  "Patient Registration",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                // SizedBox(height: 10),
                // Text(
                //   Localization.of(context)!
                //         .translate('message')!,
                //   style: TextStyle(fontSize: 16),
                // ),
                SizedBox(height: 25),
                TextFormField(
                  controller: fullName,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 17.5),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 17.5),
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 17.5),
                TextFormField(
                  controller: passworController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                // SizedBox(
                //   height: 15,
                // ),
        
                // ElevatedButton(
                //   onPressed: () {},
                //   style: ElevatedButton.styleFrom(
                //     // primary: Colors.orange,
                //     minimumSize: Size(double.infinity, 50), // Full-width button
                //   ),
                //   child: Text('Log In'),
                // ),
              ],
            ),
            SizedBox(
              height: 28,
            ),
            MaterialButton(
              
              onPressed: () {
                // registerUser();
                signUp(_emailController.text, passworController.text, role, fullName.text);
              },
              child: Text("Register",style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),),
              minWidth: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 11),
            textColor: Colors.black,
            color: Color(0xfff89255),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ],
        ),
      ),
    );
  }
}
