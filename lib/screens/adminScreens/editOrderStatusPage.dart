import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sehat_app/Provider/provider.dart';

class EditOrderStatus extends StatefulWidget {
  final Map<String, dynamic> docs;
  final String orderStatus;
  final String order_id;
  const EditOrderStatus(
      {super.key,
      required this.docs,
      required this.orderStatus,
      required this.order_id});

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
    'Order Cancelled'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedStatus = widget.orderStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Products",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
              ),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.docs['items'].length,
                  itemBuilder: (context, index) {
                    var item = widget.docs['items'][index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${item['product_name']} (x${item['quantity']})",
                              style: TextStyle(fontSize: 16.5),
                            ),
                            Text(
                              "Rs.${item['unit_price']} / unit",
                              style: TextStyle(fontSize: 16.5),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Status",
                    style: TextStyle(fontSize: 16.5),
                  ),
                  Consumer<StatusValueProvider>(
                    builder: (context, value, child) {
                      return SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.5,
                        child: DropdownButtonFormField<String>(
                          padding: EdgeInsets.all(5),
                          value: value.selectedValue,
                          items: orderStatuses.map((String status) {
                            return DropdownMenuItem(
                              alignment: Alignment.center,
                              value: status,
                              child: Text(status),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            value.updateValue(newValue ?? "Order Pending");
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              MaterialButton(
                onPressed: () async {
                  String order_id = widget.order_id;
                  await context
                      .read<StatusValueProvider>()
                      .updateOrderStatus(order_id, context);
                },
                color: Colors.blue,
                textColor: Colors.white,
                padding: const EdgeInsets.all(16),
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text("Update Order Status"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
