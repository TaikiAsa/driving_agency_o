import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:treiber_for_agent/helpers/screen_navigation.dart';
import 'package:treiber_for_agent/providers/agent.dart';
import 'package:treiber_for_agent/providers/style.dart';
import 'package:treiber_for_agent/screens/settings/update_agent_fee.dart';
import 'package:treiber_for_agent/screens/settings/update_agent_profile.dart';

class ProfileSettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          'プロフィール',
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
                                  child: const Text('  アカウント'),
                                ),
                                const Divider(
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                !agentProvider.agent.isEffectiveAccount
                                    ? ListTile(
                                        leading:
                                            const Icon(Icons.not_interested),
                                        title: Text(
                                            'アカウントの公開停止されております。'
                                            '有効化してください',
                                            style: TextStyle(
                                                color: styleProvider.error)),
                                        onTap: (() async {
                                          await Fluttertoast.showToast(
                                              msg: 'Treiber公式webサイトからお申し込みください',
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  styleProvider.error);
                                        }),
                                      )
                                    : ListTile(
                                        leading:
                                            const Icon(Icons.bookmark_outlined),
                                        title: Text('アカウントは有効です',
                                            style: TextStyle(
                                                color: styleProvider.primary)),
                                        onTap: (() async {
                                          await Fluttertoast.showToast(
                                              msg: 'アカウントの有効期限にご注意ください',
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  styleProvider.primary);
                                        }),
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
                                  child: const Text('  会社名'),
                                ),
                                const Divider(
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                ListTile(
                                  leading: const Icon(Icons.apartment_rounded),
                                  title: Text(agentProvider.agent.companyName),
                                  onTap: (() async {
                                    await Fluttertoast.showToast(
                                        msg: '会社名は変更できません。管理者までお問い合わせください',
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: styleProvider.error);
                                  }),
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
                                  child: const Text('  連絡先・住所'),
                                ),
                                const Divider(
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                ListTile(
                                  leading: const Icon(Icons.phone),
                                  title: Text(agentProvider.agent.phoneNumber),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: (() {
                                    agentProvider.reFetchAgentController();
                                    changeScreen(
                                        context, UpdateAgentProfileScreen());
                                  }),
                                ),
                                const Divider(
                                  indent: 60,
                                ),
                                ListTile(
                                  leading: const Icon(Icons.home_work),
                                  title: Text(agentProvider.agent.prefecture),
                                  subtitle: Text(
                                      '${agentProvider.agent.municipalities},${agentProvider.agent.address}'),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: (() {
                                    agentProvider.reFetchAgentController();
                                    changeScreen(
                                        context, UpdateAgentProfileScreen());
                                  }),
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
                                  child: const Text('  料金設定'),
                                ),
                                const Divider(
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                ListTile(
                                  leading: const Icon(Icons.payments_rounded),
                                  title: Text(agentProvider.agent.fee),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: (() {
                                    agentProvider.reFetchAgentController();
                                    changeScreen(
                                        context, UpdateAgentFeeScreen());
                                  }),
                                ),
                              ],
                            )),
                        const SizedBox(height: 50),
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
