import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteActivity(String activityId) async {
    if (activityId.isEmpty) {
      throw Exception("Activity ID tidak boleh kosong.");
    }
    try {
      await _firestore.collection('activities').doc(activityId).delete();
      print('Aktivitas $activityId berhasil dihapus dari Firestore.');
    } catch (e) {
      print('Error saat menghapus aktivitas: $e');
      rethrow;
    }
  }
}