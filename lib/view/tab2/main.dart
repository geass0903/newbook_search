import 'package:flutter/material.dart';
import 'package:newbook_search/view/tab2/fab.dart';
import 'package:provider/provider.dart';
import 'package:newbook_search/view/tab2/body.dart';
import 'package:newbook_search/view/tab2/viewmodel.dart';

class Tab2MainView extends StatelessWidget {
  const Tab2MainView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Tab2ViewModel(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('キーワード'),
        ),
        body: const Tab2ViewBody(),
        floatingActionButton: const Tab2ViewFAB(),
      ),
    );
  }
}