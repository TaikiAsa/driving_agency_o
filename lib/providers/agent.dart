import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:treiber_for_agent/helpers/agent.dart';
import 'package:treiber_for_agent/models/agent.dart';
import 'package:treiber_for_agent/models/agentMessage.dart';

class AgentProvider with ChangeNotifier {
  var agent = AgentModel();
  var agentMessage = AgentMessageModel();
  final AgentServices _agentServices = AgentServices();
  var position;
  var locationUpdateError = '';

  AgentProvider.initialize() {
    notifyListeners();
  }

  Future fetchAgent({required String agentId}) async {
    try {
      agent = await _agentServices.getAgentData(agentId: agentId);
      agentMessage = await _agentServices.fetchAgentMessage(agentId: agentId);
      phoneNumberControl.text = agent.phoneNumber;
      prefecture = agent.prefecture;
      municipalitiesControl.text = agent.municipalities;
      addressControl.text = agent.address;
      feeControl.text = agent.fee;
      waitingTimeControl.text = agent.waitingTime;
      agentMessageControl.text = agentMessage.message;
      agentMessageTitleControl.text = agentMessage.title;
      notifyListeners();
    } catch (e) {
      print(e);
      notifyListeners();
    }
  }

  Future fetchAgentFirst({required AgentModel fetchAgent}) async {
    agent = fetchAgent;
    notifyListeners();
  }

  void reFetchAgentController() {
    phoneNumberControl.text = agent.phoneNumber;
    prefecture = agent.prefecture;
    municipalitiesControl.text = agent.municipalities;
    addressControl.text = agent.address;
    feeControl.text = agent.fee;
    waitingTimeControl.text = agent.waitingTime;
  }

  Future getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('位置情報が取得できない為、位置情報の公開ができません。ご了承ください。');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('位置情報の取得が許可されませんでした。位置情報の公開はされません、ご了承ください。');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          '位置情報の取得を拒絶されました。位置情報の公開はされません、ご了承ください。また、本アプリに位置情報の取得を許可するには端末の設定から変更をお願いいたします。');
    }
    notifyListeners();
    return await Geolocator.getCurrentPosition();
  }

  Future<bool> setLocation({required String agentId}) async {
    try {
      position = await getLocation();
      await _agentServices.updateAgentLocation(
          agentId: agentId, lat: position.latitude, long: position.longitude);
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      locationUpdateError = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> updateCurrentState(
      {required String agentId, required String state}) async {
    try {
      await _agentServices.updateStringField(
          agentId: agentId, fieldName: 'currentState', fieldValue: state);
      notifyListeners();
    } catch (e) {
      print(e);
      notifyListeners();
    }
  }

  Future<void> updateWaitingTime(
      {required String agentId, required String time}) async {
    try {
      await _agentServices.updateStringField(
          agentId: agentId, fieldName: 'waitingTime', fieldValue: time);
      notifyListeners();
    } catch (e) {
      print(e);
      notifyListeners();
    }
  }

  final formKey = GlobalKey<FormState>();
  var prefecture;
  var phoneNumberControl = TextEditingController();
  var municipalitiesControl = TextEditingController();
  var addressControl = TextEditingController();
  var feeControl = TextEditingController();
  var waitingTimeControl = TextEditingController();
  var agentMessageControl = TextEditingController();
  var agentMessageTitleControl = TextEditingController();

  void clearController() {
    phoneNumberControl.text = '';
    municipalitiesControl.text = '';
    addressControl.text = '';
    feeControl.text = '';
    waitingTimeControl.text = '';
  }

  Future<bool> updateAgentBasicData({required String agentId}) async {
    await _agentServices
        .updateAgentBasicData(
            agentId: agentId,
            companyName: agent.companyName,
            phoneNumber: phoneNumberControl.text,
            prefecture: prefecture,
            municipalities: municipalitiesControl.text,
            address: addressControl.text,
            fee: feeControl.text,
            waitingTime: agent.waitingTime)
        .then((value) {
      notifyListeners();
      return true;
    }).catchError((e) {
      notifyListeners();
      return false;
    });
    return true;
  }

  Future updateAgentMessage({required String agentId}) async {
    await _agentServices
        .updateAgentMessage(
            agentId: agentId,
            title: agentMessageTitleControl.text.trim(),
            message: agentMessageControl.text.trim())
        .catchError((e) {
      notifyListeners();
      return false;
    });
    notifyListeners();
    return true;
  }
}
