import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/activity_model.dart';

class DisplayActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ActivityModel>> streamAllActivities() {
    return _firestore.collection('activities').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ActivityModel.fromFirestore(doc);
      }).toList();
    });
  }
}