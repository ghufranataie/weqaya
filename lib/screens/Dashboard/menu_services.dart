import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard_module.dart';

class MenuServices{

  static Future<List<MenuModel>> getMenus() async {
    QuerySnapshot menuSnapshot = await FirebaseFirestore.instance
        .collection('homeItems')
        .orderBy("dateTime", descending: false)
        .where("verify", isEqualTo: true)
        .get();
    List<MenuModel> result = [];
    for (var doc in menuSnapshot.docs) {
      result.add(MenuModel.fromJson( doc.data() ));
    }
    return result;
  }
}