import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/help_model.dart';

class DisplayHelpService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<HelpData>> streamAllHelpRequests() {
    return _firestore.collection('help_requests').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return HelpData.fromFirestore(doc);
      }).toList();
    });
  }
}