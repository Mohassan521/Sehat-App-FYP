import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:sehat_app/Utils/Utils.dart';
import 'package:sehat_app/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  Future<List<PersistentShoppingCartItem>> _fetchUserCartItems() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String userId = sp.getString("id") ?? "";

    // Retrieve cart data
    Map<String, dynamic> cartData = PersistentShoppingCart().getCartData();
    List<PersistentShoppingCartItem> cartItems = cartData['cartItems'] ?? [];

    // Filter items for the current user
    return cartItems
        .where((item) => item.productDetails?['user-id'] == userId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(padding: EdgeInsets.only(right: 10), child: InkWell(
            onTap: () {
              PersistentShoppingCart().clearCart();
              Utils().toastMessage("Cart is clear now", Colors.black, Colors.white);
            },
            child: const Text("Clear Cart", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),)),)
          
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Cart Items",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder<List<PersistentShoppingCartItem>>(
                            future: _fetchUserCartItems(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Center(child: Text('Your cart is empty'));
                              }
                    
                              // Display cart items in a ListView
                              final cartItems = snapshot.data!;
                              return ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: cartItems.length,
                                                  itemBuilder: (context, index) {
                                                    final item = cartItems[index];
                                                    return Card(
                                                      elevation: 1.2,
                                                      child: ListTile(
                                                      contentPadding: EdgeInsets.all(10),
                                                      leading: Image.network(item.productImages!.first, fit: BoxFit.cover),
                                                      title: Text(item.productName),
                                                      subtitle: Text('Price: \$${item.unitPrice}\nQuantity: ${item.quantity}'),
                                                      trailing: IconButton(
                                                        icon: Icon(Icons.delete),
                                                        onPressed: () async {
                                                          await PersistentShoppingCart().removeFromCart(item.productId);
                                                        },
                                                      ),
                                                    ),
                                                    );
                                                  },
                              );
                            },
                          ),
                          
                                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Price: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        Text(PersistentShoppingCart().calculateTotalPrice().toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                      ],
                    ),
                                  )
                  ],
                ),
    
                // FutureBuilder<List<Map<String, dynamic>>>(
                //   future: DatabaseService().getCartItems(),
                //   builder: (context, snapshot) {
                //     if(snapshot.hasError){
                //       return Center(child: Text("Error while loading data"));
                //     }
                //     else if(!snapshot.hasData || snapshot.data!.isEmpty){
                //       return Center(child: Text("No item available in cart"));
                //     }
                //     final items = snapshot.data ?? [];
                //     return ListView.builder(
                //       shrinkWrap: true,
                //       itemCount: items.length,
                //       itemBuilder: (context, index) {
                //         print("images of cart items: ${items[index]["medImage"]} ");
                //         return Card(
                //           elevation: 0.5,
                //           child: ListTile(
                //             contentPadding: EdgeInsets.all(12),
                //           leading: Image.network(
                            
                //               "${items[index]["medImage"]}",),
                //           title: Text("${items[index]["medName"]}"),
                //           subtitle: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text("Rs.${items[index]["medPrice"]}"),
                //               Text("Quantity.${items[index]["qty"]}"),
                //             ],
                //           ),
                //           // trailing: InputQty(
                //           //   // decoration: QtyDecorationProps(
                //           //   //     qtyStyle: QtyStyle.btnOnLeft,
                //           //   //     orientation: ButtonOrientation.vertical
                //           //   // ),
                //           //   maxVal: 100,
                //           //   initVal: items[index]["qty"],
                //           //   minVal: 1,
                //           //   steps: 1,
                //           //   onQtyChanged: (val) {
                //           //     print(val);
                //           //   },
                //           // ),
                //                                 ),
                //         );
            
                //       },);
                //   }
                // )
              ],
            ),
            MaterialButton(onPressed: ()async {
              SharedPreferences sp = await SharedPreferences.getInstance();
              String id = sp.getString("id") ?? "";
              // DatabaseService().clearCart(id);

            },
            child: const Text("Proceed to Checkout"),
            padding: EdgeInsets.all(16),
            color: Colors.orange,
            textColor: Colors.white,
            minWidth: double.infinity,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            )
          ],
        ),
      ),
    );
  }
}
