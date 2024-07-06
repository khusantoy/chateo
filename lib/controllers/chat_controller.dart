import 'package:chateo/services/chat_firebase_services.dart';

class ChatController {
  final _chatFirebaseServices = ChatFirebaseServices();

  Stream<List<Map<String, dynamic>>?> streamMessagesFromChatWithParticipants(
      String senderEmail, String receiverEmail) async* {
    yield* _chatFirebaseServices.streamMessagesFromChatWithParticipants(
        senderEmail, receiverEmail);
  }

  Future<void> addMessage(
    String senderEmail,
    String receiverEmail,
    String text,
    String type,
  ) {
    return _chatFirebaseServices.addMessage(
        senderEmail, receiverEmail, text, type);
  }
}
