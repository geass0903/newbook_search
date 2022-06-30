import 'dart:convert';
import 'dart:typed_data';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:newbook_search/class/itemnewbook.dart';


class DetailNewBookDialog extends StatefulWidget {
  final NewBook? newBook;

  const DetailNewBookDialog({Key? key, this.newBook}) : super(key: key);

  @override
  _DetailNewBookDialogState createState() => _DetailNewBookDialogState();


  static Future show({required BuildContext context, bool barrierDismissible=true, required NewBook newBook}) {
    return showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          return DetailNewBookDialog(newBook: newBook);
        },
    );
  }
}

class _DetailNewBookDialogState extends State<DetailNewBookDialog> {
  NewBook? newBook;

  @override
  void initState() {
    super.initState();
    newBook = widget.newBook;
  }

  @override
  Widget build(BuildContext context) {
    String isbn = "";
    String imageUrl = "";

    if(newBook != null && newBook!.isbn != null) {
      isbn = newBook!.isbn!;
    }
    if(newBook != null && newBook!.imageUrl != null) {
      imageUrl = newBook!.imageUrl!;
    }
    return AlertDialog(
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: 300,
            height: 420,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.network(
                  imageUrl,
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
                BarcodeWidget(
                  barcode: Barcode.isbn(), 
                  data: isbn,
                  width: 300,
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

}