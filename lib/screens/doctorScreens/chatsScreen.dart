import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sehat_app/Provider/provider.dart';
import 'package:sehat_app/screens/chatRoom.dart';
import 'package:sehat_app/services/database_service.dart';

class ChatsScreen extends StatefulWidget {
  final String fullName;
  const ChatsScreen({super.key, required this.fullName});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final GetIt _getIt = GetIt.instance;
  late DatabaseService _databaseService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _databaseService = _getIt.get<DatabaseService>();
  }

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

                // Filter chat documents where the doctor (current user) is a participant
                List<DocumentSnapshot> filteredDocs = docs.where((doc) {
                  var participants = doc['participants'] as List<dynamic>;
                  return participants
                      .contains(FirebaseAuth.instance.currentUser?.uid);
                }).toList();

                if (filteredDocs.isEmpty) {
                  return Center(child: Text("No chats found"));
                }

                return ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    var chatData =
                        filteredDocs[index].data() as Map<String, dynamic>;
                    var participants =
                        chatData['participants'] as List<dynamic>;

                    // Identify the patient (not the doctor)
                    String? patientId;
                    participants.forEach((id) {
                      if (id != FirebaseAuth.instance.currentUser?.uid) {
                        patientId = id;
                      }
                    });

                    // Fetch patient details from 'registeredUsers' collection
                    return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection("registeredUsers")
                          .doc(patientId)
                          .get(),
                      builder: (context,
                          AsyncSnapshot<DocumentSnapshot> patientSnapshot) {
                        if (!patientSnapshot.hasData) {
                          return Center(child: Text("Loading patient details..."));
                          
                        }

                        var patientData = patientSnapshot.data?.data()
                            as Map<String, dynamic>;
                        var patientName =
                            patientData['display_name'] ?? "Unknown";
                        var patientId = patientData['user_id'] ?? "Unknown";

                        // Ensure the messages exist and access the first message
                        if (chatData['messages'] != null &&
                            chatData['messages'].isNotEmpty) {
                          var lastMessageIndex =
                              chatData['messages'].length - 1;
                          var lastMessage = chatData['messages']
                              [lastMessageIndex]; // Access the last message

                          String messageContent;
                          if (lastMessage['messageType'] == 'image') {
                            messageContent =
                                "Image"; // Display 'Image' if the message is an image
                          } else {
                            // Truncate long text if needed
                            String fullMessage =
                                lastMessage['content'] ?? "No message content";
                            if (fullMessage.length > 30) {
                              messageContent = fullMessage.substring(0, 30) +
                                  "..."; // Show the first 30 characters followed by "..."
                            } else {
                              messageContent =
                                  fullMessage; // If the message is short, display it fully
                            }
                          }

                          return ListTile(
                            onTap: () async {
                              print("Patient ID: $patientId");
                              print(
                                  "Your ID: ${FirebaseAuth.instance.currentUser?.uid}");

                              final chatExists =
                                  await _databaseService.checkChatExists(
                                uid1: patientId,
                                uid2: FirebaseAuth.instance.currentUser?.uid,
                              );

                              if (!chatExists) {
                                await _databaseService.createNewChat(
                                  uid1: patientId,
                                  uid2: FirebaseAuth.instance.currentUser?.uid,
                                );
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatRoom(
                                    docData: patientData,
                                    full_name: widget.fullName,
                                  ),
                                ),
                              );
                            },
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.asset(
                                "assets/images/doctor1.jpg",
                                width: MediaQuery.sizeOf(context).width * 0.15,
                              ),
                            ),
                            title: Text("$patientName"),
                            subtitle: Text(messageContent),
                            trailing: Text(
                              DateFormat('hh:mm a').format(
                                (lastMessage['sentAt'] as Timestamp).toDate(),
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
