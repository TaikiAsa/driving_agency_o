import 'package:connectivity/connectivity.dart';
import 'package:treiber_for_agent/helpers/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier, WidgetsBindingObserver {
  var app = AppModel();
  final AppServices _appServices = AppServices();
  var isLoading = false;
  var isMaintenance = false;
  var maintenanceMassage = '';
  var _flag = true;
  var player;
  var _ap;
  final _connectivity = Connectivity();
  var isOnline = false;
  var _screenStatus = 'HOME';
  var _screenStatusIndex = 1;

  String get ScreenStatus => _screenStatus;
  int get ScreenStatusIndex => _screenStatusIndex;

  final ScreenStatusList = [
    'MESSAGE',
    'HOME',
    'SETTING',
  ];

  AppProvider.initialize() {
    confirmMaintenance();
    if (!kIsWeb) {
      // player = AudioCache();
      // _ap = AudioPlayer();
    }
    WidgetsBinding.instance!.addObserver(this);
    startMonitoring();
    notifyListeners();
  }

  void onBottomItemTapped(int index) {
    _screenStatus = ScreenStatusList[index];
    _screenStatusIndex = index;
    notifyListeners();
  }

  void startMonitoring() async {
    await initConnectivity();
    _connectivity.onConnectivityChanged.listen((result) async {
      if (result == ConnectivityResult.none) {
        isOnline = false;
        notifyListeners();
      } else {
        await _updateConnectionStatus(result).then((bool isConnected) {
          isOnline = isConnected;
          notifyListeners();
        });
        notifyListeners();
      }
    });
  }

  Future<void> initConnectivity() async {
    var status = await _connectivity.checkConnectivity();

    if (status == ConnectivityResult.none) {
      isOnline = false;
      notifyListeners();
    } else {
      isOnline = true;
      notifyListeners();
    }
  }

  Future<bool> _updateConnectionStatus(ConnectivityResult result) async {
    var isConnected = false;
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        isConnected = true;
        break;
      case ConnectivityResult.none:
        isConnected = false;
        break;
      default:
        isConnected = false;
        break;
    }
    return isConnected;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // アプリが復帰した(resumed)時に実行したい処理;
      confirmMaintenance();
    } else if (state == AppLifecycleState.inactive) {
      // アプリが非アクティブ化した(inactive)時に実行したい処理;
    }
  }

  void confirmMaintenance() async {
    app = await _appServices.isMaintenance();
    isMaintenance = app.isMaintenance;
    maintenanceMassage = app.maintenanceMassage;
    notifyListeners();
  }

  void loopAlert() async {
    if (_flag) {
      _ap = await player.loop('sounds/alert.mp3');
      _flag = false;
    }
    notifyListeners();
  }

  Future<void> stopAlert() async {
    await _ap!.stop();
    _flag = true;
    notifyListeners();
  }

  void initContext({required BuildContext context}) {}

  void changeLoading() {
    isLoading = !isLoading;

    print('========');
    print('Loading : $isLoading');
    print('========');

    notifyListeners();
  }
}
