import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/help_model.dart';

class AddHelpService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addHelpRequest(HelpData helpData) async {
    try {
      await _firestore.collection('help_requests').add(helpData.toFirestore());
      print('Permintaan bantuan berhasil ditambahkan ke Firestore!');
    } catch (e) {
      print('Error saat menambahkan permintaan bantuan: $e');
      rethrow;
    }
  }
}