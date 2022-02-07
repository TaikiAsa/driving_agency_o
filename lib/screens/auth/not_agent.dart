import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:treiber_for_agent/helpers/screen_navigation.dart';
import 'package:treiber_for_agent/providers/app.dart';
import 'package:treiber_for_agent/providers/fbAuth.dart';
import 'package:treiber_for_agent/providers/style.dart';
import 'package:treiber_for_agent/screens/auth/login.dart';
import 'package:treiber_for_agent/widgets/loading.dart';

class NotAgentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final authProvider = Provider.of<FbAuthProvider>(context);
    final styleProvider = Provider.of<StyleProvider>(context);

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: styleProvider.primary),
          elevation: 0,
          backgroundColor: styleProvider.primaryBackground,
          title: Text(
            'ログインエラー',
            style: TextStyle(color: styleProvider.BW),
          ),
        ),
        body: appProvider.isLoading
            ? Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Loading()],
                ),
              )
            : SafeArea(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 100,
                      ),
                      const Text('権限エラー、代行車用アカウントでサインインして下さい'),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: 300.0,
                        height: 80.0,
                        child: MaterialButton(
                          color: styleProvider.primary,
                          onPressed: (() async {
                            await authProvider.signOut();
                            changeScreenClear(context, LoginScreen());
                          }),
                          child: const Text(
                            'サインアウト',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
