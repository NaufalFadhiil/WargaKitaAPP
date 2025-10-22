import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getCounter(String uid, String field) async {
    if (uid.isEmpty) return 0;
    try {
      final snapshot = await _firestore.collection('users').doc(uid).get();
      if (snapshot.exists) {
        return snapshot.data()?[field] as int? ?? 0;
      }
      return 0;
    } catch (e) {
      debugPrint('Error getting activity counter for $field: $e');
      return 0;
    }
  }

  Future<int> getCreatedActivitiesCount(String uid) async {
    return _getCounter(uid, 'created_activities_count');
  }

  Future<int> getJoinedActivitiesCount(String uid) async {
    return _getCounter(uid, 'joined_activities_count');
  }

  Future<int> getCreatedHelpRequestsCount(String uid) async {
    return _getCounter(uid, 'created_help_requests_count');
  }

  Future<int> getHelpedRequestsCount(String uid) async {
    return _getCounter(uid, 'helped_requests_count');
  }
}