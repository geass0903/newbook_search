import 'package:flutter/material.dart';
import 'package:newbook_search/class/keyworddialog.dart';
import 'package:newbook_search/viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:newbook_search/class/dragscrollbehavior.dart';
import 'package:newbook_search/class/itemkeyword.dart';
import 'package:newbook_search/util/event.dart';
import 'package:newbook_search/view/base/viewmodel.dart';
import 'package:newbook_search/view/tab2/viewmodel.dart';

class Tab2ViewBody extends StatefulWidget {
  const Tab2ViewBody({Key? key}) : super(key: key);

  @override
  _Tab2ViewBodyState createState() => _Tab2ViewBodyState();
}

class _Tab2ViewBodyState extends State<Tab2ViewBody> {

  @override
  void initState() {
    super.initState();
    // Listen events by view model.
    var viewModel = Provider.of<Tab2ViewModel>(context, listen: false);
    viewModel.eventController.stream.listen((event) {
      switch (event) {
        case Event.showProgress:
          Provider.of<BaseViewModel>(context, listen: false).showProgressIndicator();
          break;
        case Event.dismissProgress:
          Provider.of<BaseViewModel>(context, listen: false).dismissProgressIndicator();
          break;
        case Event.success:
          const snackBar = SnackBar(content: Text('更新しました'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        case Event.delete:
          const snackBar = SnackBar(content: Text('削除しました'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        case Event.error:
          var message = Provider.of<Tab2ViewModel>(context, listen: false).infoText;
          var snackBar = SnackBar(content: Text(message));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;    
        default:
      }
    });
    Provider.of<Tab2ViewModel>(context, listen: false).loadKeywords();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Builder(
          builder: (BuildContext context) {
            return Expanded(
              child: _keywordList(Provider.of<Tab2ViewModel>(context, listen: true).keywordList),
            );
          }
        ),
      ],
    );
  }

  Widget _keywordList(List<Keyword> keywordList) {
    return RefreshIndicator(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black38),
                  ),
              ),
              child: ItemKeyword(keyword: keywordList[index]),
            ),
            onTap: () {
              _onTapKeyword(keywordList[index], index);
            },
            onLongPress: () {
              _onLongPressKeyword(keywordList[index], index);
            },
          );
        },
        itemCount: keywordList.length,
        physics: const AlwaysScrollableScrollPhysics(),
      ),
      onRefresh: () async {
        _refreshConfirm();
      },
    );
  }

  Future<void> _onTapKeyword(Keyword keyword, int index) async{
    debugPrint(keyword.toString());
    var keywordList = Provider.of<Tab2ViewModel>(context, listen: false).keywordList;
    Keyword? update = await KeywordDialog.show(context: context, keyword: keyword, list: keywordList);
    if(update != null) {
      var user = Provider.of<MyAppViewModel>(context, listen: false).user;
      Provider.of<Tab2ViewModel>(context, listen: false).saveKeyword(user, update, index);
    }
  }

  Future<void> _onLongPressKeyword(Keyword keyword, int index) async{
    debugPrint(keyword.toString());
    var doDelete = await showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('キーワードの削除'),
          content: const Text('削除しますか？'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('キャンセル'),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('削除'),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepOrange
              ),
            ),
          ],
        );
      }
    );
    if (doDelete) {
      var user = Provider.of<MyAppViewModel>(context, listen: false).user;
      Provider.of<Tab2ViewModel>(context, listen: false).deleteKeyword(user, keyword, index);
    }
  }

  Future<void> _refreshConfirm() async{
    var doUpdate = await showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('リストの更新'),
          content: const Text('更新しますか？'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('キャンセル'),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('OK'),
            ),
          ],
        );
      }
    );
    if (doUpdate) {
      var user = Provider.of<MyAppViewModel>(context, listen: false).user;
      Provider.of<Tab2ViewModel>(context, listen: false).getKeywords(user);
    }
  }

}