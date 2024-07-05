import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UsersFirebaseServices {
  final _usersCollection = FirebaseFirestore.instance.collection('users');
  final _usersImageStorage = FirebaseStorage.instance;
  

  Stream<QuerySnapshot> getUsers() async* {
    yield* _usersCollection.snapshots();
  }

  Future<void> addUser(
    String username,
    String email,
    String status,
    File imageFile,
  ) async {
    final imageReference = _usersImageStorage
        .ref()
        .child("users")
        .child("images")
        .child("$username.jpg");
        
    final uploadTask = imageReference.putFile(imageFile);

    await uploadTask.whenComplete(() async {
      final imageUrl = await imageReference.getDownloadURL();
      await _usersCollection.add({
        "username": username,
        "email": email,
        "status": status,
        "imageUrl": imageUrl,
      });
    });
  }
}
