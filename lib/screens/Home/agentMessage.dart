import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:treiber_for_agent/providers/agent.dart';
import 'package:treiber_for_agent/providers/app.dart';
import 'package:treiber_for_agent/providers/fbAuth.dart';
import 'package:treiber_for_agent/providers/style.dart';

class AgentMessageScreen extends StatefulWidget {
  @override
  _AgentMessageScreenState createState() => _AgentMessageScreenState();
}

class _AgentMessageScreenState extends State<AgentMessageScreen> {
  final _titleFormKey = GlobalKey<FormState>();
  final _messageFormKey = GlobalKey<FormState>();

  final _titleFocus = FocusNode();
  final _messageFocus = FocusNode();

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

    var _agentMessage;

    if (agentProvider.agentMessage.title == '未設定') {
      _agentMessage = authProvider.agentMessageForFetch;
    } else {
      _agentMessage = agentProvider.agentMessage;
    }

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
          child: GestureDetector(
        onTap: (() {
          _titleFocus.unfocus();
          _messageFocus.unfocus();
        }),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight,
          ),
          child: Padding(
            padding: _padding,
            child: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: styleProvider.isDark
                          ? Image.asset(
                              'assets/images/headerLogoMainDark.png',
                              width: 170,
                            )
                          : Image.asset(
                              'assets/images/headerLogoMain.png',
                              width: 170,
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Center(
                        child: Text('メッセージ編集', style: TextStyle(fontSize: 25)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: styleProvider.WB,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              child: const Text('タイトル'),
                            ),
                          ),
                          Form(
                            key: _titleFormKey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              child: TextFormField(
                                cursorColor: styleProvider.primary,
                                controller:
                                    agentProvider.agentMessageTitleControl,
                                focusNode: _titleFocus,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onFieldSubmitted: (v) {
                                  _titleFocus.unfocus();
                                },
                                validator: (value) {
                                  return value!.isEmpty ? '入力必須です' : null;
                                },
                                maxLines: 20,
                                minLines: 1,
                                decoration: InputDecoration(
                                  hintText: 'メッセージタイトル',
                                  labelStyle:
                                      TextStyle(color: styleProvider.primary),
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
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              child: const Text('メッセージ'),
                            ),
                          ),
                          Form(
                            key: _messageFormKey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              child: TextFormField(
                                cursorColor: styleProvider.primary,
                                controller: agentProvider.agentMessageControl,
                                focusNode: _messageFocus,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onFieldSubmitted: (v) {
                                  _messageFocus.unfocus();
                                },
                                validator: (value) {
                                  return value!.isEmpty ? '入力必須です' : null;
                                },
                                maxLines: 20,
                                minLines: 1,
                                decoration: InputDecoration(
                                  hintText: '本文',
                                  labelStyle:
                                      TextStyle(color: styleProvider.primary),
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
                                      style: styleProvider.activeButtonStyle,
                                      onPressed: (() async {
                                        if (_titleFormKey.currentState!
                                                .validate() &&
                                            _messageFormKey.currentState!
                                                .validate()) {
                                          appProvider.changeLoading();
                                          if (await agentProvider
                                              .updateAgentMessage(
                                                  agentId: authProvider
                                                      .fbUser.uid)) {
                                            await agentProvider.fetchAgent(
                                                agentId:
                                                    authProvider.fbUser.uid);
                                            appProvider.changeLoading();
                                            await Fluttertoast.showToast(
                                                msg: '更新が完了しました',
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    styleProvider.primary);
                                          } else {
                                            appProvider.changeLoading();
                                            await Fluttertoast.showToast(
                                                msg:
                                                    '更新作業中にエラーが発生しました。再度お試しください',
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    styleProvider.error);
                                          }
                                        }
                                      }),
                                      child: Text(
                                        '更新する',
                                        style:
                                            TextStyle(color: styleProvider.WB),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ));
    });
  }
}

Future<void> _showLocationServiceFailed(
    {required BuildContext context, required String message}) async {
  final styleProvider = Provider.of<StyleProvider>(context, listen: false);
  await showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: const Text('位置情報取得エラー'),
      content: Text(message),
      actions: <Widget>[
        BasicDialogAction(
          title: Text(
            'OK',
            style: TextStyle(color: styleProvider.primary),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        BasicDialogAction(
          title: Text(
            '設定画面へ',
            style: TextStyle(color: styleProvider.primary),
          ),
          onPressed: () {
            openAppSettings();
          },
        ),
      ],
    ),
  );
}
