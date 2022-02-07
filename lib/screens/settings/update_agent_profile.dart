import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:treiber_for_agent/helpers/static.dart';
import 'package:treiber_for_agent/providers/agent.dart';
import 'package:treiber_for_agent/providers/app.dart';
import 'package:treiber_for_agent/providers/fbAuth.dart';
import 'package:treiber_for_agent/providers/style.dart';

class UpdateAgentProfileScreen extends StatefulWidget {
  @override
  _UpdateAgentProfileScreenState createState() =>
      _UpdateAgentProfileScreenState();
}

class _UpdateAgentProfileScreenState extends State<UpdateAgentProfileScreen> {
  final _phoneNumberFormKey = GlobalKey<FormState>();
  final _municipalitiesFormKey = GlobalKey<FormState>();
  final _addressFormKey = GlobalKey<FormState>();

  final _phoneNumberFocus = FocusNode();
  final _municipalitiesFocus = FocusNode();
  final _addressFocus = FocusNode();

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
    var _selectedPrefectures;
    if (agentProvider.prefecture == '') {
      _selectedPrefectures = '福岡県';
      agentProvider.prefecture = '福岡県';
    } else {
      _selectedPrefectures = agentProvider.prefecture;
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
          '代行車情報更新',
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
                  _phoneNumberFocus.unfocus();
                  _municipalitiesFocus.unfocus();
                  _addressFocus.unfocus();
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
                                      child: const Text('登録された代行車情報の編集を行います．'
                                          '以下の内容を編集し，”更新する”ボタンをタップしてください．'),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32),
                                    child: Container(
                                      alignment: Alignment.bottomLeft,
                                      child: const Text('電話番号(ハイフン無)'),
                                    ),
                                  ),
                                  Form(
                                    key: _phoneNumberFormKey,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32),
                                      child: TextFormField(
                                        cursorColor: styleProvider.primary,
                                        controller:
                                            agentProvider.phoneNumberControl,
                                        keyboardType: TextInputType.number,
                                        focusNode: _phoneNumberFocus,
                                        autovalidateMode: AutovalidateMode
                                            .onUserInteraction,
                                        onFieldSubmitted: (v) {
                                          _phoneNumberFocus.unfocus();
                                        },
                                        validator: (value) {
                                          return value!.isEmpty
                                              ? '入力必須です'
                                              : null;
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]')),
                                        ],
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.phone,
                                            color: styleProvider.primary,
                                          ),
                                          hintText: '半角数字で入力してください',
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
                                      child: const Text('都道府県'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32),
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedPrefectures,
                                      isExpanded: true,
                                      onChanged: (String? value) {
                                        agentProvider.prefecture = value;
                                      },
                                      items: prefectures
                                          .map<DropdownMenuItem<String>>(
                                              (String prefecture) {
                                        return DropdownMenuItem<String>(
                                          value: prefecture,
                                          child: Text(prefecture),
                                        );
                                      }).toList(),
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5.0))),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32),
                                    child: Container(
                                      alignment: Alignment.bottomLeft,
                                      child: const Text('市区町村'),
                                    ),
                                  ),
                                  Form(
                                    key: _municipalitiesFormKey,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32),
                                      child: TextFormField(
                                        cursorColor: styleProvider.primary,
                                        controller: agentProvider
                                            .municipalitiesControl,
                                        focusNode: _municipalitiesFocus,
                                        autovalidateMode: AutovalidateMode
                                            .onUserInteraction,
                                        onFieldSubmitted: (v) {
                                          _municipalitiesFocus.unfocus();
                                        },
                                        validator: (value) {
                                          return value!.isEmpty
                                              ? '入力必須です'
                                              : null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: '市区町村名のみを入力',
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
                                      child: const Text('市区町村以下'),
                                    ),
                                  ),
                                  Form(
                                    key: _addressFormKey,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32),
                                      child: TextFormField(
                                        cursorColor: styleProvider.primary,
                                        controller:
                                            agentProvider.addressControl,
                                        focusNode: _addressFocus,
                                        autovalidateMode: AutovalidateMode
                                            .onUserInteraction,
                                        onFieldSubmitted: (v) {
                                          // 年齢フォームからフォーカスを外し、キーボードをしまう
                                          _addressFocus.unfocus();
                                        },
                                        validator: (value) {
                                          return value!.isEmpty
                                              ? '入力必須です'
                                              : null;
                                        },
                                        maxLines: 10,
                                        minLines: 1,
                                        decoration: InputDecoration(
                                          hintText: '市区町村を含めない',
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
                                                if (_phoneNumberFormKey
                                                        .currentState!
                                                        .validate() &&
                                                    _municipalitiesFormKey
                                                        .currentState!
                                                        .validate() &&
                                                    _addressFormKey
                                                        .currentState!
                                                        .validate()) {
                                                  appProvider.changeLoading();
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
