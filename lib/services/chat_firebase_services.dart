import 'package:chateo/models/chat.dart';
import 'package:chateo/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirebaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reference to the chats collection
  CollectionReference get chats => _firestore.collection('chats');

  // Reference to the users collection
  CollectionReference get users => _firestore.collection('users');

  // Create a new chat
  Future<void> createChat(String chatId, List<String> participantIds) async {
    try {
      await chats.doc(chatId).set({
        'participants': participantIds,
        'lastUpdated': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to create chat: $e');
    }
  }

  // Send a message in a chat
  Future<void> sendMessage(String chatId, String senderId, String text,
      {String type = 'text'}) async {
    try {
      final messageRef = chats.doc(chatId).collection('messages').doc();
      await messageRef.set({
        'text': text,
        'timestamp': Timestamp.now(),
        'senderId': senderId,
        'type': type,
      });

      // Update the last message in the chat
      await chats.doc(chatId).update({
        'lastMessage': {
          'text': text,
          'timestamp': Timestamp.now(),
          'senderId': senderId,
        },
        'lastUpdated': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Fetch all chats for a user
  // Stream<List<Chat>> getChats(String userId) {
  //   return chats
  //       .where('participants', arrayContains: userId)
  //       .snapshots()
  //       .map((querySnapshot) {
  //     return querySnapshot.docs.map((doc) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       return Chat(
  //         id: doc.id,
  //         participants: List<String>.from(data['participants']),
  //       );
  //     }).toList();
  //   });
  // }

  Future<DocumentSnapshot?> getChatBetweenParticipants(String userEmail1, String userEmail2) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContainsAny: [userEmail1, userEmail2])
        .get();

    final chatDoc = querySnapshot.docs.firstWhere((doc) {
      final participants = List<String>.from(doc['participants']);
      return participants.contains(userEmail1) && participants.contains(userEmail2) && participants.length == 2;
    },);

    return chatDoc;
  }

  // // Fetch messages in a chat
  // Stream<List<Message>> getMessages(String chatId) {
  //   return chats
  //       .doc(chatId)
  //       .collection('messages')
  //       .orderBy('timestamp')
  //       .snapshots()
  //       .map((querySnapshot) {
  //     return querySnapshot.docs.map((doc) {
  //       final data = doc.data();
  //       return Message.fromMap(data);
  //     }).toList();
  //   });
  // }
}
