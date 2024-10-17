
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sehat_app/Utils/Utils.dart';
import 'package:sehat_app/models/chatMessage.dart';
import 'package:sehat_app/models/message.dart';
import 'package:sehat_app/screens/adminScreens/adminHomePage.dart';
import 'package:sehat_app/screens/doctorScreens/doctorHomePage.dart';
import 'package:sehat_app/screens/frontPage.dart';
import 'package:sehat_app/screens/userHomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {

  final GetIt getIt = GetIt.instance;

  DatabaseService(){
     _setupCollectionReferences();
  }

  CollectionReference? _chatsCollection;

  void route(BuildContext context) async {
  try {
    var auth = FirebaseAuth.instance;

    auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        // User is logged in, proceed to check their role and navigate accordingly
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('registeredUsers')
            .doc(user.uid)
            .get();

        if (documentSnapshot.exists) {
          String role = documentSnapshot.get('role') ?? 'Unknown Role';
          String fullName = documentSnapshot.get("display_name") ?? 'No Name'; 

          SharedPreferences sp = await SharedPreferences.getInstance();
          sp.setString("role", role);
          sp.setString("fullName", fullName);

          if (role == "Admin") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminHomePage()),
            );
          } else if (role == "Patient") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UserHomePage(full_name: sp.getString("fullName") ?? '')),
            );
          } else if (role == "Doctor") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DoctorHomePage(full_name: sp.getString("fullName") ?? '')),
            );
          } else {
            Utils().toastMessage('Invalid user role', Colors.red, Colors.white);
          }
        } else {
          Utils().toastMessage('No user data found. Please contact support.', Colors.orange, Colors.white);
        }
      } else {
        // User is logged out, navigate to the Login Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FrontPage()), // Replace with your LoginPage widget
        );
      }
    });
  } catch (e) {
    Utils().toastMessage(
        'An error occurred while routing: $e', Colors.red, Colors.white);
    print('Error in routing: $e');
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