import 'package:flutter/material.dart';
import 'package:newbook_search/util/event.dart';
import 'package:newbook_search/view/base/viewmodel.dart';
import 'package:newbook_search/viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:newbook_search/view/tab3/viewmodel.dart';

class Tab3ViewBody extends StatefulWidget {
  const Tab3ViewBody({Key? key}) : super(key: key);

  @override
  _Tab3ViewBodyState createState() => _Tab3ViewBodyState();
}

class _Tab3ViewBodyState extends State<Tab3ViewBody> {

  @override
  void initState() {
    super.initState();
    // Listen events by view model.
    var viewModel = Provider.of<Tab3ViewModel>(context, listen: false);
    viewModel.eventController.stream.listen((event) {
      switch (event) {
        case Event.showProgress:
          Provider.of<BaseViewModel>(context, listen: false).showProgressIndicator();
          break;
        case Event.dismissProgress:
          Provider.of<BaseViewModel>(context, listen: false).dismissProgressIndicator();
          break;
        case Event.signOut:
          const snackBar = SnackBar(content: Text('ログアウトしました'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        case Event.signOutError:
          const snackBar = SnackBar(content: Text('ログアウトに失敗しました'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        case Event.register:
          const snackBar = SnackBar(content: Text('登録しました'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        case Event.registerError:
          var message = Provider.of<Tab3ViewModel>(context, listen: false).infoText;
          var snackBar = SnackBar(content: Text(message));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        case Event.push:
          const snackBar = SnackBar(content: Text('プッシュ通知を送信しました'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        case Event.pushError:
          var message = Provider.of<Tab3ViewModel>(context, listen: false).infoText;
          var snackBar = SnackBar(content: Text(message));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;          
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: _contents(),
      ),
    );
  }

  List<Widget> _contents() {
    return <Widget>[
      const Padding(
        padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
        child: Text('---- ログアウト ---- '),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0),
        child:ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 300.0,  minHeight: 40.0),
          child: ElevatedButton(
            child: const Text('ログアウト'),
            onPressed: _signOut,
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
        child: Text('---- プッシュ通知登録 ---- '),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0),
        child:ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 300.0,  minHeight: 40.0),
          child: ElevatedButton(
            child: const Text('登録'),
            onPressed: _registerPushToken,
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
        child: Text('---- プッシュ通知テスト ---- '),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0),
        child:ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 300.0,  minHeight: 40.0),
          child: ElevatedButton(
            child: const Text('プッシュ通知送信'),
            onPressed: _pushTest,
          ),
        ),
      ),
    ];
  }

  Future<void> _signOut() async {
    Provider.of<Tab3ViewModel>(context, listen: false).signOut();
  }

  Future<void> _registerPushToken() async {
    var user = Provider.of<MyAppViewModel>(context, listen: false).user;
    Provider.of<Tab3ViewModel>(context, listen: false).registerPushToken(user);
  }

  Future<void> _pushTest() async {
    var user = Provider.of<MyAppViewModel>(context, listen: false).user;
    Provider.of<Tab3ViewModel>(context, listen: false).pushTest(user);
  }

}