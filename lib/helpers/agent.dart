import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:treiber_for_agent/models/agent.dart';
import 'package:treiber_for_agent/models/agentMessage.dart';

class AgentServices {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final geo = Geoflutterfire();

  Future<AgentModel> getAgentData({required String agentId}) async {
    var agent = AgentModel();
    await _fireStore
        .collection(AgentModel.collection)
        .doc(agentId)
        .get()
        .then((doc) => {agent = AgentModel.fromSnapshot(doc)})
        .catchError((e) {
      throw e;
    });
    return agent;
  }

  Future<void> updateAgentBasicData({
    required String agentId,
    required String companyName,
    required String phoneNumber,
    required String prefecture,
    required String municipalities,
    required String address,
    required String fee,
    required String waitingTime,
  }) async {
    await _fireStore.collection(AgentModel.collection).doc(agentId).update({
      'agentId': agentId,
      'companyName': companyName,
      'phoneNumber': phoneNumber,
      'prefecture': prefecture,
      'municipalities': municipalities,
      'address': address,
      'fee': fee,
      'waitingTime': waitingTime
    }).catchError((e) {
      throw e;
    });
  }

  Future<void> updateAgentLocation(
      {required String agentId,
      required double lat,
      required double long}) async {
    var myLocation = geo.point(latitude: lat, longitude: long);
    await _fireStore.collection(AgentModel.collection).doc(agentId).update({
      'location': myLocation.data,
      'geoHash': myLocation.hash,
      'lat': myLocation.latitude,
      'lng': myLocation.longitude
    }).catchError((e) {
      throw '位置情報の更新に失敗しました';
    });
  }

  Future<void> updateFcmToken(
      {required String agentId, required String token}) async {
    await _fireStore
        .collection(AgentModel.collection)
        .doc(agentId)
        .update({'fcmToken': token}).catchError((e) {
      throw '更新に失敗しました';
    });
  }

  Future initDeviceToken(
      {required String shopId, required String token}) async {
    if (!kIsWeb) {
      await _fireStore
          .collection(AgentModel.collection)
          .doc(shopId)
          .update({'fcmToken': token});
    } else {
      await _fireStore
          .collection(AgentModel.collection)
          .doc(shopId)
          .update({'webFcmToken': token});
    }
  }

  Future updateStringField(
      {required String agentId,
      required String fieldName,
      required String fieldValue}) async {
    await _fireStore
        .collection(AgentModel.collection)
        .doc(agentId)
        .update({fieldName: fieldValue}).catchError((e) {
      throw e;
    });
  }

  Future updateAgentMessage(
      {required String agentId,
      required String title,
      required String message}) async {
    await _fireStore
        .collection(AgentModel.collection)
        .doc(agentId)
        .collection(AgentMessageModel.collection)
        .doc(agentId)
        .update({'title': title, 'message': message}).catchError((e) {
      throw e;
    });
  }

  Future fetchAgentMessage({required String agentId}) async {
    var agentMessage;
    await _fireStore
        .collection(AgentModel.collection)
        .doc(agentId)
        .collection(AgentMessageModel.collection)
        .doc(agentId)
        .get()
        .then((doc) => {agentMessage = AgentMessageModel.fromSnapshot(doc)})
        .catchError((e) {
      throw e;
    });
    return agentMessage;
  }
}
