import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:treiber_for_agent/helpers/screen_navigation.dart';
import 'package:treiber_for_agent/providers/agent.dart';
import 'package:treiber_for_agent/providers/fbAuth.dart';
import 'package:treiber_for_agent/providers/style.dart';
import 'package:treiber_for_agent/screens/settings/update_agent_password.dart';

class UpdateAuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          '認証情報',
          style: TextStyle(color: styleProvider.BW),
        ),
        elevation: 0,
      ),
      body: SafeArea(
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
                                const SizedBox(height: 5),
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  child: const Text('  認証情報'),
                                ),
                                const Divider(
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                ListTile(
                                  leading: const Icon(Icons.mail),
                                  title: Text(
                                      authProvider.fbUser.email.toString()),
                                  trailing: const Icon(Icons.chevron_right),
                                  subtitle: authProvider.fbUser.emailVerified
                                      ? Text(' メールアドレス確認済',
                                          style: TextStyle(
                                              color: styleProvider.primary))
                                      : Text(' メールアドレスを確認して下さい',
                                          style: TextStyle(
                                              color: styleProvider.error)),
                                  onTap: (() async {
                                    await _showConfirmSignOut(context: context);
                                  }),
                                ),
                                const Divider(
                                  indent: 60,
                                ),
                                ListTile(
                                  leading: const Icon(Icons.vpn_key),
                                  title: const Text('**************'),
                                  trailing: const Icon(Icons.chevron_right),
                                  subtitle: const Text('パスワードを変更する'),
                                  onTap: (() {
                                    changeScreen(
                                        context, UpdateAgentPasswordScreen());
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
                                  leading: const Icon(Icons.exit_to_app),
                                  title: const Text('サインアウト'),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: (() async {
                                    agentProvider.clearController();
                                    await _showConfirmSignOut(context: context);
                                  }),
                                ),
                              ],
                            )),
                        const SizedBox(height: 40),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: styleProvider.WB,
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.dangerous),
                                  title: Text(
                                    'アカウントの削除申請を行う',
                                    style:
                                        TextStyle(color: styleProvider.error),
                                  ),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: (() async {
                                    await _showConfirmDeleteAccount(
                                        context: context);
                                  }),
                                ),
                              ],
                            )),
                        const SizedBox(height: 5),
                      ],
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

Future<void> _showConfirmSignOut({required BuildContext context}) async {
  final styleProvider = Provider.of<StyleProvider>(context, listen: false);
  final authProvider = Provider.of<FbAuthProvider>(context, listen: false);

  await showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: const Text('確認'),
      content: const Text('サインアウトします。よろしいですか？'),
      actions: <Widget>[
        BasicDialogAction(
          title: Text(
            'サインアウトする',
            style: TextStyle(color: styleProvider.primary),
          ),
          onPressed: () async {
            await authProvider.signOut();
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
        BasicDialogAction(
          title: Text(
            'キャンセル',
            style: TextStyle(color: styleProvider.primary),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

Future<void> _showConfirmDeleteAccount({required BuildContext context}) async {
  final styleProvider = Provider.of<StyleProvider>(context, listen: false);
  final authProvider = Provider.of<FbAuthProvider>(context, listen: false);

  await showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: const Text('注意'),
      content: const Text('アカウントの削除申請を行います。よろしいですか？'),
      actions: <Widget>[
        BasicDialogAction(
          title: Text(
            '続行する',
            style: TextStyle(color: styleProvider.primary),
          ),
          onPressed: () async {
            await authProvider.signOut();
            Navigator.pop(context);
          },
        ),
        BasicDialogAction(
          title: Text(
            'キャンセル',
            style: TextStyle(color: styleProvider.primary),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
