import 'package:flutter/material.dart';
import 'package:newbook_search/class/dragscrollbehavior.dart';
import 'package:newbook_search/class/itemnewbook.dart';
import 'package:newbook_search/viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:newbook_search/view/base/viewmodel.dart';
import 'package:newbook_search/view/tab1/viewmodel.dart';
import 'package:newbook_search/util/event.dart';


class Tab1ViewBody extends StatefulWidget {
  const Tab1ViewBody({Key? key}) : super(key: key);

  @override
  _Tab1ViewBodyState createState() => _Tab1ViewBodyState();
}

class _Tab1ViewBodyState extends State<Tab1ViewBody> {

  @override
  void initState() {
    super.initState();
    // Listen events by view model.
    var viewModel = Provider.of<Tab1ViewModel>(context, listen: false);
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
        case Event.error:
          var message = Provider.of<Tab1ViewModel>(context, listen: false).infoText;
          var snackBar = SnackBar(content: Text(message));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;    
        default:
      }
    });
    Provider.of<Tab1ViewModel>(context, listen: false).loadNewBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Builder(
          builder: (BuildContext context) {
            return Expanded(
              child: _newbookList(Provider.of<Tab1ViewModel>(context, listen: true).newbookList),
            );
          }
        ),
      ],
    );
  }

  Widget _newbookList(List<NewBook> newbookList) {
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
              child: ItemNewBook(newBook: newbookList[index]),
            ),
            onTap: () {
              _onTapNewBook(newbookList[index]);
            },
          );
        },
        itemCount: newbookList.length,
        physics: const AlwaysScrollableScrollPhysics(),
      ),
      onRefresh: () async {
        _refreshConfirm();
      },
    );
  } 

  void _onTapNewBook(NewBook newBook) {
    debugPrint('onTap $newBook');
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
      Provider.of<Tab1ViewModel>(context, listen: false).getNewBooks(user);
    }
  }

}