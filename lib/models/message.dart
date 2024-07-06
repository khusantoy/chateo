import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String text;
  String type;
  Timestamp timestamp;

  Message({
    required this.senderId,
    required this.text,
    required this.type,
    required this.timestamp,
  });

  // Factory constructor to create a Message from a Firestore document
  factory Message.fromFirestore(Map<String, dynamic> data) {
    return Message(
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      type: data['type'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  // Method to convert a Message to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'text': text,
      'type': type,
      'timestamp': timestamp,
    };
  }
}
