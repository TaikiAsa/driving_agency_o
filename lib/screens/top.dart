import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treiber_for_agent/helpers/agent.dart';
import 'package:treiber_for_agent/helpers/notification_handler.dart';
import 'package:treiber_for_agent/providers/agent.dart';
import 'package:treiber_for_agent/providers/app.dart';
import 'package:treiber_for_agent/providers/fbAuth.dart';
import 'package:treiber_for_agent/providers/style.dart';
import 'package:treiber_for_agent/screens/Home/agentMessage.dart';
import 'package:treiber_for_agent/screens/Home/main.dart';
import 'package:treiber_for_agent/screens/settings/main.dart';
import 'package:treiber_for_agent/widgets/loading.dart';

Widget _switchScreen(String _mode) {
  switch (_mode) {
    case 'HOME':
      return HomeScreen();
    case 'SETTING':
      return SettingScreen();
    case 'MESSAGE':
      return AgentMessageScreen();
    default:
      return HomeScreen();
  }
}

class TopScreen extends StatefulWidget {
  @override
  _TopScreenState createState() => _TopScreenState();
}

class _TopScreenState extends State<TopScreen> {
  @override
  void initState() {
    super.initState();
    initToken();
  }

  var _token;

  void initToken() async {
    _token = await NotificationService().getToken();
    await NotificationService().initContext(context: context);
    // await AgentServices().updateFcmToken(agentId: '', token: _token);
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final styleProvider = Provider.of<StyleProvider>(context);
    final authProvider = Provider.of<FbAuthProvider>(context);
    final agentProvider = Provider.of<AgentProvider>(context);
    if (_token != null) {
      AgentServices().updateFcmToken(
          agentId: authProvider.fbUser.uid, token: _token.toString());
    }

    return Scaffold(
      backgroundColor: styleProvider.primaryBackground,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: appProvider.ScreenStatusIndex,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.message,
              ),
              label: '投稿',
              tooltip: '投稿'),
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'ホーム',
              tooltip: 'ホーム'),
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
              ),
              label: '設定',
              tooltip: '設定'),
        ],
        selectedItemColor: styleProvider.primary,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        onTap: ((index) async {
          if (index == 0) {
            await agentProvider.fetchAgent(agentId: authProvider.fbUser.uid);
          }
          appProvider.onBottomItemTapped(index);
        }),
      ),
      body: appProvider.isLoading
          ? Loading()
          : _switchScreen(appProvider.ScreenStatus),
    );
  }
}
