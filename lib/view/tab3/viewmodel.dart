import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:newbook_search/firebase_options.dart';
import 'package:newbook_search/util/event.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;


class Tab3ViewModel extends ChangeNotifier {

  static const String keyNewBooks = "NewBooks";
  static const String keyKeywords = "Keywords";


  final _eventController = StreamController<Event>();
  StreamController<Event> get eventController => _eventController;

  String? _infoText;
  String get infoText => _infoText ?? '';

  void reload() async {
    notifyListeners();
  }


  @override
  void dispose() {
    super.dispose();
    _eventController.close();
  }

  Future<void> signOut() async {
    _eventController.sink.add(Event.showProgress);
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      await Future.delayed(const Duration(seconds: 1));
      await auth.signOut();

      var _localStorage = html.window.localStorage;
      _localStorage.remove(keyNewBooks);
      _localStorage.remove(keyKeywords);
      _eventController.sink.add(Event.signOut);
    } on FirebaseAuthException catch (e) {
      _infoText = e.message;
      _eventController.sink.add(Event.signOutError);
    } on Exception catch (e) {
      debugPrint(e.toString());
      _infoText = '通信エラー';
      _eventController.sink.add(Event.signOutError);
    }
    notifyListeners();
    _eventController.sink.add(Event.dismissProgress);
  }

  Future<void> registerPushToken(User? user) async {
    _eventController.sink.add(Event.showProgress);
    try {
      String _idToken = await user?.getIdToken(true) ?? '';
      //トークン取得
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? pushToken = await messaging.getToken(vapidKey: vapidKey);
      if(pushToken != null) {
        var headers = {
          'Authorization': 'Bearer ' + _idToken,
        };
        var body = {
          'pushToken': pushToken,
        };
        var url = 'https://us-central1-newbook-search.cloudfunctions.net/setPushToken';
        var response = await http.post(Uri.parse(url), body: body, headers: headers).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            return http.Response('', html.HttpStatus.networkConnectTimeoutError);
          }
        );
        switch (response.statusCode) {
          case html.HttpStatus.ok:
            var res = json.decode(response.body);
            if(res['result'] == 'success') {
              _eventController.sink.add(Event.register);
            } else {
              _infoText = res['msg'];
              _eventController.sink.add(Event.registerError);
            }
            break;
          default:
            debugPrint('debug: ${response.body}');
            _infoText = '通信エラー';
            _eventController.sink.add(Event.registerError);
        }
      } else {
        _eventController.sink.add(Event.registerError);
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      _infoText = '通信エラー';
      _eventController.sink.add(Event.registerError);
    }
    notifyListeners();
    _eventController.sink.add(Event.dismissProgress);
  }

  Future<void> pushTest(User? user) async {
    _eventController.sink.add(Event.showProgress);
    try {
      String _idToken = await user?.getIdToken(true) ?? '';
      //トークン取得
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? pushToken = await messaging.getToken(vapidKey: vapidKey);
      if(pushToken != null) {
        var headers = {
          'Authorization': 'Bearer ' + _idToken,
        };
        var body = {
          'pushToken': pushToken,
        };
        var url = 'https://us-central1-newbook-search.cloudfunctions.net/testPushNotification';
        var response = await http.post(Uri.parse(url), body: body, headers: headers).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            return http.Response('', html.HttpStatus.networkConnectTimeoutError);
          }
        );
        switch (response.statusCode) {
          case html.HttpStatus.ok:
            var res = json.decode(response.body);
            if(res['result'] == 'success') {
              _eventController.sink.add(Event.push);
            } else {
              _infoText = res['msg'];
              _eventController.sink.add(Event.pushError);
            }
            break;
          default:
            debugPrint('debug: ${response.body}');
            _infoText = '通信エラー';
            _eventController.sink.add(Event.pushError);
        }
      } else {
        _eventController.sink.add(Event.pushError);
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      _infoText = '通信エラー';
      _eventController.sink.add(Event.registerError);
    }
    notifyListeners();
    _eventController.sink.add(Event.dismissProgress);
  }

}