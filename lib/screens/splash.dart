import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treiber_for_agent/providers/style.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final styleProvider = Provider.of<StyleProvider>(context);
    return Scaffold(
      backgroundColor: styleProvider.primary,
      body: Center(
        child: Image.asset('assets/images/forDriverAppWhite.png'),
      ),
    );
  }
}
