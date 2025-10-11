import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
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
}