import 'dart:io';

import 'package:chateo/services/users_firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UsersController with ChangeNotifier {
  final _usersFirebaseService = UsersFirebaseServices();

  Stream<QuerySnapshot> get list async* {
    yield* _usersFirebaseService.getUsers();
  }

  Future<void> addUser(
    String username,
    String email,
    String status,
    File imageFile,
  ) async {
    await _usersFirebaseService.addUser(username, email, status, imageFile);
  }
}
