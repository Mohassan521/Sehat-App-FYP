import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sehat_app/Utils/Utils.dart';
import 'package:sehat_app/services/media_service.dart';
import 'package:sehat_app/services/storage_service.dart';
import 'package:sehat_app/widgets/completed.dart';

class AddMedicines extends StatefulWidget {
  const AddMedicines({super.key});

  @override
  State<AddMedicines> createState() => _AddMedicinesState();
}

class _AddMedicinesState extends State<AddMedicines> {
  final TextEditingController medName = TextEditingController();
  final TextEditingController strength = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController manufacturer = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController price = TextEditingController();
  String medicine_category = "";
  String dosageForm = "";
  bool isChecked = false;
  String? downloadURL;
  File? file;

  final GetIt _getIt = GetIt.instance;
  late MediaService _mediaService;
  late StorageService _storageService;
  // final _auth = FirebaseAuth.instance;

  postDetailsToFirestore(
      String medName,
      String category,
      String strength,
      String description,
      String dosage,
      String manufacturer,
      String location,
      int price,
      String presRequired,
      String imagePath) async {
    // var user = _auth.currentUser;
    CollectionReference ref =
        FirebaseFirestore.instance.collection('Medicines');

    String orderId = (100 + Random().nextInt(900)).toString();

    ref.doc(orderId).set({
      'user_id': orderId,
      "Medicine Name": medName,
      "Medicine Category": category,
      "Description": description,
      "Dosage Form": dosage,
      "Manufacturer": manufacturer,
      "Pharmacy Name": location,
      "Price (per strip)": price,
      "Prescription Required": presRequired,
      "Image": imagePath
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CompletedAnyTask(
                path: "'assets/images/done.json'",
                message: "Medicine Added Succesfully")));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _storageService = _getIt.get<StorageService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Add Medicines",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Medicine Name"),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: medName,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Medicine Category"),
              SizedBox(
                height: 5,
              ),
              Container(
                height: MediaQuery.sizeOf(context).height * 0.055,
                padding: EdgeInsets.only(left: 9),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.5),
                  // color: Colors.white,

                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: DropdownButton<String>(
                  alignment: Alignment.center,
                  isExpanded: true,
                  underline: SizedBox(),
                  value: medicine_category,
                  onChanged: (String? newValue) {
                    setState(() {
                      medicine_category = newValue ?? medicine_category;
                    });
                  },
                  items: [
                    DropdownMenuItem<String>(
                        value: '',
                        child: Center(
                            child: Text(
                          '',
                          style: TextStyle(fontSize: 12),
                        ))),
                    DropdownMenuItem<String>(
                        value: 'Antibiotics',
                        child: Center(
                            child: Text(
                          'Antibiotics',
                          style: TextStyle(fontSize: 12),
                        ))),
                    DropdownMenuItem<String>(
                        value: 'Painkillers',
                        child: Center(
                            child: Text('Painkillers',
                                style: TextStyle(fontSize: 12)))),
                    DropdownMenuItem<String>(
                        value: 'Antipyretics',
                        child: Center(
                            child: Text('Antipyretics',
                                style: TextStyle(fontSize: 12)))),
                    DropdownMenuItem<String>(
                        value: 'Antiseptics',
                        child: Center(
                            child: Text('Antiseptics',
                                style: TextStyle(fontSize: 12)))),
                    DropdownMenuItem<String>(
                        value: 'Antihistamines',
                        child: Center(
                            child: Text('Antihistamines',
                                style: TextStyle(fontSize: 12)))),
                    DropdownMenuItem<String>(
                        value: 'Antacids',
                        child: Center(
                            child: Text('Antacids',
                                style: TextStyle(fontSize: 12)))),
                    DropdownMenuItem<String>(
                        value: 'Antidepressants',
                        child: Center(
                            child: Text('Antidepressants',
                                style: TextStyle(fontSize: 12)))),
                    DropdownMenuItem<String>(
                        value: 'Anti-inflammatory drugs',
                        child: Center(
                            child: Text('Anti-inflammatory drugs',
                                style: TextStyle(fontSize: 12)))),
                    DropdownMenuItem<String>(
                        value: 'Antidiarrheals',
                        child: Center(
                            child: Text('Antidiarrheals',
                                style: TextStyle(fontSize: 12)))),
                    DropdownMenuItem<String>(
                        value: 'Antifungals',
                        child: Center(
                            child: Text('Antifungals',
                                style: TextStyle(fontSize: 12)))),
                    DropdownMenuItem<String>(
                        value: 'Antivirals',
                        child: Center(
                            child: Text('Antivirals',
                                style: TextStyle(fontSize: 12)))),
                    DropdownMenuItem<String>(
                        value: 'Cough Suppressants and Expectorants',
                        child: Center(
                            child: Text('Cough Suppressants and Expectorants',
                                style: TextStyle(fontSize: 12)))),
                    DropdownMenuItem<String>(
                        value: 'Insulins',
                        child: Center(
                            child: Text('Insulins',
                                style: TextStyle(fontSize: 12)))),
                    DropdownMenuItem<String>(
                        value: 'Vaccines',
                        child: Center(
                            child: Text('Vaccines',
                                style: TextStyle(fontSize: 12)))),
                    DropdownMenuItem<String>(
                        value: 'Sedatives and Hypnotics (for sleep)',
                        child: Center(
                            child: Text('Sedatives and Hypnotics (for sleep)',
                                style: TextStyle(fontSize: 12)))),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Strength / Concentration"),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: strength,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Description (Purpose of medicine)"),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                maxLines: 6,
                controller: description,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Dosage Form"),
              SizedBox(
                height: 5,
              ),
              Container(
                height: MediaQuery.sizeOf(context).height * 0.055,
                padding: EdgeInsets.only(left: 9),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.5),
                  // color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: DropdownButton<String>(
                  alignment: Alignment.center,
                  isExpanded: true,
                  value: dosageForm,
                  underline: SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dosageForm = newValue ?? dosageForm;
                    });
                  },
                  items: [
                    DropdownMenuItem<String>(
                        value: '',
                        child: Center(
                            child: Text(
                          '',
                          style: TextStyle(fontSize: 12),
                        ))),
                    DropdownMenuItem<String>(
                        value: 'Tablet',
                        child: Center(
                            child: Text(
                          'Tablet',
                          style: TextStyle(fontSize: 12),
                        ))),
                    DropdownMenuItem<String>(
                        value: 'Syrup',
                        child: Center(
                            child:
                                Text('Syrup', style: TextStyle(fontSize: 12)))),
                    DropdownMenuItem<String>(
                        value: 'Injection',
                        child: Center(
                            child: Text('Injection',
                                style: TextStyle(fontSize: 12)))),
                    DropdownMenuItem<String>(
                        value: 'Capsule',
                        child: Center(
                            child: Text('Capsule',
                                style: TextStyle(fontSize: 12)))),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Manufacturer"),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: manufacturer,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Location (mention pharmacy name)"),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: location,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Price per strip"),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: price,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Prescription Required"),
                  Checkbox(
                    // tristate: true,
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text("Upload Image"),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    onPressed: () async {
                      file = await _mediaService.getImageFromGallery();
                    },
                    child: Text("Browse"),
                    color: Colors.purple,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  Text(file != null ? "Image uploaded" : "")
                ],
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                onPressed: () async {
                  if (file != null &&
                      medName.text.isNotEmpty &&
                      medicine_category.isNotEmpty &&
                      strength.text.isNotEmpty &&
                      description.text.isNotEmpty &&
                      dosageForm.isNotEmpty &&
                      manufacturer.text.isNotEmpty &&
                      location.text.isNotEmpty &&
                      price.text.isNotEmpty) {
                    downloadURL = await _storageService.uploadMedicineImages(
                      file: file!,
                    );
                    postDetailsToFirestore(
                        medName.text,
                        medicine_category,
                        strength.text,
                        description.text,
                        dosageForm,
                        manufacturer.text,
                        location.text,
                        int.parse(price.text),
                        isChecked == true ? "Yes" : "No",
                        downloadURL!);
                  } else {
                    Utils().toastMessage("Please enter data in all fields",
                        Colors.red, Colors.white);
                  }

                  print(downloadURL);
                },
                child: Text("Submit"),
                color: Colors.purple,
                textColor: Colors.white,
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
