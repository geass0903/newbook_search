import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newbook_search/class/itemkeyword.dart';
import 'package:newbook_search/util/event.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;

class Tab2ViewModel extends ChangeNotifier {

  static const String keyKeywords = "Keywords";

  final _eventController = StreamController<Event>();
  StreamController<Event> get eventController => _eventController;

  String? _infoText;
  String get infoText => _infoText ?? '';

  final List<Keyword> _keywordList = [];
  List<Keyword> get keywordList => _keywordList;


  void reload() async {
    notifyListeners();
  }


  @override
  void dispose() {
    super.dispose();
    _eventController.close();
  }


  Future<List<Keyword>> loadStorage() async {
    var _localStorage = html.window.localStorage;
    var keywords = _localStorage[keyKeywords];
    if(keywords != null && keywords.isNotEmpty) {
      var parsed = json.decode(keywords);
      List<Keyword> list = [];
      for(Map<String, dynamic> json in parsed) {
        list.add(Keyword.fromJson(json));
      }
      return list;
    }
    return [];
  }

  Future<void> saveStorage(List<Keyword> keywords) async {
    var _localStorage = html.window.localStorage;
    List<Map> encoder = [];
    for (Keyword keyword in keywords) {
      encoder.add(keyword.toJson());
    }
    _localStorage[keyKeywords] = json.encode(encoder);
  }


  Future<void> loadKeywords() async {
    _eventController.sink.add(Event.showProgress);
    var keywords = await loadStorage();
    _keywordList.clear();
    _keywordList.addAll(keywords);
    _keywordList.sort(((a, b) => a.compareTo(b)));
    notifyListeners();
    _eventController.sink.add(Event.dismissProgress);
  }

  Future<void> getKeywords(User? user) async {
    _eventController.sink.add(Event.showProgress);
    try {
      String _idToken = await user?.getIdToken(true) ?? '';
      var headers = {
        'Authorization': 'Bearer ' + _idToken,
      };
      var url = 'https://us-central1-newbook-search.cloudfunctions.net/getKeywords';
      var response = await http.get(Uri.parse(url), headers: headers).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          return http.Response('', html.HttpStatus.networkConnectTimeoutError);
        }
      );

      switch (response.statusCode) {
        case html.HttpStatus.ok:
          var res = json.decode(response.body);
          if(res['result'] == 'success') {
            var keywords = res['keywords'];
            List<Keyword> _tmpListKeyword = [];
            for(Map item in keywords) {
              Keyword keyword = Keyword(
                id: item['id'],
                keyword: item['keyword'],
                searchType: item['search_type']
              );
              _tmpListKeyword.add(keyword);
            }
            _keywordList.clear();
            _keywordList.addAll(_tmpListKeyword);
            _keywordList.sort(((a, b) => a.compareTo(b)));
            saveStorage(_keywordList);
            _eventController.sink.add(Event.success);
          } else {
            _infoText = res['msg'];
            _eventController.sink.add(Event.error);
          }
          break;
        default:
          debugPrint(response.body);
          _infoText = '通信エラー';
          _eventController.sink.add(Event.error);
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      _infoText = '通信エラー';
      _eventController.sink.add(Event.error);
    }
    notifyListeners();
    _eventController.sink.add(Event.dismissProgress);
  }



  Future<void> saveKeyword(User? user, Keyword keyword, int index) async {
    _eventController.sink.add(Event.showProgress);
    try {
      String _idToken = await user?.getIdToken(true) ?? '';
      var headers = {
        'Authorization': 'Bearer ' + _idToken,
      };
      var body = {
        'id': keyword.id?.toString() ?? '',
        'keyword': keyword.keyword ?? '',
        'search_type': keyword.searchType?.toString() ?? '1',
      };
      var url = 'https://us-central1-newbook-search.cloudfunctions.net/setKeyword';
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
            var keyword = res['keyword'];
            Keyword newKeyword = Keyword(
              id: keyword['id'],
              keyword: keyword['keyword'],
              searchType: keyword['search_type'],
            );
            if(index != -1) {
              _keywordList[index] = newKeyword;
            } else {
              _keywordList.add(newKeyword);
            }
            _keywordList.sort(((a, b) => a.compareTo(b)));
            _eventController.sink.add(Event.success);
          } else {
            _infoText = res['msg'];
            _eventController.sink.add(Event.error);
          }
          break;
        default:
          _infoText = '通信エラー';
          _eventController.sink.add(Event.error);
          debugPrint(response.body);
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      _infoText = '通信エラー';
      _eventController.sink.add(Event.error);
    }
    notifyListeners();
    _eventController.sink.add(Event.dismissProgress);
  }

  Future<void> deleteKeyword(User? user, Keyword keyword, int index) async {
    _eventController.sink.add(Event.showProgress);
    try {
      String _idToken = await user?.getIdToken(true) ?? '';
      var headers = {
        'Authorization': 'Bearer ' + _idToken,
      };
      var body = {
        'id': keyword.id ?? '',
        'keyword': keyword.keyword ?? '',
        'search_type': keyword.searchType ?? "1",
      };
      var url = 'https://us-central1-newbook-search.cloudfunctions.net/deleteKeyword';
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
            _keywordList.removeAt(index);
            _eventController.sink.add(Event.delete);
          } else {
            _infoText = res['msg'];
            _eventController.sink.add(Event.error);
          }
          break;
        default:
          _infoText = '通信エラー';
          _eventController.sink.add(Event.error);
          debugPrint(response.body);
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      _infoText = '通信エラー';
      _eventController.sink.add(Event.error);
    }
    notifyListeners();
    _eventController.sink.add(Event.dismissProgress);
  }

}