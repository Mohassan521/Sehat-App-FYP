import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:sehat_app/Utils/Utils.dart';
import 'package:sehat_app/models/chatMessage.dart';
import 'package:sehat_app/models/message.dart';
import 'package:sehat_app/screens/adminScreens/adminHomePage.dart';
import 'package:sehat_app/screens/doctorScreens/doctorHomePage.dart';
import 'package:sehat_app/screens/frontPage.dart';
import 'package:sehat_app/screens/userHomePage.dart';
import 'package:sehat_app/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:http/http.dart' as http;

class DatabaseService {
  final GetIt getIt = GetIt.instance;
  // static Database? _database;

  DatabaseService() {
    _setupCollectionReferences();
    // database;
  }

  CollectionReference? _chatsCollection;

//   Future<Map<String, dynamic>> getUserCart() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? userId = prefs.getString('id'); // Fetch the current user's ID
//   if (userId == null) {
//     throw Exception('User ID not found. Ensure the user is logged in.');
//   }

//   // Use a unique cart key for each user
//   final cartKey = "cart_$userId";
//   return PersistentShoppingCart();
// }

// Future<void> addCartItem({
//   required String userId,
//   required String medName,
//   required double medPrice,
//   required int qty,
//   required String medImage,
// }) async {
//   final cart = await getUserCart(); // Fetch the user's specific cart

//   // Create a unique item ID for the cart (e.g., based on medicine name)
//   final itemId = "$userId-$medName";

//   // Add the item to the cart
//   final cartItem = PersistentShoppingCartItem(
//     productId: itemId,
//     productName: medName,
//     unitPrice: medPrice,
//     quantity: qty,
//     productImages: [medImage]
//     // additionalData: {
//     //   'medImage': medImage,
//     //   'userId': userId,
//     // },
//   );

//   await cart.addToCart(cartItem);

//   print("Item added to cart for user $userId");
// }

// Future<List<PersistentShoppingCartItem>> getUserCartItems() async {
//   final cart = await getUserCart(); // Fetch the user's specific cart
//   return await cart.getCartData();
// }

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   void createCartTable(Database db) async {
//     print("Creating Cart table...");
//     await db.execute(
//         'CREATE TABLE Cart (id INTEGER PRIMARY KEY AUTOINCREMENT, userId TEXT NOT NULL ,medName TEXT NOT NULL, medPrice TEXT NOT NULL, qty INTEGER NOT NULL, medImage TEXT NOT NULL)');
//     print("Cart table Created");
//   }

//   Future<Database> _initDatabase() async {
//   final dbPath = await getDatabasesPath();
//   print("Database path: $dbPath");
//   return openDatabase(
//     join(dbPath, "cartItems.db"),
//     version: 1,
//     onCreate: (db, version) {
//       print("Database created, initializing tables...");
//       createCartTable(db);
//     },
//     onOpen: (db) {
//       print("Database opened.");
//     },
//   );
// }

//   Future<void> insertCartItem(Map<String, dynamic> cartItem) async {
//   final db = await DatabaseService().database;

//   // Check if the item already exists for the same user
//   final existingItem = await db.query(
//     'Cart',
//     where: 'userId = ? AND medName = ? AND qty = ? AND medPrice = ?',
//     whereArgs: [cartItem['userId'], cartItem['medName'], cartItem['qty'], cartItem['medPrice']],
//   );

//   if (existingItem.isNotEmpty) {
//     Utils().toastMessage("Item is already added in cart", Colors.red, Colors.white);
//     return; // Exit without inserting
//   }

//   // Insert if the item doesn't exist
//   int id = await db.insert('Cart', cartItem);
//   print("Item added with ID: $id");
// }

//   Future<List<Map<String, dynamic>>> fetchUserCartItems(String userId) async {
//     final db = await DatabaseService().database; // Use DatabaseService
//   return await db.query(
//     'Cart',
//     where: 'userId = ?',
//     whereArgs: [userId],
//   );
// }

// Future<List<Map<String, dynamic>>> getCartItems() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? userId = prefs.getString('id');
//   if (userId != null) {
//      return await fetchUserCartItems(userId);
//   }
//   return [];
// }

// Future<bool> doesCartContainItems() async {
//   final db = await database;
//   final result = await db.rawQuery('SELECT * FROM Cart');
//   final count = Sqflite.firstIntValue(result);
//   print("Number of items in Cart: $count");
//   return count != null && count > 0;
// }

//   Future<void> clearCart(String userId) async {
//     final db = await database;
//     await db.delete('Cart', where: 'userId = ?', whereArgs: [userId]);
//   }

  Future sendEmail({
    required String recepient,
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "service_id": "service_ledhy4e",
          "template_id": "template_t0ojqq4",
          "user_id": "ZWrFny1RQdaBixAeC",
          "accessToken": "hIIuVk7P-Fg9nAADXbQ_W",
          "template_params": {
            "to_email": recepient,
            "to_name": name, // This corresponds to {{to_name}} in your template
            "user_email": email, // If you want to pass the user's email
            "user_subject":
                subject, // This corresponds to {{user_subject}} in your template
            "user_message":
                message, // This corresponds to {{user_message}} in your template
          }
        }));

    print(response.body);
  }

  void route(BuildContext context) async {
    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      auth.authStateChanges().listen((User? user) async {
        if (user == null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => FrontPage()));
          return;
        }

        // Get user document
        final doc =
            await firestore.collection('registeredUsers').doc(user.uid).get();
        if (!doc.exists) {
          Utils()
              .toastMessage('No user data found', Colors.orange, Colors.white);
          return;
        }

        // Handle FCM tokens
        final messaging = FirebaseMessaging.instance;

        // 1. Always get current token on login
        String? currentToken = await messaging.getToken();
        print('Initial FCM Token: $currentToken');

        // 2. Setup token refresh listener
        messaging.onTokenRefresh.listen((newToken) async {
          print('Token refreshed: $newToken');
          await firestore
              .collection('registeredUsers')
              .doc(user.uid)
              .update({'fcmToken': newToken});
        });

        // 3. Update Firestore with latest token
        if (currentToken != null) {
          await firestore
              .collection('registeredUsers')
              .doc(user.uid)
              .update({'fcmToken': currentToken});
        }

        // Rest of your role handling...
        final role = doc.get('role') ?? 'Unknown';
        final sp = await SharedPreferences.getInstance();

        // Save user data to shared preferences
        sp.setString('role', role);
        sp.setString('fullName', doc.get('display_name') ?? '');
        sp.setString('id', doc.get('user_id') ?? '');
        sp.setString('email', doc.get('email') ?? '');

        // Navigation logic
        switch (role) {
          case 'Admin':
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => AdminHomePage(
                        full_name: sp.getString('fullName') ?? '')));
            break;
          case 'Patient':
            // Handle patient specific data
            String? contact = doc.get("contact") ?? "";
            String? address = doc.get("parmanent_address") ?? "";
            sp.setString("contact", contact ?? "");
            sp.setString("address", address ?? "");
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => UserHomePage(
                        full_name: sp.getString("fullName") ?? '')));
            break;
          case 'Doctor':
            // Handle doctor navigation
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => DoctorHomePage(
                          full_name: sp.getString("fullName") ?? '',
                          uid: sp.getString("id")!,
                        )));
            break;
          default:
            Utils().toastMessage('Invalid role', Colors.red, Colors.white);
        }
      });
    } catch (e) {
      Utils().toastMessage('Error: $e', Colors.red, Colors.white);
      print('Routing error: $e');
    }
  }

  String generateChatId({required String uid1, required String uid2}) {
    List uids = [uid1, uid2];
    uids.sort();
    String chatID = uids.fold("", (id, uid) => "$id$uid");
    return chatID;
  }

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void _setupCollectionReferences() {
    _chatsCollection = _firebaseFirestore
        .collection("chats")
        .withConverter<Chat>(
            fromFirestore: (snapshots, _) => Chat.fromJson(snapshots.data()!),
            toFirestore: (chatMessage, _) => chatMessage.toJson());
  }

  Future<bool> checkChatExists(
      {required String? uid1, required String? uid2}) async {
    String chatID = generateChatId(uid1: uid1!, uid2: uid2!);

    final result = await _chatsCollection?.doc(chatID).get();

    if (result != null) {
      return result.exists;
    }
    return false;
  }

  Future<void> createNewChat(
      {required String? uid1, required String? uid2}) async {
    String chatID = generateChatId(uid1: uid1!, uid2: uid2!);

    final docRef = _chatsCollection!.doc(chatID);

    final chat = Chat(id: chatID, participants: [uid1, uid2], messages: []);

    await docRef.set(chat);
  }

  Future<void> sendChatMessage(
      String uid1, String uid2, Message message) async {
    String chatID = generateChatId(uid1: uid1, uid2: uid2);

    final docRef = _chatsCollection!.doc(chatID);

    await docRef.update(
      {
        "messages": FieldValue.arrayUnion(
          [
            message.toJson(),
          ],
        ),
      },
    );
  }

  Stream<DocumentSnapshot<Chat>> getChatData(String uid1, String uid2) {
    String chatID = generateChatId(uid1: uid1, uid2: uid2);
    return _chatsCollection?.doc(chatID).snapshots()
        as Stream<DocumentSnapshot<Chat>>;
  }
}
