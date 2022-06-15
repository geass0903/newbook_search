import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newbook_search/util/event.dart';

class MyAppViewModel extends ChangeNotifier {

  User? _user;
  User? get user => _user;

  final _eventController = StreamController<Event>();

  StreamController<Event> get eventController => _eventController;

  void reload() async {
    notifyListeners();
  }


  @override
  void dispose() {
    super.dispose();
    _eventController.close();
  }

  Future<void> setUser(User? user) async {
    _user = user;
  }

}