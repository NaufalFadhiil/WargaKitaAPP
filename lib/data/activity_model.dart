import 'package:cloud_firestore/cloud_firestore.dart';

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
  });

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
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Factory constructor to create an ActivityModel from a Firestore DocumentSnapshot
  factory ActivityModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ActivityModel(
      id: doc.id,
      title: data['title'] as String? ?? 'No Title',
      date: data['date'] as String? ?? 'No Date',
      time: data['time'] as String? ?? 'No Time',
      location: data['location'] as String? ?? 'No Location',
      neededVolunteers: (data['neededVolunteers'] as int? ?? 0).toString(),
      description: data['description'] as String? ?? 'No Description',
      requiredAid: data['requiredAid'] as String? ?? 'No Aid',
      goal: data['goal'] as String? ?? 'No Goal',
      whatsappLink: data['whatsappLink'] as String? ?? '',
      notes: data['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': description,
      'date': date,
      'location': location,
      'neededVolunteers': neededVolunteers,
      'description': description,
      'requiredAid': requiredAid,
      'goal': goal,
      'whatsappLink': whatsappLink,
      'notes': notes,
    };
  }
}