import 'package:chateo/controllers/users_controller.dart';
import 'package:chateo/firebase_options.dart';
import 'package:chateo/models/user_model.dart';
import 'package:chateo/services/firebase_push_notification_service.dart';
import 'package:chateo/utils/routes.dart';
import 'package:chateo/views/screens/auth/login_screen.dart';
import 'package:chateo/views/screens/auth/register_screen.dart';
import 'package:chateo/views/screens/auth/reset_password_screen.dart';
import 'package:chateo/views/screens/chat_screen.dart';
import 'package:chateo/views/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  // firestore setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebasePushNotificationService.init();

  // push notification dastur orqa fonda ishlashini ta'minlaydi
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // run my app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return UsersController();
      },
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomeScreen();
            }

            return const LoginScreen();
          },
        ),
        routes: {
          AppRoutes.home: (context) => const HomeScreen(),
          AppRoutes.login: (context) => const LoginScreen(),
          AppRoutes.register: (context) => const RegisterScreen(),
          AppRoutes.resetPassword: (context) => const ResetPasswordScreen(),
          AppRoutes.chat: (context) {
            final user =
                ModalRoute.of(context)!.settings.arguments as UserModel;
            return ChatScreen(user: user);
          },
        },
      ),
    );
  }
}
