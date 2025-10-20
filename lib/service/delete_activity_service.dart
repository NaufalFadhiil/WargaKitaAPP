import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DeleteActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteActivity(String activityId) async {
    if (activityId.isEmpty) {
      throw Exception("Activity ID tidak boleh kosong.");
    }
    try {
      await _firestore.collection('activities').doc(activityId).delete();
      debugPrint('Aktivitas $activityId berhasil dihapus dari Firestore.');
    } catch (e) {
      debugPrint('Error saat menghapus aktivitas: $e');
      rethrow;
    }
  }
}