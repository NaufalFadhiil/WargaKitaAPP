import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, String>> getUserData(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final username = data?['username'] as String? ?? 'Pengguna Tidak Ditemukan';
        final phoneNumber = data?['phone_number'] as String? ?? '';

        return {
          'username': username,
          'phoneNumber': phoneNumber,
        };
      } else {
        return {
          'username': 'Pengguna Tidak Ditemukan',
          'phoneNumber': '',
        };
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      return {
        'username': 'Error Memuat Nama',
        'phoneNumber': '',
      };
    }
  }

  Future<String> getUsernameByUid(String uid) async {
    final userData = await getUserData(uid);
    return userData['username']!;
  }
}