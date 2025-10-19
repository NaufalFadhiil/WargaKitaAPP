import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/help_model.dart';

class AddHelpService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> addHelpRequest(HelpData helpData) async {
    if (_currentUid.isEmpty) {
      throw Exception("Pengguna tidak terautentikasi.");
    }

    final batch = _firestore.batch();

    final newHelpRef = _firestore.collection('help_requests').doc();
    batch.set(newHelpRef, helpData.toFirestore());

    final userRef = _firestore.collection('users').doc(_currentUid);
    batch.set(userRef, {
      'created_help_requests_count': FieldValue.increment(1),
    }, SetOptions(merge: true));

    try {
      await batch.commit();
      print('Permintaan bantuan berhasil ditambahkan ke Firestore dan counter diupdate!');
    } catch (e) {
      print('Error saat menambahkan permintaan bantuan: $e');
      rethrow;
    }
  }
}