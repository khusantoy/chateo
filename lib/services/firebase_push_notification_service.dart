import 'package:firebase_messaging/firebase_messaging.dart';

class FirebasePushNotificationService {
  static final _pushNotification = FirebaseMessaging.instance;

  static Future<void> init() async {
    // push notification yuborish uchun ruxsat so'raymiz
    final notificationSettings = await _pushNotification.requestPermission();

    // qurilma TEKEN'nini olamiz, shu orqli qaysi qurilmaga xabarnoma yuborishni aniqlaymiz
    final token = await _pushNotification.getToken();

    print(token);
  }
}
