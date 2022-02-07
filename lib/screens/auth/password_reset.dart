import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:treiber_for_agent/helpers/screen_navigation.dart';
import 'package:treiber_for_agent/providers/fbAuth.dart';
import 'package:treiber_for_agent/providers/style.dart';
import 'package:treiber_for_agent/screens/auth/login.dart';
import 'package:treiber_for_agent/widgets/loading.dart';

class PasswordResetForm extends StatelessWidget {
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<FbAuthProvider>(context);
    final styleProvider = Provider.of<StyleProvider>(context);
    final emailController = TextEditingController();

    var _padding = const EdgeInsets.all(8.0);

    if (MediaQuery.of(context).size.width > 600.0) {
      var _size = (MediaQuery.of(context).size.width - 600.0) / 2;
      _padding = EdgeInsets.fromLTRB(_size, 8.0, _size, 8.0);
    }

    return Scaffold(
        key: _key,
        backgroundColor: styleProvider.primaryBackground,
        body: authProvider.authStatus == AuthStatus.Authenticating
            ? Loading()
            : LayoutBuilder(builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: Padding(
                      padding: _padding,
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const SizedBox(
                              height: 100,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: styleProvider.isDark
                                  ? Image.asset(
                                      'assets/images/forDriverMainDark.png',
                                      height: 80)
                                  : Image.asset(
                                      'assets/images/forDriverMain.png',
                                      height: 80),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: styleProvider.WB,
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32),
                                    child: TextField(
                                      controller: emailController,
                                      cursorColor: styleProvider.primary,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.email,
                                            color: styleProvider.primary),
                                        prefixStyle: const TextStyle(
                                          color: Colors.red,
                                        ),
                                        hintText: 'Email',
                                        hintStyle: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: styleProvider.primary,
                                            width: 0.5,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: styleProvider.primary,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 32),
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        styleProvider.primary)),
                                            onPressed: () async {
                                              String _result =
                                                  await authProvider
                                                      .sendPasswordResetEmail(
                                                          emailController.text);

                                              // 成功時は戻る
                                              if (_result == 'success') {
                                                Navigator.pop(context);
                                                await Fluttertoast.showToast(
                                                    msg: '再設定用のメールを送信しました',
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        styleProvider.primary);
                                                changeScreenReplacement(
                                                    context, LoginScreen());
                                              } else if (_result ==
                                                  'ERROR_INVALID_EMAIL') {
                                                await Fluttertoast.showToast(
                                                    msg: '無効なメールアドレスです',
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        styleProvider.error);
                                              } else if (_result ==
                                                  'ERROR_USER_NOT_FOUND') {
                                                await Fluttertoast.showToast(
                                                    msg: 'メールアドレスが登録されていません',
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        styleProvider.error);
                                              } else {
                                                await Fluttertoast.showToast(
                                                    msg: 'メール送信に失敗しました',
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        styleProvider.error);
                                              }
                                            },
                                            child: const Text('再設定用のメールを送信',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      changeScreenReplacement(
                                          context, LoginScreen());
                                    },
                                    child: const Center(
                                      child: Text(
                                        'ログインはコチラ',
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(52, 137, 246, 1),
                                          fontFamily: 'Montserrat',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }));
  }
}
