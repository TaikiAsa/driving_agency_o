import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treiber_for_agent/helpers/screen_navigation.dart';
import 'package:treiber_for_agent/providers/agent.dart';
import 'package:treiber_for_agent/providers/app.dart';
import 'package:treiber_for_agent/providers/fbAuth.dart';
import 'package:treiber_for_agent/providers/style.dart';
import 'package:treiber_for_agent/screens/settings/app.dart';
import 'package:treiber_for_agent/screens/settings/profile.dart';

import 'update_auth.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final agentProvider = Provider.of<AgentProvider>(context);
    final authProvider = Provider.of<FbAuthProvider>(context);
    final styleProvider = Provider.of<StyleProvider>(context);

    var _padding = const EdgeInsets.all(8.0);

    if (MediaQuery.of(context).size.width > 600.0) {
      var _size = (MediaQuery.of(context).size.width - 600.0) / 2;
      _padding = EdgeInsets.fromLTRB(_size, 8.0, _size, 8.0);
    }

    return SafeArea(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
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
                              ListTile(
                                leading: const Icon(Icons.local_taxi),
                                title: const Text('プロフィール'),
                                subtitle: const Text('基本情報の編集を行います'),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: (() async {
                                  await agentProvider.fetchAgent(
                                      agentId: authProvider.fbUser.uid);
                                  changeScreen(context, ProfileSettingScreen());
                                }),
                              ),
                              const Divider(
                                indent: 60,
                              ),
                              ListTile(
                                leading: const Icon(Icons.lock),
                                title: const Text('認証情報'),
                                subtitle: const Text('メールアドレス・パスワード等の変更を行います'),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: (() async {
                                  changeScreen(context, UpdateAuthScreen());
                                }),
                              ),
                            ],
                          )),
                      const SizedBox(height: 20),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: styleProvider.WB,
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading:
                                    const Icon(Icons.settings_applications),
                                title: const Text('全体設定'),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: (() {
                                  changeScreen(context, AppSettingScreen());
                                }),
                              ),
                            ],
                          )),
                      const SizedBox(height: 20),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: styleProvider.WB,
                          ),
                          child: Column(
                            children: [
                              const ListTile(
                                leading:
                                    Icon(Icons.featured_play_list_outlined),
                                title: Text('利用規約'),
                                trailing: Icon(Icons.chevron_right),
                                // onTap: () {},
                              ),
                              const Divider(
                                indent: 60,
                              ),
                              const ListTile(
                                leading: Icon(Icons.security),
                                title: Text('プライバシーポリシー'),
                                trailing: Icon(Icons.chevron_right),
                                // onTap: () {},
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
