
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'タイトル：',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                    strutStyle: StrutStyle(
                      fontSize: 14.0,
                      height: 1.3,
                    ),
                    textScaleFactor: 1.0,
                  ),
                  Flexible(
                    child: Text(newBook.title ?? '',
                      style: const TextStyle(fontSize: 14.0,fontWeight: FontWeight.w500,),
                      strutStyle: const StrutStyle(
                        fontSize: 14.0,
                        height: 1.3,
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
                    '著者：',
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                    strutStyle: StrutStyle(
                      fontSize: 14.0,
                      height: 1.3,
                    ),
                    textScaleFactor: 1.0,
                  ),
                  Flexible(
                    child: Text(newBook.author ?? '',
                      style: const TextStyle(
                        fontSize: 12.0,
                      ),
                      strutStyle: const StrutStyle(
                        fontSize: 14.0,
                        height: 1.3,
                      ),
                      maxLines: 1,
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
                    '発売日：',
                    style: TextStyle(
                      fontSize: 13.0,
                    ),
                    strutStyle: StrutStyle(
                      fontSize: 14.0,
                      height: 1.3,
                    ),
                    textScaleFactor: 1.0,
                  ),
                  Flexible(
                    child: Text(newBook.salesDate ?? '',
                      style: const TextStyle(
                        fontSize: 13.0,
                      ),
                      strutStyle: const StrutStyle(
                        fontSize: 14.0,
                        height: 1.3,
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

// NewBookクラス
class NewBook {

  final String? isbn;
  final String? title;
  final String? author;
  final String? publisher;
  final String? salesDate;
  final String? imageUrl;

  NewBook({
    this.isbn,
    this.title,
    this.author,
    this.publisher,
    this.salesDate,
    this.imageUrl,
  });

  @override
  String toString() {
    return '$isbn, $title, $author, $publisher, $salesDate';
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
    );
  }

  Map<String, dynamic> toJson() => {
    'isbn': isbn,
    'title': title,
    'author': author,
    'publisher': publisher,
    'salesDate': salesDate,
    'imageUrl': imageUrl,
  };

  @override
  bool operator ==(Object other) {
    return other is NewBook &&
        isbn == other.isbn &&
        title == other.title &&
        author == other.author &&
        publisher == other.publisher &&
        salesDate == other.salesDate &&
        imageUrl == other.imageUrl
    ;
  }

  @override
  int get hashCode =>
      isbn.hashCode ^ title.hashCode ^ author.hashCode ^ publisher
          .hashCode ^ salesDate.hashCode ^ imageUrl.hashCode;

}