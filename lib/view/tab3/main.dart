import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:newbook_search/view/tab3/body.dart';
import 'package:newbook_search/view/tab3/viewmodel.dart';

class Tab3MainView extends StatelessWidget {
  const Tab3MainView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Tab3ViewModel(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('設定'),
        ),
        body: const Tab3ViewBody(),
      ),
    );
  }
}