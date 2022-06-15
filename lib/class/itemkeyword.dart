import 'package:flutter/material.dart';

class ItemKeyword extends Container {
  ItemKeyword({Key? key, required Keyword keyword}) : super(key: key, 
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: Text(keyword.keyword ?? '',
                      style: const TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500,),
                      strutStyle: const StrutStyle(
                        fontSize: 16.0,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      textScaleFactor: 1.0,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    '検索タイプ：',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                    strutStyle: StrutStyle(
                      fontSize: 14.0,
                      height: 1.6,
                    ),
                    textScaleFactor: 1.0,
                  ),
                  Flexible(
                    child: Text(Keyword.searchTypes[keyword.searchType] ?? '',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                      strutStyle: const StrutStyle(
                        fontSize: 14.0,
                        height: 1.6,
                      ),
                      maxLines: 1,
                      textScaleFactor: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Keywordクラス
class Keyword {
  final String? id;
  final String? keyword;
  final String? searchType;

  static const String searchTypes1 = "1";
  static const String searchTypes2 = "2";
  static const String searchTypes3 = "3";
  static const String searchTypes1Label = 'キーワード';
  static const String searchTypes2Label = 'タイトル';
  static const String searchTypes3Label = '著者';

  static const searchTypes = {
    searchTypes1: searchTypes1Label,
    searchTypes2: searchTypes2Label,
    searchTypes3: searchTypes3Label,
  };

  Keyword({
    this.id,
    this.keyword,
    this.searchType,
  });

  @override
  String toString() {
    return '$id, $keyword, $searchType';
  }

  int compareTo(Keyword other) {
    var ky1 = keyword ?? '';
    var ky2 = other.keyword ?? '';
    return ky1.compareTo(ky2);
  }

  @override
  bool operator ==(Object other) {
    return other is Keyword &&
      id == other.id &&
      keyword == other.keyword &&
      searchType == other.searchType
    ;
  }

  @override
  int get hashCode =>
      id.hashCode ^ keyword.hashCode ^ searchType.hashCode;

}

