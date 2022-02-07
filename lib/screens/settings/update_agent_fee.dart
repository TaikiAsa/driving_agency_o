import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:treiber_for_agent/providers/agent.dart';
import 'package:treiber_for_agent/providers/app.dart';
import 'package:treiber_for_agent/providers/fbAuth.dart';
import 'package:treiber_for_agent/providers/style.dart';

class UpdateAgentFeeScreen extends StatefulWidget {
  @override
  _UpdateAgentFeeScreenState createState() => _UpdateAgentFeeScreenState();
}

class _UpdateAgentFeeScreenState extends State<UpdateAgentFeeScreen> {
  final _feeFormKey = GlobalKey<FormState>();

  final _feeFocus = FocusNode();

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
          '料金情報更新',
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
          builder:
              (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: GestureDetector(
                onTap: (() {
                  _feeFocus.unfocus();
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
                                      child: const Text('登録された料金情報の編集を行います．'
                                          '以下の内容を編集し，”更新する”ボタンをタップしてください．'),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32),
                                    child: Container(
                                      alignment: Alignment.bottomLeft,
                                      child: const Text('料金設定'),
                                    ),
                                  ),
                                  Form(
                                    key: _feeFormKey,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32),
                                      child: TextFormField(
                                        cursorColor: styleProvider.primary,
                                        controller: agentProvider.feeControl,
                                        focusNode: _feeFocus,
                                        autovalidateMode: AutovalidateMode
                                            .onUserInteraction,
                                        onFieldSubmitted: (v) {
                                          _feeFocus.unfocus();
                                        },
                                        validator: (value) {
                                          return value!.isEmpty
                                              ? '入力必須です'
                                              : null;
                                        },
                                        maxLines: 20,
                                        minLines: 1,
                                        decoration: InputDecoration(
                                          hintText: 'お客様に分かりやすい入力をお願いいたします',
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
                                                appProvider.changeLoading();
                                                if (_feeFormKey.currentState!
                                                    .validate()) {
                                                  if (await agentProvider
                                                      .updateAgentBasicData(
                                                          agentId:
                                                              authProvider
                                                                  .fbUser
                                                                  .uid)) {
                                                    await agentProvider
                                                        .fetchAgent(
                                                            agentId:
                                                                authProvider
                                                                    .fbUser
                                                                    .uid);
                                                    appProvider
                                                        .changeLoading();
                                                    await Fluttertoast
                                                        .showToast(
                                                            msg: '更新が完了しました',
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                styleProvider
                                                                    .primary);
                                                  } else {
                                                    appProvider
                                                        .changeLoading();
                                                    await Fluttertoast.showToast(
                                                        msg:
                                                            '更新作業中にエラーが発生しました。再度お試しください',
                                                        gravity: ToastGravity
                                                            .BOTTOM,
                                                        timeInSecForIosWeb: 1,
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
