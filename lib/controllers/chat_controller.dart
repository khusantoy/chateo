import 'package:chateo/services/chat_firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatController {
  final _chatFirebaseServices = ChatFirebaseServices();

  Future<DocumentSnapshot?> getChatBetweenParticipants(String loggedInUserEmail, String receiverUserEmail) {
    return _chatFirebaseServices.getChatBetweenParticipants(loggedInUserEmail, receiverUserEmail);
  }
}
