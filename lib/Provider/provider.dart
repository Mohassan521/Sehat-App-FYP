import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
