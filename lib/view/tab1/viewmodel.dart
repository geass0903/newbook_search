import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newbook_search/util/event.dart';
import 'package:newbook_search/class/itemnewbook.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;

class Tab1ViewModel extends ChangeNotifier {

  final _eventController = StreamController<Event>();
  StreamController<Event> get eventController => _eventController;

  String? _infoText;
  String get infoText => _infoText ?? '';

  final List<NewBook> _newbookList = [];
  List<NewBook> get newbookList => _newbookList;

  void reload() async {
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _eventController.close();
  }


  Future<void> loadNewBooks(User? user) async {
    _eventController.sink.add(Event.showProgress);

    try {
      String _idToken = await user?.getIdToken(true) ?? '';
      var headers = {
        'Authorization': 'Bearer ' + _idToken,
      };
      var url = 'https://asia-northeast1-newbook-search.cloudfunctions.net/getNewBooks';
      var response = await http.get(Uri.parse(url), headers: headers).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          return http.Response('', html.HttpStatus.networkConnectTimeoutError);
        }
      );

      switch (response.statusCode) {
        case html.HttpStatus.ok:
          var res = json.decode(response.body);
          if(res['result'] == 'success') {
            var books = res['newBooks'];
            List<NewBook> tmpListNewBook = [];
            for(Map book in books) {
              NewBook newBook = NewBook(
                isbn: book["isbn"],
                title: book["title"],
                author: book["author"],
                publisher: book["publisher"],
                salesDate: book["sales_date"],
                imageUrl: book["image_url"]
              );
              tmpListNewBook.add(newBook);
            }
            _newbookList.clear();
            _newbookList.addAll(tmpListNewBook);
            _newbookList.sort(((a, b) => a.compareTo(b)));
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


}