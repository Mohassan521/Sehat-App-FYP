import 'package:flutter/material.dart';

class UserIdProvider with ChangeNotifier {

}

class DoctorProvider with ChangeNotifier {
  Map<String, dynamic> _doctorDetail = {};

  Map<String, dynamic> get doctorDetail => _doctorDetail;

  void setDoctorDetail(Map<String, dynamic> doctorDetail) {
    _doctorDetail = doctorDetail;
    notifyListeners();  // Notify listeners when the data is updated
  }
}
