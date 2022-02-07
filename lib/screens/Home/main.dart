import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:treiber_for_agent/helpers/screen_navigation.dart';
import 'package:treiber_for_agent/providers/agent.dart';
import 'package:treiber_for_agent/providers/app.dart';
import 'package:treiber_for_agent/providers/fbAuth.dart';
import 'package:treiber_for_agent/providers/style.dart';

import '../google_map.dart';

class HomeScreen extends StatelessWidget {
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

    var _agent;

    if (agentProvider.agent.agentId == 'undefined') {
      _agent = authProvider.agentForFetch;
    } else {
      _agent = agentProvider.agent;
    }

    final waitingTimeList = [
      '10',
      '20',
      '30',
      '40',
      '50',
      'over',
    ];

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
          child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: viewportConstraints.maxHeight,
        ),
        child: Padding(
          padding: _padding,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: styleProvider.passiveButtonStyle,
                    onPressed: () async {
                      await agentProvider.fetchAgent(
                          agentId: authProvider.fbUser.uid);
                      GeoPoint geo = agentProvider.agent.location['geopoint'];
                      if (geo != null) {
                        changeScreen(context, GoogleMapScreen());
                      } else {
                        await Fluttertoast.showToast(
                            msg: '位置情報が取得できませんでした',
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: styleProvider.error);
                      }
                    },
                    child: Column(
                      children: [
                        Text(
                          '最後に登録された場所を確認する',
                          style: TextStyle(color: styleProvider.BW),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: _agent.currentState == 'WAITING'
                      ? ElevatedButton.styleFrom(padding: EdgeInsets.zero)
                      : styleProvider.passiveButtonStyle,
                  onPressed: () async {
                    if (await agentProvider.setLocation(
                        agentId: authProvider.fbUser.uid)) {
                      await agentProvider.updateCurrentState(
                          agentId: authProvider.fbUser.uid, state: 'WAITING');
                      await agentProvider.fetchAgent(
                          agentId: authProvider.fbUser.uid);
                    } else {
                      await _showLocationServiceFailed(
                          context: context,
                          message: agentProvider.locationUpdateError);
                    }
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      border: _agent.currentState == 'WAITING'
                          ? null
                          : Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                      gradient: _agent.currentState == 'WAITING'
                          ? styleProvider.gradation
                          : null,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      child: Row(children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          _agent.currentState == 'WAITING'
                              ? 'assets/images/waitingWhite.png'
                              : 'assets/images/waiting.png',
                          width: 60,
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(
                          '待機中',
                          style: TextStyle(
                              fontSize: 50,
                              color: _agent.currentState == 'WAITING'
                                  ? styleProvider.activeButtonTextColor
                                  : styleProvider.passiveButtonTextColor),
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: _agent.currentState == 'DRIVING'
                      ? ElevatedButton.styleFrom(padding: EdgeInsets.zero)
                      : styleProvider.passiveButtonStyle,
                  onPressed: () async {
                    await agentProvider.updateCurrentState(
                        agentId: authProvider.fbUser.uid, state: 'DRIVING');
                    await agentProvider.fetchAgent(
                        agentId: authProvider.fbUser.uid);
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      border: _agent.currentState == 'DRIVING'
                          ? null
                          : Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                      gradient: _agent.currentState == 'DRIVING'
                          ? styleProvider.gradation
                          : null,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      child: Row(children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          _agent.currentState == 'DRIVING'
                              ? 'assets/images/drivingWhite.png'
                              : 'assets/images/driving.png',
                          width: 60,
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(
                          '運転中',
                          style: TextStyle(
                              fontSize: 50,
                              color: _agent.currentState == 'DRIVING'
                                  ? styleProvider.activeButtonTextColor
                                  : styleProvider.passiveButtonTextColor),
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: _agent.currentState == 'CLOSE'
                      ? ElevatedButton.styleFrom(padding: EdgeInsets.zero)
                      : styleProvider.passiveButtonStyle,
                  onPressed: () async {
                    await agentProvider.updateCurrentState(
                        agentId: authProvider.fbUser.uid, state: 'CLOSE');
                    await agentProvider.fetchAgent(
                        agentId: authProvider.fbUser.uid);
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      border: _agent.currentState == 'CLOSE'
                          ? null
                          : Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                      gradient: _agent.currentState == 'CLOSE'
                          ? styleProvider.gradation
                          : null,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      child: Row(children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          _agent.currentState == 'CLOSE'
                              ? 'assets/images/closedWhite.png'
                              : 'assets/images/closed.png',
                          width: 60,
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(
                          '休業中',
                          style: TextStyle(
                              fontSize: 50,
                              color: _agent.currentState == 'CLOSE'
                                  ? styleProvider.activeButtonTextColor
                                  : styleProvider.passiveButtonTextColor),
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _agent.currentState != 'CLOSE'
                    ? SizedBox(
                        height: 400,
                        width: double.infinity,
                        child: GridView.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 1.8,
                            children: waitingTimeList.map((time) {
                              return ElevatedButton(
                                style: _agent.waitingTime.trim() == time
                                    ? ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero)
                                    : styleProvider.passiveButtonStyle,
                                onPressed: () async {
                                  await agentProvider.updateWaitingTime(
                                      agentId: authProvider.fbUser.uid,
                                      time: time);
                                  await agentProvider.fetchAgent(
                                      agentId: authProvider.fbUser.uid);
                                },
                                child: Ink(
                                  decoration: BoxDecoration(
                                      border: _agent.waitingTime.trim() == time
                                          ? null
                                          : Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5),
                                      gradient:
                                          _agent.waitingTime.trim() == time
                                              ? styleProvider.gradation
                                              : null),
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: Center(
                                      child: Text(
                                        time,
                                        style: const TextStyle(fontSize: 30),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList()),
                      )
                    : const SizedBox(height: 0),
              ],
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
