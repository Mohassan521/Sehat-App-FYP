import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sehat_app/widgets/completed.dart';

class AddAdmin extends StatefulWidget {
  final String name;
  const AddAdmin({super.key, required this.name});

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  TextEditingController name = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  var role = "Admin";
  bool isLoading = false;

  final _auth = FirebaseAuth.instance;

  postDetailsToFirestore(String email, String role, String display_name,
      String contact, String address) async {
    var user = _auth.currentUser;

    CollectionReference ref =
        FirebaseFirestore.instance.collection('registeredUsers');
    ref.doc(user!.uid).set({
      'user_id': user.uid,
      'email': emailController.text,
      'role': role,
      'display_name': display_name,
      'contact': contact,
      'parmanent_address': address
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CompletedAnyTask(
                name: widget.name,
                path: 'assets/images/done.json',
                message: "Admin Added Succesfully")));
  }

  void signUp(String email, String password, String role, String displayName,
      String address, String contact) async {
    setState(() {
      isLoading = true; // Show loader
    });

    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((_) async {
        await postDetailsToFirestore(
            email, role, displayName, contact, address);
      });

      setState(() {
        isLoading = false; // Hide loader when done
      });

      // Show success message or navigate to another screen
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Signup successful!")));
    } catch (e) {
      setState(() {
        isLoading = false; // Hide loader on error
      });

      // Show error message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              "Add Doctor",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.purple,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Full Name"),
                  SizedBox(height: 5),
                  TextFormField(
                      controller: name,
                      decoration:
                          InputDecoration(border: OutlineInputBorder())),
                  SizedBox(height: 10),
                  Text("Email"),
                  SizedBox(height: 5),
                  TextFormField(
                      controller: emailController,
                      decoration:
                          InputDecoration(border: OutlineInputBorder())),
                  SizedBox(height: 10),
                  Text("Contact Number"),
                  SizedBox(height: 5),
                  TextFormField(
                      controller: contact,
                      decoration:
                          InputDecoration(border: OutlineInputBorder())),
                  SizedBox(height: 10),
                  Text("Address"),
                  SizedBox(height: 5),
                  TextFormField(
                      controller: addressController,
                      decoration:
                          InputDecoration(border: OutlineInputBorder())),
                  SizedBox(height: 10),
                  Text("Password"),
                  SizedBox(height: 5),
                  TextFormField(
                      controller: passwordController,
                      decoration:
                          InputDecoration(border: OutlineInputBorder())),
                  SizedBox(height: 20),
                  MaterialButton(
                    onPressed: isLoading
                        ? null // Disable button while loading
                        : () {
                            signUp(
                                emailController.text,
                                passwordController.text,
                                role,
                                name.text,
                                addressController.text,
                                contact.text);
                          },
                    child: isLoading
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                              SizedBox(width: 10),
                              Text("Processing..."),
                            ],
                          )
                        : Text("Submit"),
                    minWidth: double.infinity,
                    height: 50,
                    color: isLoading ? Colors.grey : Colors.purple,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        if (isLoading) // Show full-screen loader
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }
}
