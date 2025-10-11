import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String phoneNumber;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.createdAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'phone_number': phoneNumber,
    };
  }

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    Timestamp? timestamp = data['created_at'] as Timestamp?;

    return UserModel(
      uid: data['uid'] as String,
      username: data['username'] as String,
      email: data['email'] as String,
      phoneNumber: data['phone_number'] as String,
      createdAt: timestamp?.toDate(),
    );
  }
}