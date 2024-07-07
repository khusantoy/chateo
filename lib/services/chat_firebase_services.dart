import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirebaseServices {
  // Firestore instancega murojaat qilish
  final firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>?> streamMessagesFromChatWithParticipants(
      String senderEmail, String receiverEmail) async* {
    // 'chats' kolleksiyasiga so'rov yuborish
    QuerySnapshot chatQuerySnapshot = await firestore.collection('chats').get();

    // Har bir hujjatni tekshirish
    for (var chatDoc in chatQuerySnapshot.docs) {
      List<dynamic> participants = chatDoc['participants'];

      // Agar ikkala email ham qatnashchilarda bo'lsa, hujjat ID sini olish
      if (participants.contains(senderEmail) &&
          participants.contains(receiverEmail)) {
        String chatId = chatDoc.id;

        // Berilgan chatId li hujjatning ichidagi 'messages' sub-kolleksiyasini stream qilish
        yield* firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp',
                descending:
                    true) // Add this line to order by timestamp in descending order
            .snapshots()
            .map((snapshot) {
          List<Map<String, dynamic>> messages = [];
          for (var messageDoc in snapshot.docs) {
            messages.add(messageDoc.data());
          }
          return messages.reversed.toList();
        });
        return; // Birinchi mos keladigan chat topilganda funksiyani to'xtatish
      }
    }
  }

  Future<void> addMessage(
    String senderEmail,
    String receiverEmail,
    String text,
    String type,
  ) async {
    // 'chats' kolleksiyasiga so'rov yuborish
    QuerySnapshot chatQuerySnapshot = await firestore.collection('chats').get();

    // senderId
    String chatId = '';

    // Har bir hujjatni tekshirish
    for (var chatDoc in chatQuerySnapshot.docs) {
      List<dynamic> participants = chatDoc['participants'];

      // Agar ikkala email ham qatnashchilarda bo'lsa, hujjat ID sini olish
      if (participants.contains(senderEmail) &&
          participants.contains(receiverEmail)) {
        chatId = chatDoc.id;
      }
    }

    // Yangi xabar uchun hujjat yaratish
    Map<String, dynamic> newMessage = {
      'senderId': senderEmail,
      'text': text,
      'type': type,
      'timestamp': FieldValue.serverTimestamp(),
    };

    // 'messages' sub-kolleksiyasiga yangi hujjat qo'shish
    await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(newMessage);
  }
}
