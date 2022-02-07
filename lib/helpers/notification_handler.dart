import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

// import 'package:order_app_shop/helpers/screen_navigation.dart';
// import 'package:order_app_shop/screens/nowOrder.dart';
import 'package:provider/provider.dart';
import 'package:treiber_for_agent/providers/style.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  String _token = '';

  BuildContext? _context;

  String get token => _token;

  Future<void> requestPermissions() async {
    await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
  }

  Future<String> getToken() async {
    // _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    // _tokenStream!.listen();

    if (!kIsWeb) {
      await messaging.getToken().then((String? token) {
        if (token == null) {
          return _token;
        }
        _token = token;
      });
    } else {
      await messaging
          .getToken(
              vapidKey:
                  '***********************')
          .then((String? token) {
        if (token == null) {
          return _token;
        }
        _token = token;
      }).catchError((e) {
        print(e.toString());
      });
    }

    return _token;
  }

  Future<void> initContext({required BuildContext context}) async {
    _context = context;
    await initNotification();
    await requestPermissions();
  }

  Future<void> initNotification() async {
    final styleProvider = Provider.of<StyleProvider>(_context!, listen: false);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await showPlatformDialog(
        context: _context!,
        builder: (_) => BasicDialogAlert(
          title: Text(message.notification!.title!),
          content: Text(message.notification!.body!),
          actions: <Widget>[
            BasicDialogAction(
              title: Text(
                'OK',
                style: TextStyle(color: styleProvider.primary),
              ),
              onPressed: () {
                Navigator.pop(_context!);
              },
            ),
          ],
        ),
      );
      // app.loopAlert();
      // changeScreen(_context!, NowOrder());
      // var notification = message.notification;
      // var android = message.notification?.android;
      // if (notification != null && android != null) {
      //   app.loopAlert();
      //   changeScreen(_context!, NowOrder());
      //   // flutterLocalNotificationsPlugin.show(
      //   //     notification.hashCode,
      //   //     notification.title,
      //   //     notification.body,
      //   //     NotificationDetails(
      //   //       android: AndroidNotificationDetails(
      //   //         channel.id,
      //   //         channel.name,
      //   //         channel.description,
      //   //         // TODO add a proper drawable resource to android, for now using
      //   //         //      one that already exists in example app.
      //   //         icon: 'launch_background',
      //   //       ),
      //   //     ));
      // } else {
      //   app.loopAlert();
      //   changeScreen(_context!, NowOrder());
      // }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
  }
}
