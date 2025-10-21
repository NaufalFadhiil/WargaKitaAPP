import 'dart:async';
import 'package:flutter/material.dart';
import '../data/activity_model.dart';
import '../service/display_activity_service.dart';

class ActivityProvider extends ChangeNotifier {
  final DisplayActivityService _service = DisplayActivityService();
  List<ActivityModel> _activities = [];
  bool _isLoading = true;
  StreamSubscription? _activitySubscription;

  List<ActivityModel> get activities => _activities;
  bool get isLoading => _isLoading;

  void initializeStream(String uid) {
    _activitySubscription?.cancel();
    if (uid.isEmpty) {
      _activities = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();
    _activitySubscription = _service.streamAllActivities().listen((activityList) {
      _activities = activityList;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      debugPrint('Error streaming activities: $e');
      _activities = [];
      _isLoading = false;
      notifyListeners();
    });
  }

  ActivityModel getActivityById(String id) {
    return _activities.firstWhere(
          (activity) => activity.id == id,
      orElse: () => ActivityModel(
        title: 'Not Found',
        date: '-',
        time: '-',
        location: 'Not Found',
        neededVolunteers: '0',
        description: 'Not Found',
        requiredAid: 'Not Found',
        goal: 'Not Found',
        whatsappLink: '',
        notes: '',
      ),
    );
  }

  @override
  void dispose() {
    _activitySubscription?.cancel();
    super.dispose();
  }
}