import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:newbook_search/util/event.dart';
import 'package:newbook_search/util/uistate.dart';
import 'package:newbook_search/view/signIn/viewmodel.dart';

class SignInViewBody extends StatefulWidget {
  const SignInViewBody({Key? key}) : super(key: key);

  @override
  _SignInViewBodyState createState() => _SignInViewBodyState();
}

class _SignInViewBodyState extends State<SignInViewBody> {

  String email = "";
  String password = "";

  @override
  void initState() {
    super.initState();

    var viewModel = Provider.of<SignInViewModel>(context, listen: false);
    viewModel.eventController.stream.listen((event) {
      switch (event) {
        case Event.showProgress:
          Provider.of<SignInViewModel>(context, listen: false).showProgressIndicator();
          break;
        case Event.dismissProgress:
          Provider.of<SignInViewModel>(context, listen: false).dismissProgressIndicator();
          break;
        case Event.signIn:
          const snackBar = SnackBar(content: Text('ログインしました'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        case Event.signInError:
          const snackBar = SnackBar(content: Text('ログインに失敗しました'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        case Event.signUp:
          const snackBar = SnackBar(content: Text('アカウントを登録しました'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        case Event.signUpError:
          const snackBar = SnackBar(content: Text('アカウントの登録に失敗しました'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        default:
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


  Center _contents() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
            child:ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400.0),
              child: TextFormField(
                  decoration: const InputDecoration(labelText: "メールアドレス"),
                  onChanged: (String value) {
                    email = value;
                  },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
            child:ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400.0),
              child: TextFormField(
                decoration: const InputDecoration(labelText: "パスワード（8～20文字）"),
                obscureText: true,  // パスワードが見えないようRにする
                maxLength: 20,  // 入力可能な文字数
                onChanged: (String value) {
                  password= value;
                },
              ),
            ),
          ),
          // ログイン失敗時のエラーメッセージ
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
            child:Text(
              Provider.of<SignInViewModel>(context, listen: true).infoText,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 30.0),
            child:ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 300.0,  minHeight: 40.0),
              child: ElevatedButton(
                child: const Text('ログイン'),
                onPressed: _signIn,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0),
            child:ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 300.0,  minHeight: 40.0),
              child: ElevatedButton(
                child: const Text('アカウント作成'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.teal
                ),
                onPressed: _signUp,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
            child: Text('(登録後自動的にログインします)'),
          ),
        ],
      ),
    );
  }

  Builder _progress() {
    return Builder(
        builder: (BuildContext context) {
          UiState state = Provider.of<SignInViewModel>(context, listen: true).progressState;
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
              Provider.of<SignInViewModel>(context, listen: true).progressText,
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

  Future<void> _signIn() async {
    Provider.of<SignInViewModel>(context, listen: false).signIn(email, password);
  }

  Future<void> _signUp() async {
    Provider.of<SignInViewModel>(context, listen: false).signUp(email, password);
  }
}