import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:treiber_for_agent/providers/agent.dart';
import 'package:treiber_for_agent/providers/app.dart';
import 'package:treiber_for_agent/providers/fbAuth.dart';
import 'package:treiber_for_agent/providers/style.dart';

class UpdateAgentPasswordScreen extends StatefulWidget {
  @override
  _UpdateAgentPasswordScreenState createState() =>
      _UpdateAgentPasswordScreenState();
}

class _UpdateAgentPasswordScreenState extends State<UpdateAgentPasswordScreen> {
  final _passwordFormKey = GlobalKey<FormState>();
  final _newPasswordFormKey = GlobalKey<FormState>();
  final _newPasswordConfirmFormKey = GlobalKey<FormState>();

  final _passwordFocus = FocusNode();
  final _newPasswordFocus = FocusNode();
  final _newPasswordConfirmFocus = FocusNode();
  var _showPassword = false;

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final authProvider = Provider.of<FbAuthProvider>(context);
    final agentProvider = Provider.of<AgentProvider>(context);
    final styleProvider = Provider.of<StyleProvider>(context);
    var _padding = const EdgeInsets.all(8.0);

    if (MediaQuery.of(context).size.width > 600.0) {
      var _size = (MediaQuery.of(context).size.width - 600.0) / 2;
      _padding = EdgeInsets.fromLTRB(_size, 8.0, _size, 8.0);
    }

    return Scaffold(
      backgroundColor: styleProvider.primaryBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: styleProvider.BW,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: styleProvider.WB,
        title: Text(
          'パスワード変更',
          style: TextStyle(color: styleProvider.BW),
        ),
        elevation: 0,
      ),
      body: LoadingOverlay(
        isLoading: appProvider.isLoading,
        color: styleProvider.primary,
        progressIndicator:
            CircularProgressIndicator(color: styleProvider.primary),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: GestureDetector(
                onTap: (() {
                  _passwordFocus.unfocus();
                  _newPasswordFocus.unfocus();
                  _newPasswordConfirmFocus.unfocus();
                }),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Padding(
                    padding: _padding,
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: styleProvider.WB,
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 50),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32),
                                    child: Container(
                                      alignment: Alignment.bottomLeft,
                                      child: const Text('登録されたパスワードの変更を行います。'
                                          '現在のパスワードと新しいパスワードを入力してください。'),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32),
                                    child: Container(
                                      alignment: Alignment.bottomLeft,
                                      child: const Text('現在のパスワード'),
                                    ),
                                  ),
                                  Form(
                                    key: _passwordFormKey,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32),
                                      child: TextFormField(
                                        obscureText: true,
                                        cursorColor: styleProvider.primary,
                                        controller: authProvider.password,
                                        focusNode: _passwordFocus,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        onFieldSubmitted: (v) {
                                          _passwordFocus.unfocus();
                                        },
                                        validator: (value) {
                                          return value!.isEmpty
                                              ? '入力必須です'
                                              : null;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.vpn_key,
                                            color: styleProvider.primary,
                                          ),
                                          hintText: 'パスワード',
                                          labelStyle: TextStyle(
                                              color: styleProvider.primary),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide(
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
                                  ),
                                  const SizedBox(height: 50),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32),
                                    child: Container(
                                      alignment: Alignment.bottomLeft,
                                      child: const Text('新しいパスワード'),
                                    ),
                                  ),
                                  Form(
                                    key: _newPasswordFormKey,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32),
                                      child: TextFormField(
                                        obscureText: !_showPassword,
                                        cursorColor: styleProvider.primary,
                                        controller: authProvider.newPassword,
                                        focusNode: _newPasswordFocus,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        onFieldSubmitted: (v) {
                                          _newPasswordFocus.unfocus();
                                        },
                                        validator: (String? value) {
                                          return value!.length < 6
                                              ? 'パスワードは6文字以上で入力してください'
                                              : null;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.vpn_key_outlined,
                                            color: styleProvider.primary,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _showPassword
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: styleProvider.primary,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _showPassword = !_showPassword;
                                              });
                                            },
                                          ),
                                          hintText: '新しいパスワード',
                                          labelStyle: TextStyle(
                                              color: styleProvider.primary),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide(
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
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32),
                                    child: Container(
                                      alignment: Alignment.bottomLeft,
                                      child: const Text('新しいパスワード(確認用)'),
                                    ),
                                  ),
                                  Form(
                                    key: _newPasswordConfirmFormKey,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32),
                                      child: TextFormField(
                                        obscureText: true,
                                        cursorColor: styleProvider.primary,
                                        controller:
                                            authProvider.newPasswordConfirm,
                                        focusNode: _newPasswordConfirmFocus,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        onFieldSubmitted: (v) {
                                          _newPasswordConfirmFocus.unfocus();
                                        },
                                        validator: (value) {
                                          return authProvider
                                                      .newPassword.text !=
                                                  authProvider
                                                      .newPasswordConfirm.text
                                              ? '新しいパスワードが一致しません'
                                              : null;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.vpn_key_outlined,
                                            color: styleProvider.primary,
                                          ),
                                          hintText: '新しいパスワード',
                                          labelStyle: TextStyle(
                                              color: styleProvider.primary),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide(
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
                                  ),
                                  const SizedBox(height: 50),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 32),
                                          child: SizedBox(
                                            height: 50,
                                            child: ElevatedButton(
                                              style: styleProvider
                                                  .activeButtonStyle,
                                              onPressed: (() async {
                                                if (_passwordFormKey
                                                        .currentState!
                                                        .validate() &&
                                                    _newPasswordFormKey
                                                        .currentState!
                                                        .validate() &&
                                                    _newPasswordConfirmFormKey
                                                        .currentState!
                                                        .validate()) {
                                                  appProvider.changeLoading();
                                                  if (await authProvider
                                                      .updatePassword()) {
                                                    await agentProvider
                                                        .fetchAgent(
                                                            agentId:
                                                                authProvider
                                                                    .fbUser
                                                                    .uid);
                                                    appProvider.changeLoading();
                                                    await authProvider
                                                        .signOut();
                                                    await _showAfterUpdatePassword(
                                                        context: context);
                                                  } else {
                                                    appProvider.changeLoading();
                                                    await Fluttertoast
                                                        .showToast(
                                                            msg:
                                                                '入力されたパスワードに誤りがあるか、'
                                                                'ネットワークの接続に問題があります。',
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                styleProvider
                                                                    .error);
                                                  }
                                                }
                                              }),
                                              child: Text(
                                                '更新する',
                                                style: TextStyle(
                                                    color: styleProvider.WB),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 50),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<void> _showAfterUpdatePassword({required BuildContext context}) async {
  final styleProvider = Provider.of<StyleProvider>(context, listen: false);
  final authProvider = Provider.of<FbAuthProvider>(context, listen: false);

  await showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: const Text('パスワードの変更が完了しました'),
      content: const Text('サインイン画面に戻ります。新しいパスワードで再度サインインしてください。'),
      actions: <Widget>[
        BasicDialogAction(
          title: Text(
            'OK',
            style: TextStyle(color: styleProvider.primary),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
