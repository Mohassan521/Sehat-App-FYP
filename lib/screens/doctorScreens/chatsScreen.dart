import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser?.uid);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.purple,
        title: Text(
          "Conversations",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height * 0.35,
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("chats").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Text("No Data Available"));
                  }
            
                  var docs = snapshot.data!.docs;
            
                  // Filter the documents where participants[1] matches the current user's ID
                  List<DocumentSnapshot> filteredDocs = docs.where((doc) {
                    var participants = doc['participants'] as List<dynamic>;
                    return participants.length > 1 &&
                        participants[1] == FirebaseAuth.instance.currentUser?.uid;
                  }).toList();
            
                  if (filteredDocs.isEmpty) {
                  // If no documents match the condition, show a "No chats found" message
                  return Center(child: Text("No chats found"));
                }
            
                return ListView.builder(
  itemCount: filteredDocs.length,
  itemBuilder: (context, index) {
    var chatData = filteredDocs[index].data() as Map<String, dynamic>;
    
    // Ensure messages exist and access the first message
    if (chatData['messages'] != null && chatData['messages'].isNotEmpty) {
      var firstMessage = chatData['messages'][0]; // Access the first message in the array
      
      return ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Image.asset("assets/images/doctor1.jpg", width: MediaQuery.sizeOf(context).width * 0.15,)),
        title: Text("${firstMessage['senderID']}"),
        subtitle: Text(firstMessage['content'] ?? "No message content"),
        trailing: Text(
          DateFormat('hh:mm a').format(
            (firstMessage['sentAt'] as Timestamp).toDate(),
          ),
        ),
      );
    } else {
      // Handle the case where no messages are present
      return ListTile(
        title: Text("No messages available"),
      );
    }
  },
);

                }),
          )
        ],
      ),
    );
  }
}
