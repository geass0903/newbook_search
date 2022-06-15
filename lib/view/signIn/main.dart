import 'package:flutter/material.dart';
import 'package:newbook_search/view/signIn/body.dart';
import 'package:newbook_search/view/signIn/viewmodel.dart';
import 'package:provider/provider.dart';

class SignInView extends StatelessWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SignInViewModel(),
        ),
      ],
      child: const Scaffold(
        body: SignInViewBody(),
      ),
    );
  }
}