import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ActivityModel {
  final String id;
  final String title;
  final String date;
  final String time;
  final String location;
  final String neededVolunteers;
  final String description;
  final String requiredAid;
  final String goal;
  final String whatsappLink;
  final String notes;
  final String creatorUid;
  final int currentVolunteers;
  final List<String> participantsUids;

  ActivityModel({
    this.id = '',
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.neededVolunteers,
    required this.description,
    required this.requiredAid,
    required this.goal,
    required this.whatsappLink,
    required this.notes,
    String? creatorUid,
    this.currentVolunteers = 0,
    this.participantsUids = const [],
  }) : creatorUid = creatorUid ?? FirebaseAuth.instance.currentUser?.uid ?? '';

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'date': date,
      'time': time,
      'location': location,
      'neededVolunteers': int.tryParse(neededVolunteers) ?? 0,
      'description': description,
      'requiredAid': requiredAid,
      'goal': goal,
      'whatsappLink': whatsappLink,
      'notes': notes,
      'creatorUid': creatorUid,
      'currentVolunteers': currentVolunteers,
      'participantsUids': participantsUids,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory ActivityModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final List<String> participants = (data['participantsUids'] is List)
        ? List<String>.from(data['participantsUids'])
        : [];

    return ActivityModel(
      id: doc.id,
      title: data['title'] as String? ?? 'No Title',
      date: data['date'] as String? ?? 'No Date',
      time: data['time'] as String? ?? 'No Time',
      location: data['location'] as String? ?? 'No Location',
      neededVolunteers: (data['neededVolunteers'] as dynamic)?.toString() ?? '0',
      description: data['description'] as String? ?? 'No Description',
      requiredAid: data['requiredAid'] as String? ?? 'No Aid',
      goal: data['goal'] as String? ?? 'No Goal',
      whatsappLink: data['whatsappLink'] as String? ?? '',
      notes: data['notes'] as String? ?? '',
      creatorUid: data['creatorUid'] as String? ?? 'dummy_uid',
      currentVolunteers: data['currentVolunteers'] as int? ?? 0,
      participantsUids: participants,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': description,
      'date': date,
      'time': time,
      'location': location,
      'neededVolunteers': neededVolunteers,
      'description': description,
      'requiredAid': requiredAid,
      'goal': goal,
      'whatsappLink': whatsappLink,
      'notes': notes,
      'creatorUid': creatorUid,
      'currentVolunteers': currentVolunteers,
      'participantsUids': participantsUids,
    };
  }
}