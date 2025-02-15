import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sehat_app/Provider/provider.dart';

class PatientOrderedItems extends StatefulWidget {
  final Map<String, dynamic> docs;
  // final String orderStatus;
  final String order_id;

  const PatientOrderedItems({
    super.key,
    required this.docs,
    required this.order_id,
  });

  @override
  State<PatientOrderedItems> createState() => _PatientOrderedItemsState();
}

class _PatientOrderedItemsState extends State<PatientOrderedItems> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("getting all this: ${widget.docs}");
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Products",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.docs['items'].length,
                  itemBuilder: (context, index) {
                    var item = widget.docs['items'][index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      title: Text(
                        "${item['product_name']} (x${item['quantity']})",
                        style: const TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        "Rs. ${item['unit_price']} / unit",
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              // const Text(
              //   "Order Status",
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.w600,
              //     color: Colors.black87,
              //   ),
              // ),
              // const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
