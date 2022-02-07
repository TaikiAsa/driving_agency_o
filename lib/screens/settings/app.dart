import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:treiber_for_agent/providers/style.dart';

class AppSettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          '全体設定',
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
                                  child: const Text('  アプリの見た目'),
                                ),
                                const Divider(
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                ListTile(
                                  leading: const Icon(Icons.color_lens),
                                  title: const Text('ダークモードに変更'),
                                  trailing: Switch(
                                    value: styleProvider.isDark,
                                    activeColor: styleProvider.primary,
                                    activeTrackColor:
                                        styleProvider.primaryBackground,
                                    inactiveTrackColor:
                                        styleProvider.primaryBackground,
                                    onChanged: (bool value) async {
                                      await styleProvider.switchStyle(
                                          IsDark: value);
                                    },
                                  ),
                                  // onTap: () {},
                                ),
                              ],
                            )),
                        const SizedBox(height: 5),
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
                                  child: const Text('  アプリ通知'),
                                ),
                                const Divider(
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                ListTile(
                                  leading:
                                      const Icon(Icons.notifications_active),
                                  title: const Text('通知設定を変更する'),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: (() async {
                                    await _showNotificationServiceFailed(
                                        context: context);
                                  }),
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
      ),
    );
  }
}

Future<void> _showNotificationServiceFailed(
    {required BuildContext context}) async {
  final styleProvider = Provider.of<StyleProvider>(context, listen: false);
  await showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: const Text('通知機能'),
      content: const Text('通知受け取りの設定を変更します。'),
      actions: <Widget>[
        BasicDialogAction(
          title: Text(
            '設定画面へ',
            style: TextStyle(color: styleProvider.primary),
          ),
          onPressed: () {
            openAppSettings();
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
