import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:newbook_search/util/uistate.dart';
import 'package:newbook_search/view/base/viewmodel.dart';
import 'package:newbook_search/view/tab1/main.dart';
import 'package:newbook_search/view/tab2/main.dart';
import 'package:newbook_search/view/tab3/main.dart';
import 'package:provider/provider.dart';

class BaseViewBody extends StatefulWidget {
  const BaseViewBody({Key? key}) : super(key: key);

  @override
  _BaseViewBodyState createState() => _BaseViewBodyState();
}

class _BaseViewBodyState extends State<BaseViewBody> {

  final List<Widget> children = [
    const Tab1MainView(),
    const Tab2MainView(),
    const Tab3MainView(),
  ];


  final List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem( // call each bottom item
      icon: Icon(Icons.book),
      label: '新刊リスト',
    ),
    const BottomNavigationBarItem( // call each bottom item
      icon: Icon(Icons.abc),
      label: 'キーワード',
    ),
    const BottomNavigationBarItem( // call each bottom item
      icon: Icon(Icons.settings),
      label: '設定',
    ),
  ];

  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        var body = message.notification?.body;
        if(body != null) {
          debugPrint('Message also contained a notification: $body');
          var snackBar = SnackBar(content: Text(body));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _contents(),
          _progress(),
        ],
      ),
    );
  }

  Scaffold _contents() {
    return Scaffold(
      body: IndexedStack(
        index: _tabIndex,
        children: children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) { // define animation
          setState(() {
            _tabIndex = index;
          });
        },
        currentIndex: _tabIndex,
        items: items,
      ),
    );
  }

  Builder _progress() {
    return Builder(
        builder: (BuildContext context) {
          UiState state = Provider.of<BaseViewModel>(context, listen: true).progressState;
          switch (state) {
            case UiState.busy:
              return WillPopScope(
                onWillPop: () async => false,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      const Opacity(
                        opacity: 0.5,
                        child: ModalBarrier(dismissible: false, color: Colors.black),
                      ),
                      _progressText(),
                    ],
                  ),
                ),
              );
            default:
              return Container();
          }
        }
    );
  }

  Center _progressText() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: 280.0,
        height: 160.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              Provider.of<BaseViewModel>(context, listen: true).progressText,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                decoration: TextDecoration.none,
              ),
              textScaleFactor: 1.0,
            ),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

}