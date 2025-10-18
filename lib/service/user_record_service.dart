import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<int> getCreatedActivitiesCount() async {
    if (_currentUid.isEmpty) return 0;
    try {
      final snapshot = await _firestore
          .collection('activities')
          .where('creatorUid', isEqualTo: _currentUid)
          .count()
          .get();
      return snapshot.count ?? 0;
    } catch (e) {
      print('Error getting created activities count: $e');
      return 0;
    }
  }

  Future<int> getJoinedActivitiesCount() async {
    if (_currentUid.isEmpty) return 0;
    try {
      final snapshot = await _firestore
          .collection('activities')
          .where('participantsUids', arrayContains: _currentUid)
          .count()
          .get();
      return snapshot.count ?? 0;
    } catch (e) {
      print('Error getting joined activities count: $e');
      return 0;
    }
  }

  Future<int> getCreatedHelpRequestsCount() async {
    if (_currentUid.isEmpty) return 0;
    try {
      final snapshot = await _firestore
          .collection('help_requests')
          .where('creatorUid', isEqualTo: _currentUid)
          .count()
          .get();
      return snapshot.count ?? 0;
    } catch (e) {
      print('Error getting created help requests count: $e');
      return 0;
    }
  }

  Future<int> getHelpedRequestsCount() async {
    if (_currentUid.isEmpty) return 0;
    try {
      final snapshot = await _firestore
          .collection('help_requests')
          .where('helpersUids', arrayContains: _currentUid)
          .count()
          .get();
      return snapshot.count ?? 0;
    } catch (e) {
      print('Error getting helped requests count: $e');
      return 0;
    }
  }
}