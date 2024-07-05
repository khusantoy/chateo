import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  String senderId;
  String text;
  Timestamp timestamp;
  String type;

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.type,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Message(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      type: data['type'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
      'type': type,
    };
  }

  factory Message.fromQuerySnapshot(QueryDocumentSnapshot query) {
    return Message(
      id: query.id,
      senderId: query['senderId'] ?? '',
      text: query['text'] ?? '',
      timestamp: query['timestamp'] ?? Timestamp.now(),
      type: query['type'] ?? '',
    );
  }
}
