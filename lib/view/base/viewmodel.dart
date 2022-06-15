import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newbook_search/util/uistate.dart';
import 'package:newbook_search/util/event.dart';

class BaseViewModel extends ChangeNotifier {

  final _eventController = StreamController<Event>();
  StreamController<Event> get eventController => _eventController;

  UiState _progressState = UiState.idle;
  UiState get progressState => _progressState;

  String _progressText = '';
  String get progressText => _progressText;

  User? _user;
  User? get user => _user;

  void showProgressIndicator() {
    _progressText = '';
    _progressState = UiState.busy;
    notifyListeners();
  }

  void dismissProgressIndicator() {
    _progressText = '';
    _progressState = UiState.idle;
    notifyListeners();
  }

  void updateProgressText(String text) {
    _progressText = text;
    notifyListeners();
  }

  void setUser(User? user) {
    _user = user;
  }

  Future<void> reload() async {
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _eventController.close();
  }

}