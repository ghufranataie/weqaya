import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weqaya/screens/Dashboard/menu_services.dart';
import '../screens/Dashboard/dashboard_module.dart';

class SettingProvider extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userRole = "";
  String userID = "";
  List<MenuModel> menus = [];
  File? imageFile;
  String? imgUrl;


  void setImage(File imgFile){
    imageFile = imgFile;
    notifyListeners();
  }
  void setWebImage(String url){
    imgUrl = url;
    notifyListeners();
  }
  void clearImage(){
    imgUrl = null;
    imageFile = null;
    notifyListeners();
  }

  Future<void> getUserRole() async{
    DocumentReference usrRef = FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid);
    var myUser = await usrRef.get();
    userRole = myUser['usrType'];
    notifyListeners();
  }
  void getUserID() {
    userID = _auth.currentUser!.uid;
    notifyListeners();
  }
  Future<void> setupMenus() async {
    menus = await MenuServices.getMenus();
    notifyListeners();
  }
}