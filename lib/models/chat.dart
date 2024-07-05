import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final List<String> participants;
  final CollectionReference messages;

  Chat({
    required this.id,
    required this.participants,
    required this.messages,
  });

  factory Chat.fromQuerySnapshot(DocumentSnapshot query) {
    return Chat(
      id: query.id,
      participants: List<String>.from(query['participants']),
      messages: query.reference.collection('messages'),
    );
  }
}
