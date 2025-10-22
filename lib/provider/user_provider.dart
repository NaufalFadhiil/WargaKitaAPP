import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../service/user_service.dart';
import '../service/user_record_service.dart';

class UserData {
  final String username;
  final String phoneNumber;
  final Map<String, int> counters;

  UserData({
    required this.username,
    required this.phoneNumber,
    required this.counters,
  }) : assert(username.isNotEmpty);

  static UserData get initial => UserData(
    username: 'Memuat...',
    phoneNumber: 'Memuat...',
    counters: {
      'created_activity': 0,
      'joined_activity': 0,
      'created_help': 0,
      'helped_help': 0,
    },
  );
}

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  final UserActivityService _activityService = UserActivityService();
  StreamSubscription<User?>? _authStateSubscription;

  String _currentUid = '';
  UserData _userData = UserData.initial;
  bool _isLoading = true;

  UserData get userData => _userData;
  bool get isLoading => _isLoading;
  String get currentUid => _currentUid;

  UserProvider() {
    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _currentUid = user.uid;
        _loadUserData();
      } else {
        _currentUid = '';
        _resetUserData();
      }
    });
  }

  void _resetUserData() {
    _userData = UserData.initial;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadUserData() async {
    _isLoading = true;
    notifyListeners();

    if (_currentUid.isEmpty) {
      _resetUserData();
      return;
    }

    try {
      final data = await _userService.getUserData(_currentUid);
      final counterResults = await Future.wait([
        _activityService.getCreatedActivitiesCount(_currentUid),
        _activityService.getJoinedActivitiesCount(_currentUid),
        _activityService.getCreatedHelpRequestsCount(_currentUid),
        _activityService.getHelpedRequestsCount(_currentUid),
      ]);

      _userData = UserData(
        username: data['username'] ?? 'Pengguna Tidak Ditemukan',
        phoneNumber: data['phoneNumber'] ?? 'Nomor Tidak Tersedia',
        counters: {
          'created_activity': counterResults[0],
          'joined_activity': counterResults[1],
          'created_help': counterResults[2],
          'helped_help': counterResults[3],
        },
      );
    } catch (e) {
      debugPrint('Error loading user data: $e');
      _userData = UserData.initial.copyWith(
        username: 'Error Memuat',
        phoneNumber: 'Error Memuat',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUserData() async {
    await _loadUserData();
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}

extension on UserData {
  UserData copyWith({String? username, String? phoneNumber, Map<String, int>? counters}) {
    return UserData(
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      counters: counters ?? this.counters,
    );
  }
}