import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { Text, Image, file }

class Message {
  String? senderID;
  String? senderName;
  String? content;
  String? url;
  MessageType? messageType;
  Timestamp? sentAt;

  Message({
    required this.senderID,
    required this.senderName,
    required this.content,
    this.url,
    required this.messageType,
    required this.sentAt,
  });

  Message.fromJson(Map<String, dynamic> json) {
    senderID = json['senderID'];
    senderName = json['senderName'];
    content = json['content'];
    url = json["url"];
    sentAt = json['sentAt'];
    messageType = MessageType.values.byName(json['messageType']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['senderID'] = senderID;
    data['senderName'] = senderName;
    data['content'] = content;
    data["url"] = url;
    data['sentAt'] = sentAt;
    data['messageType'] = messageType!.name;
    return data;
  }
}