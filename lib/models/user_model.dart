import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String username;
  String email;
  String imageUrl;
  String status;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.imageUrl,
    required this.status,
  });

  factory UserModel.fromQuerySnapshot(QueryDocumentSnapshot query) {
    return UserModel(
      id: query.id,
      username: query['username'],
      email: query['email'],
      imageUrl: query['imageUrl'],
      status: query['status'],
    );
  }
}
