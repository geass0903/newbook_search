import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:newbook_search/view/tab1/body.dart';
import 'package:newbook_search/view/tab1/viewmodel.dart';

class Tab1MainView extends StatelessWidget {
  const Tab1MainView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Tab1ViewModel(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('新刊リスト'),
        ),
        body: const Tab1ViewBody(),
      ),
    );
  }

}