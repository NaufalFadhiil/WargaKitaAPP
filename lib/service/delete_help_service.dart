import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteHelpService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteHelpRequest(String helpId) async {
    if (helpId.isEmpty) {
      throw Exception("Help ID tidak boleh kosong.");
    }
    try {
      await _firestore.collection('help_requests').doc(helpId).delete();
      print('Permintaan bantuan $helpId berhasil dihapus dari Firestore.');
    } catch (e) {
      print('Error saat menghapus permintaan bantuan: $e');
      rethrow;
    }
  }
}