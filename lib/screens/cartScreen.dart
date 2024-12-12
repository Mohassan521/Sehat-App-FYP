import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:sehat_app/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: DatabaseService().getCartItems(),
                  builder: (context, snapshot) {
                    if(snapshot.hasError){
                      return Center(child: Text("Error while loading data"));
                    }
                    else if(!snapshot.hasData || snapshot.data!.isEmpty){
                      return Center(child: Text("No item available in cart"));
                    }
                    final items = snapshot.data ?? [];
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        print("images of cart items: ${items[index]["medImage"]} ");
                        return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(
                            
                              "${items[index]["medImage"]}",),
                        ),
                        title: Text("${items[index]["medName"]}"),
                        subtitle: Text("Rs.${items[index]["medPrice"]}"),
                        trailing: InputQty(
                          // decoration: QtyDecorationProps(
                          //     qtyStyle: QtyStyle.btnOnLeft,
                          //     orientation: ButtonOrientation.vertical
                          // ),
                          maxVal: 100,
                          initVal: items[index]["qty"],
                          minVal: 1,
                          steps: 1,
                          onQtyChanged: (val) {
                            print(val);
                          },
                        ),
                      );
            
                      },);
                  }
                )
              ],
            ),
            MaterialButton(onPressed: ()async {
              // SharedPreferences sp = await SharedPreferences.getInstance();
              // String id = sp.getString("id") ?? "";
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
