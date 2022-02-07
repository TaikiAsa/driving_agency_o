import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treiber_for_agent/providers/agent.dart';
import 'package:treiber_for_agent/providers/app.dart';
import 'package:treiber_for_agent/providers/fbAuth.dart';
import 'package:treiber_for_agent/providers/style.dart';
import 'package:treiber_for_agent/screens/auth/login.dart';
import 'package:treiber_for_agent/screens/auth/not_agent.dart';
import 'package:treiber_for_agent/screens/isMaintenance.dart';
import 'package:treiber_for_agent/screens/lost_connection.dart';
import 'package:treiber_for_agent/screens/splash.dart';
import 'package:treiber_for_agent/screens/top.dart';
import 'package:treiber_for_agent/widgets/loading.dart';

import 'japanese_cupertino_localizations.dart';

Widget getErrorWidget(BuildContext context, FlutterErrorDetails error) {
  return const Center(
    child: Text(
      '接続エラー．しばらくお待ちください',
      style: TextStyle(color: Colors.redAccent),
    ),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  await runZonedGuarded<Future<void>>(() async {
    var prefs = await SharedPreferences.getInstance();
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppProvider.initialize()),
        ChangeNotifierProvider.value(
            value: StyleProvider.initialize(initPrefs: prefs)),
        ChangeNotifierProvider.value(value: FbAuthProvider.initialize()),
        ChangeNotifierProvider.value(value: AgentProvider.initialize()),
      ],
      child: WidgetMain(),
    ));
  }, FirebaseCrashlytics.instance.recordError);
}

class WidgetMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final styleProvider = Provider.of<StyleProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'トライバ 車',
      theme: styleProvider.isDark
          ? ThemeData.dark().copyWith(
              primaryColor: styleProvider.primary,
              accentColor: styleProvider.error,
              splashColor: styleProvider.primary,
              errorColor: styleProvider.error,
            )
          : ThemeData.light().copyWith(
              primaryColor: styleProvider.primary,
              accentColor: styleProvider.error,
              splashColor: styleProvider.primary,
              errorColor: styleProvider.error,
            ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        JapaneseCupertinoLocalizations.delegate,
      ],
      builder: (BuildContext context, Widget? widget) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return getErrorWidget(context, errorDetails);
        };
        return widget!;
      },
      supportedLocales: [
        const Locale('ja', 'JP'),
      ],
      home: ScreensController(),
    );
  }
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<FbAuthProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    if (!appProvider.isOnline) return LostConnectionScreen();
    if (appProvider.isMaintenance) return isMaintenanceScreen();

    switch (authProvider.authStatus) {
      case AuthStatus.Uninitialized:
        return Loading();
      case AuthStatus.Unauthenticated:
        return LoginScreen();
      case AuthStatus.Authenticating:
        return LoginScreen();
      case AuthStatus.Authenticated:
        if (authProvider.loginStatus == LoginStatus.Agent ||
            authProvider.loginStatus == LoginStatus.AgentTest) {
          return TopScreen();
        } else if (authProvider.loginStatus == LoginStatus.Uninitialized) {
          return Loading();
        } else {
          return NotAgentScreen();
        }
      default:
        return SplashScreen();
    }
  }
}
