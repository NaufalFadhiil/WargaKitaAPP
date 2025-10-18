import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HelpData {
  final String id;
  final String title;
  final String location;
  final String purpose;
  final String itemDescription;
  final String creatorUid;
  final List<String> helpersUids;

  HelpData({
    this.id = '',
    required this.title,
    required this.location,
    required this.purpose,
    required this.itemDescription,
    String? creatorUid,
    this.helpersUids = const [],
  }) : this.creatorUid = creatorUid ?? FirebaseAuth.instance.currentUser?.uid ?? 'dummy_uid';

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'location': location,
      'purpose': purpose,
      'itemDescription': itemDescription,
      'creatorUid': creatorUid,
      'helpersUids': helpersUids,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory HelpData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final List<String> helpers = (data['helpersUids'] is List)
        ? List<String>.from(data['helpersUids'])
        : [];

    return HelpData(
      id: doc.id,
      title: data['title'] as String? ?? 'No Title',
      location: data['location'] as String? ?? 'No Location',
      purpose: data['purpose'] as String? ?? 'No Purpose',
      itemDescription: data['itemDescription'] as String? ?? 'No Description',
      creatorUid: data['creatorUid'] as String? ?? 'dummy_uid',
      helpersUids: helpers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'needs': purpose,
      'description': itemDescription,
      'location': location,
      'creatorUid': creatorUid,
      'helpersUids': helpersUids,
    };
  }
}