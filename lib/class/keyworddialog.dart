import 'package:flutter/material.dart';
import 'package:newbook_search/class/itemkeyword.dart';


class KeywordDialog extends StatefulWidget {
  final List<Keyword>? list;
  final Keyword? keyword;

  const KeywordDialog({Key? key, this.keyword, this.list}) : super(key: key);

  @override
  _KeywordDialogState createState() => _KeywordDialogState();


  static Future show({required BuildContext context, bool barrierDismissible=true, Keyword? keyword, List<Keyword>? list}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return KeywordDialog(keyword: keyword, list: list);
        },
    );
  }
}

class _KeywordDialogState extends State<KeywordDialog> {
  final keywordController = TextEditingController();
  String? searchType = "1";

  var dropdownItem = [
    const DropdownMenuItem(
      child: Text(Keyword.searchTypes1Label),
      value: Keyword.searchTypes1,
    ),
    const DropdownMenuItem(
      child: Text(Keyword.searchTypes2Label),
      value: Keyword.searchTypes2,
    ),
    const DropdownMenuItem(
      child: Text(Keyword.searchTypes3Label),
      value: Keyword.searchTypes3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    keywordController.text = widget.keyword?.keyword ?? '';
    searchType = widget.keyword?.searchType ?? "1";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('キーワード登録'),
      content: SizedBox(
        width: 300,
        height: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(labelText: "キーワード"),
              controller: keywordController,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                '検索タイプ',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ), 
            SizedBox(
              width: 300,
              child: DropdownButton(
                isExpanded: true,
                items: dropdownItem,
                onChanged: (dynamic value) {
                  setState(() {
                    searchType = value;
                  });
                },
                value: searchType,
              ),
            ),
          ]
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('キャンセル'),
          style: ElevatedButton.styleFrom(
            primary: Colors.grey
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('登録'),
          onPressed: _onRegister,
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    keywordController.dispose();
  }

  void _onRegister() {
    var keyword = Keyword(keyword: keywordController.text,id: widget.keyword?.id,searchType: searchType);
    if (keyword == widget.keyword) {
      Navigator.of(context).pop();
    }
    else if (keyword.keyword == null || keyword.keyword == '') {

    }
    else {
      List<Keyword>? list = widget.list;
      if (list != null && list.contains(keyword)) {

      } else {
        Navigator.of(context).pop(keyword);
      }
    }
  }

}