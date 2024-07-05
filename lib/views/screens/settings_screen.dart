import 'package:chateo/services/auth_firebase_services.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [
          IconButton(
            onPressed: () {
              AuthFirebaseServices.logout();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
    );
  }
}
