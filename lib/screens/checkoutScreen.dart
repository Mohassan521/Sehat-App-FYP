import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:sehat_app/services/database_service.dart';
import 'package:sehat_app/widgets/completed.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOutScreen extends StatefulWidget {
  final String user_id;
  final List<PersistentShoppingCartItem> cartItems;
  final int totalPrice;
  final String contact;
  final String address;
  const CheckOutScreen(
      {super.key,
      required this.user_id,
      required this.cartItems,
      required this.totalPrice,
      required this.contact,
      required this.address});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  TextEditingController couponController = TextEditingController();
  String _selectedValue = "Cash On Delivery";
  String status = "Order Pending";

  Future<void> postCartDetailsToFirestore() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String userId = sp.getString("id") ?? "";
    String username = sp.getString("fullName") ?? "Unknown User";
    String contact = sp.getString("contact") ?? "No Contact";
    String address = sp.getString("address") ?? "";

    // Ensure you have the filtered items for the current user
    // await fetchUserCartItems(); // Ensure this function fetches updated data

    int totalPrice = widget.totalPrice;

    String orderId = (100 + Random().nextInt(900)).toString();

    CollectionReference ordersRef =
        FirebaseFirestore.instance.collection('Orders');

    // Create an order document
    ordersRef.doc(orderId).set({
      "order_id": orderId,
      "Status": status,
      'user_id': userId,
      'address': address,
      'username': username,
      'contact': contact,
      'total_price': totalPrice,
      'items': widget.cartItems
          .map((item) => {
                'product_name': item.productName,
                'quantity': item.quantity,
                'unit_price': item.unitPrice,
                'image': item.productImages?[0],
              })
          .toList(), // Saving items as a list of maps
      'timestamp': FieldValue.serverTimestamp()
    }).then((value) {
      print("Order Added Successfully");
    }).catchError((error) {
      print("Failed to add order: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.cartItems.length);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order Summary",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ListTile(
                      leading: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(widget
                                  .cartItems[index].productImages!.isNotEmpty
                              ? widget.cartItems[index]
                                  .productImages![0] // Access the first image
                              : 'https://via.placeholder.com/150')),
                      title: Text(
                        widget.cartItems[index].productName,
                        style: TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                          "Quantity: ${widget.cartItems[index].quantity.toString()}, Price per unit:  ${widget.cartItems[index].unitPrice}"),
                    ),
                  );
                }),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  TextField(
                    controller: couponController,
                    decoration: InputDecoration(
                      hintText: "Apply Coupon Code Here",
                      hintStyle: TextStyle(fontSize: 14),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                        borderRadius: BorderRadius.circular(15),
                      ), // Adjust font size
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15, horizontal: 16), // Compact height
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(
                            right: 8), // Add spacing between button and field
                        child: MaterialButton(
                          onPressed: () {},
                          color: Colors.grey,
                          textColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 10.5), // Button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Apply",
                            style: TextStyle(fontSize: 12), // Button font size
                          ),
                        ),
                      ),
                      suffixIconConstraints: BoxConstraints(
                        minHeight: 0,
                        minWidth: 0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Subtotal"),
                            Text("\$${widget.totalPrice}"),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Shipping Charges"),
                            Text("\$0"),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tax Fees"),
                            Text("\$0"),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Grand Total",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Text("\$${widget.totalPrice}",
                                style: TextStyle(fontWeight: FontWeight.w700)),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Payment Method",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Radio(
                                value: "Cash On Delivery",
                                groupValue: _selectedValue,
                                onChanged: (val) {
                                  setState(() {
                                    _selectedValue = val!;
                                  });
                                }),
                            Text(
                              "Cash On Delivery",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Shipping Details",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 8),
                          child: Row(
                            children: [
                              Icon(Icons.phone),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                widget.contact,
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 8),
                          child: Row(
                            children: [
                              Icon(Icons.location_history),
                              SizedBox(
                                width: 10,
                              ),
                              ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.sizeOf(context).width *
                                              0.76),
                                  child: Text(
                                    widget.address,
                                    style: TextStyle(fontSize: 15),
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                          onPressed: () async {
                            // Map<String, dynamic> cartData =
                            //     PersistentShoppingCart().getCartData();
                            // List<PersistentShoppingCartItem> cartItems =
                            //     cartData['cartItems'] ?? [];

                            String cartItemsMessage =
                                widget.cartItems.map((item) {
                              return "- ${item.productName} (${item.quantity} pieces): \$${item.unitPrice} / unit";
                            }).join("\n");

                            SharedPreferences sp =
                                await SharedPreferences.getInstance();
                            String name = sp.getString("fullName") ?? "";
                            String email = sp.getString("email") ?? "";
                            String subject = "Order Confirmation";
                            String message =
                                "You have placed an order of Rs.${widget.totalPrice} which includes $cartItemsMessage\n. Pharmacy manager will contact you shortly";

                            print(email);
                            // postCartDetailsToFirestore();

                            DatabaseService()
                                .sendEmail(
                                    recepient: email,
                                    name: name,
                                    email: email,
                                    subject: subject,
                                    message: message)
                                .then((_) {
                              postCartDetailsToFirestore();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CompletedAnyTask(
                                          path:
                                              'assets/images/order-placed.json',
                                          message:
                                              "Order Placed. You will be contacted shortly. \n Email also sent for verification ")));
                            });
                            // PersistentShoppingCart().clearCart();
                          },
                          child: Text("Checkout"),
                          color: Colors.orange,
                          textColor: Colors.white,
                          padding: EdgeInsets.all(16),
                          minWidth: double.infinity,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
