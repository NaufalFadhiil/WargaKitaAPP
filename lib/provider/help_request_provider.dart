import 'dart:async';
import 'package:flutter/material.dart';
import '../data/help_model.dart';
import '../service/display_help_service.dart';

class HelpRequestProvider extends ChangeNotifier {
  final DisplayHelpService _service = DisplayHelpService();
  List<HelpData> _helpRequests = [];
  bool _isLoading = true;
  StreamSubscription? _helpSubscription;

  List<HelpData> get helpRequests => _helpRequests;
  bool get isLoading => _isLoading;

  void initializeStream(String uid) {
    _helpSubscription?.cancel();
    if (uid.isEmpty) {
      _helpRequests = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();
    _helpSubscription = _service.streamAllHelpRequests().listen((helpList) {
      _helpRequests = helpList;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      debugPrint('Error streaming help requests: $e');
      _helpRequests = [];
      _isLoading = false;
      notifyListeners();
    });
  }

  HelpData getHelpRequestById(String id) {
    return _helpRequests.firstWhere(
          (help) => help.id == id,
      orElse: () => HelpData(
        title: 'Not Found',
        location: 'Not Found',
        purpose: 'No Purpose',
        itemDescription: 'No Description',
      ),
    );
  }

  @override
  void dispose() {
    _helpSubscription?.cancel();
    super.dispose();
  }
}