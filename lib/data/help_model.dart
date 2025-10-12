import 'package:cloud_firestore/cloud_firestore.dart';

class HelpData {
  final String title;
  final String location;
  final String purpose;
  final String itemDescription;

  HelpData({
    required this.title,
    required this.location,
    required this.purpose,
    required this.itemDescription,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'location': location,
      'purpose': purpose,
      'itemDescription': itemDescription,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}