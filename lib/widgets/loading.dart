import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:treiber_for_agent/providers/style.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final styleProvider = Provider.of<StyleProvider>(context);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitWave(color: styleProvider.primary),
        ],
      ),
    );
  }
}
