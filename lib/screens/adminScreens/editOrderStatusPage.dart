import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sehat_app/Provider/provider.dart';

class EditOrderStatus extends StatefulWidget {
  final Map<String, dynamic> docs;
  final String orderStatus;
  final String order_id;

  const EditOrderStatus({
    super.key,
    required this.docs,
    required this.orderStatus,
    required this.order_id,
  });

  @override
  State<EditOrderStatus> createState() => _EditOrderStatusState();
}

class _EditOrderStatusState extends State<EditOrderStatus> {
  late String _selectedStatus;
  final List<String> orderStatuses = [
    'Order Pending',
    'Order Confirmed',
    'Order Shipped',
    'Order Delivered',
    'Order Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.orderStatus;
  }

  @override
  Widget build(BuildContext context) {
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
              const Text(
                "Order Status",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Consumer<StatusValueProvider>(
                builder: (context, value, child) {
                  return DropdownButtonFormField<String>(
                    value: widget.orderStatus,
                    items: orderStatuses.map((String status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(
                          status,
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      value.updateValue(newValue ?? "Order Pending");
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String order_id = widget.order_id;
                    await context
                        .read<StatusValueProvider>()
                        .updateOrderStatus(order_id, context);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Update Order Status",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
