import 'package:flutter/material.dart';
import 'package:newbook_search/view/base/body.dart';
import 'package:newbook_search/view/base/viewmodel.dart';
import 'package:provider/provider.dart';

class BaseMainView extends StatelessWidget {
  const BaseMainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BaseViewModel(),
        ),
      ],
      child: const Scaffold(
        body: BaseViewBody(),
      ),
    );
  }
}