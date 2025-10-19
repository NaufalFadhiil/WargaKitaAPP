import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/activity_model.dart';

class AddActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> addActivity(ActivityModel activityModel) async {
    if (_currentUid.isEmpty) {
      throw Exception("Pengguna tidak terautentikasi.");
    }

    final batch = _firestore.batch();

    final newActivityRef = _firestore.collection('activities').doc();
    batch.set(newActivityRef, activityModel.toFirestore());

    final userRef = _firestore.collection('users').doc(_currentUid);
    batch.set(userRef, {
      'created_activities_count': FieldValue.increment(1),
    }, SetOptions(merge: true));

    try {
      await batch.commit();
      print('Aktivitas berhasil ditambahkan ke Firestore dan counter diupdate!');
    } catch (e) {
      print('Error saat menambahkan aktivitas: $e');
      rethrow;
    }
  }
}