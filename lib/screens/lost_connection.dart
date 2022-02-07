import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../providers/app.dart';
import '../widgets/loading.dart';

class LostConnectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);

    var _padding = const EdgeInsets.all(8.0);

    if (MediaQuery.of(context).size.width > 600.0) {
      var _size = (MediaQuery.of(context).size.width - 600.0) / 2;
      _padding = EdgeInsets.fromLTRB(_size, 8.0, _size, 8.0);
    }

    return Scaffold(
        body: app.isLoading
            ? Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Loading()],
                ),
              )
            : SafeArea(
                child: Padding(
                  padding: _padding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset('assets/images/forDriverMain.png',
                            width: 200, height: 200),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Sorry..',
                            style:
                                TextStyle(fontSize: 50, color: Colors.black54),
                          ),
                        ),
                      ),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(50.0),
                          child: Text('ネットワーク接続を確認できません'),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
