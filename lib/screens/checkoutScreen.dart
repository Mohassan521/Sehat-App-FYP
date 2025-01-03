import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:sehat_app/services/database_service.dart';
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
      required this.totalPrice, required this.contact, required this.address});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  TextEditingController couponController = TextEditingController();
  String _selectedValue = "Cash On Delivery";

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
                          child: Image.network(widget.cartItems[index].productImages!.isNotEmpty
                                        ? widget.cartItems[index].productImages![0] // Access the first image
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
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 0.0),
                                  borderRadius: BorderRadius.circular(15),
                                ), // Adjust font size
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 0.0),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 16), // Compact height
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                      right:
                                          8), // Add spacing between button and field
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
                                      style: TextStyle(
                                          fontSize: 12), // Button font size
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
                                borderRadius: BorderRadius.circular(12)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Subtotal"),
                                      Text("\$${PersistentShoppingCart().calculateTotalPrice().toString()}"),
                                      
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
                                      Text("Grand Total", style: TextStyle(fontWeight: FontWeight.w700),),
                                      Text("\$${PersistentShoppingCart().calculateTotalPrice().toString()}", style: TextStyle(fontWeight: FontWeight.w700)),
                                      
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                  Row(
                                    children: [
                                      Radio(value: "Cash On Delivery", groupValue: _selectedValue, onChanged: (val){
                                        setState(() {
                                          _selectedValue = val!;
                                        });
                                      }),
                                      Text("Cash On Delivery", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)
                                      
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Shipping Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8),
                                    child: Row(
                                      children: [
                                        Icon(Icons.phone),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(widget.contact, style: TextStyle(fontSize: 15),)
                                        
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8),
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_history),
                                        SizedBox(
                                            width: 10,
                                          ),
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.sizeOf(context).width * 0.76
                                          ),
                                          child: Text(widget.address, style: TextStyle(fontSize: 15),))
                                        
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  MaterialButton(onPressed: () async{

                                    Map<String, dynamic> cartData = PersistentShoppingCart().getCartData();
    List<PersistentShoppingCartItem> cartItems = cartData['cartItems'] ?? [];

    String cartItemsMessage = cartItems.map((item) {
      return "- ${item.productName} (x${item.quantity}): \$${item.unitPrice}";
    }).join("\n");

                                    SharedPreferences sp = await SharedPreferences.getInstance();
                                    String name = sp.getString("fullName") ?? "";
                                    String email = sp.getString("email") ?? "";
                                    String subject = "Order Confirmation";
                                    String message = "You have placed an order of Rs.${PersistentShoppingCart().calculateTotalPrice()} which includes $cartItemsMessage\n. Pharmacy manager will contact you shortly";

                                    print(email);

                                    DatabaseService().sendEmail(recepient: email ,name: name, email: email, subject: subject, message: message);
                                    PersistentShoppingCart().clearCart();
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
