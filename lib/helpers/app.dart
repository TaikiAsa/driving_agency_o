import 'package:cloud_firestore/cloud_firestore.dart';

class AppServices {
  String collection = 'apps';
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<AppModel> isMaintenance() async {
    var app = AppModel();
    await _fireStore.collection(collection).doc('forDriver').get().then((doc) {
      app = AppModel.fromSnapshot(doc);
    }).catchError((e) {
      print(e);
    });
    return app;
  }
}

class AppModel {
  static const IS_MAINTENANCE = 'isMaintenance';
  static const MAINTENANCE_MASSAGE = 'maintenanceMassage';

  bool _isMaintenance = false;
  String _maintenanceMassage = '';

//  getters
  bool get isMaintenance => _isMaintenance;

  String get maintenanceMassage => _maintenanceMassage;

  AppModel() {
    _isMaintenance;
    _maintenanceMassage;
  }

  AppModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    _isMaintenance = snapshot.data()![IS_MAINTENANCE];
    _maintenanceMassage = snapshot.data()![MAINTENANCE_MASSAGE];
  }
}
