import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemNewBook extends Container {
  ItemNewBook({Key? key, required NewBook newBook}) : super(key: key, 
    height: 100.0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 100.0,
          height: 100.0,
          child: Builder(
            builder: (BuildContext context) {
              if (newBook.imageUrl != null) {
                return Image.network(newBook.imageUrl!);
              }
              return Container();
            },
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 新刊表示
              Builder(
                builder: (BuildContext context) {
                  if (newBook.isnew != null && newBook.isnew! == true) {
                    return Container(
                      height: 20,
                      padding: const EdgeInsets.fromLTRB(10.0, 2.5, 10.0, 2.5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.red,
                      ),
                      child: const Text(
                        "New",
                        style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.normal, color: Colors.white),
                      ),
                    );
                  }
                  return Container();
                },
              ),
              // タイトル
              Text(
                'タイトル：' + (newBook.title ?? ''),
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              // 著者
              Text(
                '著者：' + (newBook.author ?? ''),
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // 発売日
              Text(
                '発売日：' + (newBook.salesDate ?? ''),
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// NewBookクラス
class NewBook {

  final String? isbn;
  final String? title;
  final String? author;
  final String? publisher;
  final String? salesDate;
  final String? imageUrl;
  final bool? isnew;

  NewBook({
    this.isbn,
    this.title,
    this.author,
    this.publisher,
    this.salesDate,
    this.imageUrl,
    this.isnew,
  });

  @override
  String toString() {
    return '$isbn, $title, $author, $publisher, $salesDate, $isnew';
  }

  String formattedDate(String salesDate) {
    DateFormat format = DateFormat('yyyy-MM-dd');
    var regexp = RegExp(r'([0-9]+)年([0-9]+)月([0-9]+)日.*$');
    if(regexp.hasMatch(salesDate)) {
      var formatted = salesDate.replaceAllMapped(regexp, (match) {
        return '${match.group(1)}-${match.group(2)}-${match.group(3)}';
      });
      return formatted;
    }
    regexp = RegExp(r'([0-9]+)年([0-9]+)月.*$');
    if(regexp.hasMatch(salesDate)) {
      var formatted = salesDate.replaceAllMapped(regexp, (match) {
        return '${match.group(1)}-${match.group(2)}-01';
      });
      var date = format.parse(formatted);
      DateTime lastDay = DateTime(date.year, date.month + 1, 1).add(const Duration(days: -1));
      formatted = format.format(lastDay);
      return formatted;
    }
    regexp = RegExp(r'([0-9]+)年.*$');
    if(regexp.hasMatch(salesDate)) {
      var formatted = salesDate.replaceAllMapped(regexp, (match) {
        return '${match.group(1)}-12-31';
      });
      return formatted;
    }
    DateTime now = DateTime.now();
    String date = format.format(now);
    return date;
  }


  int compareTo(NewBook other) {
    DateFormat format = DateFormat('yyyy-MM-dd');
    var dt1 = format.parse(formattedDate(salesDate ?? ''));
    var dt2 = format.parse(formattedDate(other.salesDate ?? ''));
    debugPrint(salesDate);
    debugPrint(other.salesDate);
    return -dt1.compareTo(dt2);
  }

  factory NewBook.fromJson(Map<String, dynamic> json) {
    return NewBook(
      isbn: json['isbn'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      publisher: json['publisher'] as String,
      salesDate: json['salesDate'] as String,
      imageUrl: json['imageUrl'] as String,
      isnew: (json['isnew']? json['isnew'] : false) as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'isbn': isbn,
    'title': title,
    'author': author,
    'publisher': publisher,
    'salesDate': salesDate,
    'imageUrl': imageUrl,
    'isnew': isnew,
  };

  @override
  bool operator ==(Object other) {
    return other is NewBook &&
        isbn == other.isbn &&
        title == other.title &&
        author == other.author &&
        publisher == other.publisher &&
        salesDate == other.salesDate &&
        imageUrl == other.imageUrl &&
        isnew == other.isnew
    ;
  }

  @override
  int get hashCode =>
      isbn.hashCode ^ title.hashCode ^ author.hashCode ^ publisher
          .hashCode ^ salesDate.hashCode ^ imageUrl.hashCode ^ isnew.hashCode;

}