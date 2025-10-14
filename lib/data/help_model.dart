import 'package:cloud_firestore/cloud_firestore.dart';

class HelpData {
  final String id;
  final String title;
  final String location;
  final String purpose;
  final String itemDescription;

  HelpData({
    this.id = '',
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

  factory HelpData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HelpData(
      id: doc.id,
      title: data['title'] as String? ?? 'No Title',
      location: data['location'] as String? ?? 'No Location',
      purpose: data['purpose'] as String? ?? 'No Purpose',
      itemDescription: data['itemDescription'] as String? ?? 'No Description',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'needs': purpose,
      'description': itemDescription,
      'location': location,
    };
  }
}