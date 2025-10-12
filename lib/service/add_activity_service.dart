import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/activity_model.dart';

class AddActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addActivity(ActivityModel ActivityModel) async {
    try {
      await _firestore.collection('activities').add(ActivityModel.toFirestore());
      print('Aktivitas berhasil ditambahkan ke Firestore!');
    } catch (e) {
      print('Error saat menambahkan aktivitas: $e');
      rethrow;
    }
  }
}