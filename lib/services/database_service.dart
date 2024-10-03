
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:sehat_app/models/chatMessage.dart';
import 'package:sehat_app/models/message.dart';

class DatabaseService {

  final GetIt getIt = GetIt.instance;

  DatabaseService(){
     _setupCollectionReferences();
  }

  CollectionReference? _chatsCollection;

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