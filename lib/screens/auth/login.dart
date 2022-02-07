import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:treiber_for_agent/helpers/screen_navigation.dart';
import 'package:treiber_for_agent/providers/app.dart';
import 'package:treiber_for_agent/providers/fbAuth.dart';
import 'package:treiber_for_agent/providers/style.dart';
import 'package:treiber_for_agent/screens/auth/password_reset.dart';
import 'package:treiber_for_agent/widgets/loading.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final authProvider = Provider.of<FbAuthProvider>(context);
    final styleProvider = Provider.of<StyleProvider>(context);

    var _padding = const EdgeInsets.all(8.0);

    if (MediaQuery.of(context).size.width > 600.0) {
      var _size = (MediaQuery.of(context).size.width - 600.0) / 2;
      _padding = EdgeInsets.fromLTRB(_size, 8.0, _size, 8.0);
    }

    return Scaffold(
      backgroundColor: styleProvider.primaryBackground,
      body: authProvider.authStatus == AuthStatus.Authenticating
          ? Loading()
          : LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: Padding(
                      padding: _padding,
                      child: IntrinsicHeight(
                        child: Stack(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                const SizedBox(
                                  height: 100,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: styleProvider.isDark
                                      ? Image.asset(
                                          'assets/images/forDriverMainDark.png',
                                          height: 80)
                                      : Image.asset(
                                          'assets/images/forDriverMain.png',
                                          height: 80),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Expanded(child: Container()),
                                Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: styleProvider.WB,
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 30),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 32),
                                          child: TextField(
                                            controller: authProvider.email,
                                            cursorColor: styleProvider.primary,
                                            decoration: InputDecoration(
                                              focusColor: styleProvider.primary,
                                              hoverColor: styleProvider.primary,
                                              prefixIcon: Icon(Icons.email,
                                                  color: styleProvider.primary),
                                              prefixStyle: const TextStyle(
                                                color: Colors.red,
                                              ),
                                              hintText: 'メールアドレス',
                                              hintStyle: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.5,
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: styleProvider.primary,
                                                  width: 0.1,
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
                                        const SizedBox(height: 16),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 32),
                                          child: TextField(
                                            obscureText: true,
                                            cursorColor: styleProvider.primary,
                                            controller: authProvider.password,
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.vpn_key,
                                                color: styleProvider.primary,
                                              ),
                                              hintText: 'パスワード',
                                              hintStyle: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.5,
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: styleProvider.primary,
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
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 32),
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(styleProvider
                                                                  .primary)),
                                                  onPressed: () async {
                                                    var login =
                                                        await authProvider
                                                            .signIn();
                                                    if (!login) {
                                                      await Fluttertoast.showToast(
                                                          msg:
                                                              'メールアドレスまたはパスワードに誤りがあります',
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              styleProvider
                                                                  .error);
                                                      return;
                                                    } else {
                                                      switch (authProvider
                                                          .authStatus) {
                                                        case AuthStatus
                                                            .Authenticated:
                                                          authProvider
                                                              .clearController();
                                                          break;
                                                        default:
                                                          break;
                                                      }
                                                    }
                                                  },
                                                  child: const Text('サインイン',
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        CupertinoButton(
                                          onPressed: () {
                                            changeScreenReplacement(
                                                context, PasswordResetForm());
                                          },
                                          child: const Text(
                                            'パスワードを忘れた方はコチラ',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  52, 137, 246, 1),
                                              fontFamily: 'Montserrat',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    )),
                                Expanded(child: Container()),
                                const SizedBox(height: 8),
                              ],
                            ),
                            Positioned(
                              left: 0,
                              top: 128,
                              right: 0,
                              child: Container(
                                width: 100,
                                height: 100,
                              ),
                            ),
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
