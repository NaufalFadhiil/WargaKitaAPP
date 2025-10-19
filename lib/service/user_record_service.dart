import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<int> _getCounter(String field) async {
    if (_currentUid.isEmpty) return 0;
    try {
      final snapshot = await _firestore.collection('users').doc(_currentUid).get();
      if (snapshot.exists) {
        return snapshot.data()?[field] as int? ?? 0;
      }
      return 0;
    } catch (e) {
      print('Error getting activity counter for $field: $e');
      return 0;
    }
  }

  Future<int> getCreatedActivitiesCount() async {
    return _getCounter('created_activities_count');
  }

  Future<int> getJoinedActivitiesCount() async {
    return _getCounter('joined_activities_count');
  }

  Future<int> getCreatedHelpRequestsCount() async {
    return _getCounter('created_help_requests_count');
  }

  Future<int> getHelpedRequestsCount() async {
    return _getCounter('helped_requests_count');
  }
}