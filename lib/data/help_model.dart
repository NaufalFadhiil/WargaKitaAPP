import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HelpData {
  final String id;
  final String title;
  final String location;
  final String purpose;
  final String itemDescription;
  final String creatorUid;
  final String phoneNumber;

  HelpData({
    this.id = '',
    required this.title,
    required this.location,
    required this.purpose,
    required this.itemDescription,
    String? creatorUid,
    this.phoneNumber = '6281234567890',
  }) : this.creatorUid = creatorUid ?? FirebaseAuth.instance.currentUser?.uid ?? 'dummy_uid';

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'location': location,
      'purpose': purpose,
      'itemDescription': itemDescription,
      'creatorUid': creatorUid,
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
      creatorUid: data['creatorUid'] as String? ?? 'dummy_uid',
      phoneNumber: '6281234567890',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'needs': purpose,
      'description': itemDescription,
      'location': location,
      'creatorUid': creatorUid,
      'phoneNumber': phoneNumber,
    };
  }
}