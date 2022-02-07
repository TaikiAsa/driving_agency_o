import 'package:cloud_firestore/cloud_firestore.dart';

class AgentModel {
  static const collection = 'agents';

  static const AGENT_ID = 'agentId';
  static const MANAGER_ID = 'managerId';
  static const COMPANY_NAME = 'companyName';
  static const CONTROL_CODE = 'controlCode';
  static const PHONE_NUMBER = 'phoneNumber';
  static const PREFECTURE = 'prefecture';
  static const MUNICIPALITIES = 'municipalities';
  static const ADDRESS = 'address';
  static const FEE = 'fee';
  static const WAITING_TIME = 'waitingTime';
  static const CURRENT_STATE = 'currentState';
  static const LOCATION = 'location';
  static const GEO_HASH = 'geoHash';
  static const LAT = 'lat';
  static const LNG = 'lng';
  static const FCM_TOKEN = 'fcmToken';
  static const FAVORITES = 'favorites';
  static const PUBLISH = 'publish';
  static const AGENT_MESSAGE = 'agentMessage';
  static const IS_EFFECTIVE_ACCOUNT = 'isEffectiveAccount';

  String _agentId = 'undefined';
  String _managerId = 'undefined';
  String _companyName = 'undefined';
  String _controlCode = 'undefined';
  String _phoneNumber = '';
  String _prefecture = '';
  String _municipalities = 'undefined';
  String _address = 'undefined';
  String _fee = 'undefined';
  String _waitingTime = '10';
  String _currentState = 'CLOSE';
  Map<String, dynamic> _location = <String, dynamic>{};
  String _geoHash = 'undefined';
  double _lat = 0.0;
  double _lng = 0.0;
  String _fcmToken = 'undefined';
  int _favorites = 0;
  bool _publish = false;
  bool _isEffectiveAccount = false;

  String get agentId => _agentId;

  String get managerId => _managerId;

  String get companyName => _companyName;

  String get controlCode => _controlCode;

  String get phoneNumber => _phoneNumber;

  String get prefecture => _prefecture;

  String get municipalities => _municipalities;

  String get address => _address;

  String get fee => _fee;

  String get waitingTime => _waitingTime;

  String get currentState => _currentState;

  Map<String, dynamic> get location => _location;

  String get geoHash => _geoHash;

  double get lat => _lat;

  double get lng => _lng;

  String get fcmToken => _fcmToken;

  int get favorites => _favorites;

  bool get publish => _publish;

  bool get isEffectiveAccount => _isEffectiveAccount;

  AgentModel() {
    _agentId;
    _managerId;
    _companyName;
    _controlCode;
    _phoneNumber;
    _prefecture;
    _municipalities;
    _address;
    _fee;
    _waitingTime;
    _currentState;
    _location;
    _geoHash;
    _lat;
    _lng;
    _fcmToken;
    _favorites;
    _publish;
    _isEffectiveAccount;
  }

  AgentModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    _agentId = snapshot.data()![AGENT_ID] ?? 'undefined';
    _managerId = snapshot.data()![MANAGER_ID] ?? 'undefined';
    _companyName = snapshot.data()![COMPANY_NAME] ?? 'undefined';
    _controlCode = snapshot.data()![CONTROL_CODE] ?? 'undefined';
    _phoneNumber = snapshot.data()![PHONE_NUMBER] ?? '0';
    _prefecture = snapshot.data()![PREFECTURE] ?? '';
    _municipalities = snapshot.data()![MUNICIPALITIES] ?? 'undefined';
    _address = snapshot.data()![ADDRESS] ?? 'undefined';
    _fee = snapshot.data()![FEE] ?? 'undefined';
    _waitingTime = snapshot.data()![WAITING_TIME] ?? '10';
    _currentState = snapshot.data()![CURRENT_STATE] ?? 'CLOSE';
    _location = Map<String, dynamic>.from(snapshot.data()![LOCATION] ?? {});
    _geoHash = snapshot.data()![GEO_HASH] ?? 'undefined';
    _lat = snapshot.data()![LAT] ?? 0.0;
    _lng = snapshot.data()![LNG] ?? 0.0;
    _fcmToken = snapshot.data()![FCM_TOKEN] ?? 'undefined';
    _favorites = snapshot.data()![FAVORITES] ?? 0;
    _publish = snapshot.data()![PUBLISH] ?? false;
    _isEffectiveAccount = snapshot.data()![IS_EFFECTIVE_ACCOUNT] ?? false;
  }
}
