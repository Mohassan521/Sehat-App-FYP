import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:sehat_app/Utils/Utils.dart';
import 'package:sehat_app/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicineDetails extends StatefulWidget {
  final Map<String, dynamic> medDetails;
  const MedicineDetails({super.key, required this.medDetails});

  @override
  State<MedicineDetails> createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {

  double qty = 1;

  void initializeCart () async {
    await PersistentShoppingCart().init();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeCart();
  }

  @override
  Widget build(BuildContext context) {
    
    final DatabaseService _databaseService = DatabaseService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Hero(
                tag: widget.medDetails["Image"],
                child: Image.network(widget.medDetails["Image"])),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Name: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text(widget.medDetails["Medicine Name"],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Manufacturer: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.sizeOf(context).width * 0.45),
                          child: Text(widget.medDetails["Manufacturer"],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700))),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dosage Form: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text(widget.medDetails["Dosage Form"],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Description: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.sizeOf(context).width * 0.65),
                          child: Text(widget.medDetails["Description"],
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700))),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Category: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text(widget.medDetails["Medicine Category"],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Available in: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.sizeOf(context).width * 0.65),
                          child: Text(widget.medDetails["Pharmacy Name"],
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700))),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Prescription Required: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text(widget.medDetails["Prescription Required"],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Price: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text(
                          "Rs.${widget.medDetails["Price (per strip)"].toString()}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Quantity: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      InputQty(
                        maxVal: 100,
                        initVal: qty,
                        minVal: 1,
                        steps: 1,
                        onQtyChanged: (val) {
                          setState(() {
                            qty = val;
                            print("updated qty value: $qty");
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      print("quantity value: $qty");
                      SharedPreferences sp =
                          await SharedPreferences.getInstance();
                      String user_id = sp.getString("id") ?? "";
    String userId = sp.getString("id") ?? "";
    
    final cartItem = PersistentShoppingCartItem(
      productId: DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID for the item
      productName: widget.medDetails["Medicine Name"],
      unitPrice: qty * widget.medDetails["Price (per strip)"],
      quantity: qty.toInt()  ,
      productImages: [widget.medDetails["Image"]], 
      productDetails: {
        "user-id" : userId
      }
    );

    Map<String, dynamic> cartData = PersistentShoppingCart().getCartData();
    List<PersistentShoppingCartItem> cartItems = cartData['cartItems'] ?? [];

    // Check if the product is already in the cart for this user
    print("cart item product id: ${cartItem.productId}");
    bool alreadyInCart = cartItems.any((item) =>
        item.productId == item.productId && item.productDetails!['user-id'] == userId);

    if (alreadyInCart) {
      // Show a toast if the product is already in the cart
      Utils().toastMessage("This product is already in the cart", Colors.red, Colors.white);
    } else {
      // Add the item to the cart if not already present
      await PersistentShoppingCart().addToCart(cartItem);
      Utils().toastMessage("Medicine Added to Cart", Colors.orange, Colors.white);
    }
                      
                    },
                    child: Center(child: Text("Add To Cart")),
                    padding: EdgeInsets.all(15),
                    color: Colors.orange,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
