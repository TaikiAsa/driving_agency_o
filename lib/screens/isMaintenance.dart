import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../providers/app.dart';
import '../widgets/loading.dart';

class isMaintenanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);

    return Scaffold(
        body: app.isLoading
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
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset('assets/images/shopLogo.png', width: 200, height: 200),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Sorry..',
                          style: TextStyle(fontSize: 50, color: Colors.black54),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Text(app.maintenanceMassage),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
