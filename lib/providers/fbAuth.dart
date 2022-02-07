import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:treiber_for_agent/helpers/agent.dart';
import 'package:treiber_for_agent/helpers/notification_handler.dart';
import 'package:treiber_for_agent/models/agent.dart';
import 'package:treiber_for_agent/models/agentMessage.dart';

enum AuthStatus {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated
}

enum LoginStatus { Agent, AgentTest, Undefined, Uninitialized }

class FbAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth;
  var _fbUser;
  var idToken;
  AuthStatus _authStatus = AuthStatus.Uninitialized;
  LoginStatus _loginStatus = LoginStatus.Uninitialized;

  //  getter
  AuthStatus get authStatus => _authStatus;

  LoginStatus get loginStatus => _loginStatus;

  User get fbUser => _fbUser;

  FbAuthProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen((var auth) async {
      if (auth == null) {
        _loginStatus = LoginStatus.Undefined;
        _authStatus = AuthStatus.Unauthenticated;
      } else {
        await _onStateChanged(auth);
        var _token = await NotificationService().getToken();
        await AgentServices()
            .updateFcmToken(agentId: _auth.currentUser!.uid, token: _token);
      }
    });
    notifyListeners();
  }

  // public variables
  final formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController newPasswordConfirm = TextEditingController();
  TextEditingController name = TextEditingController();

  Future<bool> signIn() async {
    try {
      _authStatus = AuthStatus.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());
      await _onStateChanged(_fbUser);
      notifyListeners();
      return true;
    } catch (e) {
      _authStatus = AuthStatus.Unauthenticated;
      print(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    await _auth.signOut();
    _authStatus = AuthStatus.Unauthenticated;
    _loginStatus = LoginStatus.Undefined;
    clearController();
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'success';
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
  }

  Future updatePassword() async {
    try {
      print(_auth.currentUser!.email);
      print(_auth.currentUser!.email);
      print(_auth.currentUser!.email);
      print(password.text.trim());
      print(password.text.trim());
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _auth.currentUser!.email.toString(),
          password: password.text.trim());
      await _auth.currentUser!.updatePassword(newPassword.text.trim());
      notifyListeners();
      return true;
    } catch (error) {
      return false;
    }
  }

  void clearController() {
    name.text = '';
    password.text = '';
    email.text = '';
  }

  Future initToken(String token) async {
    await AgentServices()
        .initDeviceToken(shopId: _auth.currentUser!.uid, token: token);
  }

  Future<String> getCustomClaimStatus() async {
    Map<String, dynamic>? _claims;
    idToken = await _auth.currentUser!
        .getIdTokenResult(true)
        .then((result) => {_claims = result.claims});
    var status = _claims!['status'];
    status ??= 'None';
    return status;
  }

  // fetch専用
  AgentModel _agentForFetch = AgentModel();
  AgentMessageModel _agentMessageForFetch = AgentMessageModel();

  AgentModel get agentForFetch => _agentForFetch;

  AgentMessageModel get agentMessageForFetch => _agentMessageForFetch;

  Future fetchAgent({required String agentId}) async {
    try {
      _agentForFetch = await AgentServices().getAgentData(agentId: agentId);
      _agentMessageForFetch =
          await AgentServices().fetchAgentMessage(agentId: agentId);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onStateChanged(User firebaseUser) async {
    _fbUser = firebaseUser;
    try {
      _authStatus = AuthStatus.Authenticated;
      var _status = await getCustomClaimStatus();
      await fetchAgent(agentId: _auth.currentUser!.uid);
      switch (_status) {
        case 'agent':
          _loginStatus = LoginStatus.Agent;
          break;
        case 'agentTest':
          _loginStatus = LoginStatus.AgentTest;
          break;
        default:
          _loginStatus = LoginStatus.Undefined;
          break;
      }
    } catch (e) {
      _loginStatus = LoginStatus.Undefined;
    }
    notifyListeners();
  }
}
