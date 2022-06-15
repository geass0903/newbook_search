import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newbook_search/util/event.dart';
import 'package:newbook_search/util/uistate.dart';

class SignInViewModel extends ChangeNotifier {

  final _eventController = StreamController<Event>();
  StreamController<Event> get eventController => _eventController;

  UiState _progressState = UiState.idle;
  UiState get progressState => _progressState;

  String _progressText = '';
  String get progressText => _progressText;

  String? _infoText;
  String get infoText => _infoText ?? '';

  Future<void> reload() async {
    notifyListeners();
  }

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

  Future<void> signUp(String email, String password) async {
    showProgressIndicator();
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _infoText = '';
      _eventController.sink.add(Event.signUp);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _infoText = e.message;
      _eventController.sink.add(Event.signUpError);
      notifyListeners();
    }
    dismissProgressIndicator();
  }


  Future<void> signIn(String email, String password) async {
    showProgressIndicator();
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _eventController.sink.add(Event.success);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _infoText = e.message;
      _eventController.sink.add(Event.error);
      notifyListeners();
    }
    dismissProgressIndicator();
  }

  @override
  void dispose() {
    super.dispose();
    _eventController.close();
  }

}