import 'package:flutter/material.dart';
import 'package:newbook_search/viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:newbook_search/class/itemkeyword.dart';
import 'package:newbook_search/view/tab2/viewmodel.dart';

import '../../class/keyworddialog.dart';



class Tab2ViewFAB extends StatefulWidget {
  const Tab2ViewFAB({Key? key}) : super(key: key);

  @override
  _Tab2ViewFABState createState() => _Tab2ViewFABState();
}

class _Tab2ViewFABState extends State<Tab2ViewFAB> {


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: _onPressedFAB,
    );
  }

  Future<void> _onPressedFAB() async{
    var keywordList = Provider.of<Tab2ViewModel>(context, listen: false).keywordList;
    Keyword? keyword = await KeywordDialog.show(context: context, keyword: Keyword(keyword: ''), list: keywordList);
    if(keyword != null) {
      var user = Provider.of<MyAppViewModel>(context, listen: false).user;
      Provider.of<Tab2ViewModel>(context, listen: false).saveKeyword(user, keyword, -1);
    }
  }

}