import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sehat_app/Utils/Utils.dart';
import 'package:sehat_app/screens/adminScreens/adminHomePage.dart';
import 'package:sehat_app/screens/doctorScreens/doctorHomePage.dart';
import 'package:sehat_app/screens/userHomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void route() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('registeredUsers')
          .doc(user.uid)
          .get();

      if (documentSnapshot.exists){
        String role = documentSnapshot.get('role');
        String fullName = documentSnapshot.get("display_name");

        if (role == "Admin") {
          SharedPreferences sp = await SharedPreferences.getInstance();
          sp.setString("role", role);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminHomePage()),
          );
        } else if (role == "Patient") {
          SharedPreferences sp = await SharedPreferences.getInstance();
          sp.setString("role", role);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  UserHomePage(full_name: fullName,)),
          );
        } else if (role == "Doctor") {
          SharedPreferences sp = await SharedPreferences.getInstance();
          sp.setString("role", role);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  DoctorHomePage(full_name: fullName,)),
          );
        } else {
          Utils().toastMessage('Invalid user role', Colors.red, Colors.white);
          print('Unexpected role found in the database.');
        }
      } else {
        Utils().toastMessage('No user data found. Please contact support.', Colors.orange, Colors.white);
        print('Document does not exist on the database.');
      }
    } else {
      Utils().toastMessage('User not authenticated.',Colors.orange, Colors.white);
    }
  } catch (e) {
    Utils().toastMessage('An error occurred while routing: $e',Colors.red, Colors.white);
    print('Error in routing: $e');
  }
}

void signIn(String email, String password) async {
  try {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.purple,
            backgroundColor: Colors.white,
          ),
        );
      },
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    Navigator.pop(context); // Close the loading dialog
    route();
  } on FirebaseAuthException catch (e) {
    Navigator.pop(context); // Close the loading dialog

    if (e.code == 'user-not-found') {
      Utils().toastMessage('No account found with this email.',Colors.orange, Colors.white);
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      Utils().toastMessage('Incorrect password. Please try again.',Colors.red, Colors.white);
      print('Wrong password provided for that user.');
    } else if (e.code == 'network-request-failed') {
      Utils().toastMessage('Network error. Please check your connection.',Colors.red, Colors.white);
      print('Network request failed.');
    } else if (e.code == 'user-disabled') {
      Utils().toastMessage('Your account has been disabled. Contact support.',Colors.red, Colors.white);
      print('User account is disabled.');
    } else {
      Utils().toastMessage('Error: ${e.message}',Colors.red, Colors.white);
      print('FirebaseAuth error: ${e.message}');
    }
  } catch (e) {
    Navigator.pop(context); // Close the loading dialog
    Utils().toastMessage('An unexpected error occurred: $e',Colors.red, Colors.white);
    print('Unexpected error: $e');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Login Yourself",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              // SizedBox(height: 10),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Enter Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Enter Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          MaterialButton(
            onPressed: () {
              signIn(emailController.text, passwordController.text);

              // generateLoginOTP();
            },
            child: Text(
              "Login" ,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            minWidth: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 11),
            textColor: Colors.white,
            color: Colors.deepPurple.shade300,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ],
      ),
    );
  }
}
