import 'package:cloud_firestore/cloud_firestore.dart';

class AgentMessageModel {
  static const collection = 'agentMessage';

  static const TITLE = 'title';
  static const MESSAGE = 'message';

  String _title = '未設定';
  String _message = '未設定';

  String get title => _title;

  String get message => _message;

  AgentMessageModel() {
    _title;
    _message;
  }

  AgentMessageModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    _title = snapshot.data()![TITLE] ?? '未設定';
    _message = snapshot.data()![MESSAGE] ?? '未設定';
  }
}
