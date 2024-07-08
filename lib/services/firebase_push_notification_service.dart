import 'package:firebase_messaging/firebase_messaging.dart';

class FirebasePushNotificationService {
  static final _pushNotification = FirebaseMessaging.instance;

  static Future<void> init() async {
    // push notification yuborish uchun ruxsat so'raymiz
    final notificationSettings = await _pushNotification.requestPermission();

    // qurilma TEKEN'nini olamiz, shu orqli qaysi qurilmaga xabarnoma yuborishni aniqlaymiz
    final token = await _pushNotification.getToken();

    // backgroundda xabar kelsa ishlaydi
    FirebaseMessaging.onMessage.listen((message) {
      print("XABAR ORQALI DASTURNI OCHGANDA KELDI");
      print("Xabar: $message");
    });

    // foregroundda xabar kelsa ishlaydi
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("DASTURDA BO'LMAGANDA XABAR KELDI");
      print('XABAR: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
}
