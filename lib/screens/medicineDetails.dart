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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseService _databaseService = DatabaseService();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Medicine Details",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Medicine Image
            Hero(
              tag: widget.medDetails["Image"],
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                  child: Image.network(
                    widget.medDetails["Image"],
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Medicine Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.medDetails["Medicine Name"],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.medDetails["Manufacturer"],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.medDetails["Description"],
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Key Details in Cards
                  _buildDetailCard(
                    title: "Dosage Form",
                    value: widget.medDetails["Dosage Form"],
                    icon: Icons.medication_outlined,
                  ),
                  _buildDetailCard(
                    title: "Category",
                    value: widget.medDetails["Medicine Category"],
                    icon: Icons.category_outlined,
                  ),
                  _buildDetailCard(
                    title: "Prescription Required",
                    value: widget.medDetails["Prescription Required"],
                    icon: Icons.assignment_turned_in_outlined,
                  ),
                  _buildDetailCard(
                    title: "Price",
                    value: "Rs. ${widget.medDetails["Price (per strip)"]}",
                    icon: Icons.price_change_outlined,
                  ),
                  _buildDetailCard(
                    title: "Strength",
                    value:
                        "${widget.medDetails["Strength"] ?? "Not Mentioned"}",
                    icon: Icons.medical_information,
                  ),

                  // Quantity Selector
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Quantity",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: qty > 1
                                ? () {
                                    setState(() {
                                      qty--;
                                    });
                                  }
                                : null,
                            icon: Icon(Icons.remove_circle_outline),
                            color: Colors.grey,
                          ),
                          Text(
                            qty.toString(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                qty++;
                              });
                            },
                            icon: Icon(Icons.add_circle_outline),
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Add to Cart Button
                  Center(
                    child: MaterialButton(
                      onPressed: () async {
                        print("quantity value: $qty");
                        SharedPreferences sp =
                            await SharedPreferences.getInstance();
                        String userId = sp.getString("id") ?? "";

                        final cartItem = PersistentShoppingCartItem(
                          productId: DateTime.now()
                              .millisecondsSinceEpoch
                              .toString(), // Use a unique identifier for the product
                          productName: widget.medDetails["Medicine Name"],
                          unitPrice: (widget.medDetails["Price (per strip)"])
                              .toDouble(),
                          quantity: qty.toInt(),
                          productImages: [widget.medDetails["Image"]],
                          productDetails: {
                            "user-id": userId,
                          },
                        );

                        Map<String, dynamic> cartData =
                            PersistentShoppingCart().getCartData();
                        List<PersistentShoppingCartItem> cartItems =
                            cartData['cartItems'] ?? [];

                        // Check if the product is already in the cart for this user
                        bool alreadyInCart = cartItems.any((item) =>
                            item.productImages?.first ==
                                cartItem.productImages
                                    ?.first && // Compare with the new item's productId
                            item.productDetails?['user-id'] == userId);

                        if (alreadyInCart) {
                          // Show a toast if the product is already in the cart
                          Utils().toastMessage(
                              "This product is already in the cart",
                              Colors.red,
                              Colors.white);
                        } else {
                          // Add the item to the cart if not already present
                          await PersistentShoppingCart().addToCart(cartItem);
                          Utils().toastMessage("Medicine Added to Cart",
                              Colors.orange, Colors.white);
                        }
                      },
                      color: Colors.purple,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      minWidth: double.infinity,
                      child: const Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(
      {required String title, required String value, required IconData icon}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple, size: 28),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
