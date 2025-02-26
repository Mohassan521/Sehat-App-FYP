import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MedicineStockStatus extends ChangeNotifier {
  String _status = ""; // Status variable to hold the current status
  // Constructor

  String get status => _status; // Getter for status

  // Fetch the initial status from Firestore
  Future<void> fetchStatus(int uid) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('Medicines') // Your collection name
        .doc(uid.toString())
        .get();
    _status =
        doc['Status'] ?? "Unknown"; // Default to "Unknown" if no status found
    notifyListeners(); // Notify listeners for the change
  }

  // Update the status in the Firestore and notify listeners
  Future<void> updateStatus(String uid, String newStatus) async {
    _status = newStatus; // Update local status
    await FirebaseFirestore.instance
        .collection('Medicines')
        .doc(uid)
        .update({'Status': newStatus}); // Update Firestore

    print("uid coming from provider $uid");

    notifyListeners(); // Notify listeners about the change
  }
}

class StatusValueProvider extends ChangeNotifier {
  String _selectedValue = "Order Pending";

  String get selectedValue => _selectedValue;

  void updateValue(String newStatus) {
    _selectedValue = newStatus;
    notifyListeners();
  }

  Future<void> updateOrderStatus(String orderId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('Orders') // Replace with your collection name
          .doc(orderId) // Use the document ID
          .update({
        'Status': _selectedValue, // Update the status field
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status updated successfully!')),
      );
      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }
}

class AppointmentStatusValueProvider extends ChangeNotifier {
  String _selectedValue = "Pending";

  String get selectedValue => _selectedValue;

  void updateValue(String newStatus) {
    _selectedValue = newStatus;
    notifyListeners();
  }

  Future<void> updateOrderStatus(String orderId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('Appointments') // Replace with your collection name
          .doc(orderId) // Use the document ID
          .update({
        'Appointment Status': _selectedValue, // Update the status field
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status updated successfully!')),
      );
      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }
}

class AppointmentDateProvider extends ChangeNotifier {
  DateTime? _selectedDate;

  DateTime? get selectedDate => _selectedDate;

  void updateDate(DateTime newValue) {
    _selectedDate = newValue;
    notifyListeners();
  }
}

class PasswordHide extends ChangeNotifier {
  bool _ishidden = true;

  bool get isHidden => _ishidden;

  void update() {
    _ishidden = !_ishidden;
    notifyListeners();
  }
}
