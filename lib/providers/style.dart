import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.Dart';

class StyleProvider with ChangeNotifier {
  var _isDark = false;
  var prefs;

  bool get isDark => _isDark;

  StyleProvider.initialize({required initPrefs}) {
    prefs = initPrefs;
    if (ThemeMode.system == ThemeMode.light) {
      _isDark = false;
    } else if (ThemeMode.system == ThemeMode.dark) {
      _isDark = true;
    } else {
      _isDark = false;
    }
    _isDark = prefs.getBool('isDark') ?? _isDark;
    changeStyle(IsDark: _isDark);
    notifyListeners();
  }

  var primary;
  var primaryBackground;
  var WB;
  var BW;
  var error;

  var activeButtonStyle;
  var passiveButtonStyle;
  var activeButtonTextColor;
  var passiveButtonTextColor;

  var gradation = const LinearGradient(colors: [
    Color(0xff9BE15D),
    Color(0xff00E3AE),
  ], begin: Alignment.bottomLeft, end: Alignment.topRight);

  Future<void> switchStyle({required bool IsDark}) async {
    _isDark = IsDark;
    await prefs.setBool('isDark', IsDark);
    changeStyle(IsDark: _isDark);
    notifyListeners();
  }

  void changeStyle({required bool IsDark}) {
    primary = IsDark ? const Color(0xff62E185) : const Color(0xff62E185);
    primaryBackground =
        IsDark ? const Color(0xff4c4f4d) : const Color(0xffe9f3ee);
    error = const Color(0xffef467d);
    WB = IsDark ? const Color(0xff2b2b2b) : const Color(0xffffffff);
    BW = IsDark ? const Color(0xffffffff) : const Color(0xff2b2b2b);
    activeButtonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(primary),
      elevation: MaterialStateProperty.all(0),
    );
    passiveButtonStyle = IsDark
        ? ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryBackground),
            elevation: MaterialStateProperty.all(0),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
          )
        : ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryBackground),
            elevation: MaterialStateProperty.all(0),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
          );
    activeButtonTextColor =
        IsDark ? const Color(0xff4c4f4d) : const Color(0xffffffff);
    passiveButtonTextColor = IsDark ? const Color(0xffdcdcdc) : primary;
    notifyListeners();
  }

  Future asyncFunc() async {
    prefs = await SharedPreferences.getInstance();
  }
}
