import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:weqaya/components/stuff.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Services{
  Env env = Env();

  static Future<String> checkConnection(context) async{
    String conStatus = "";
    final conResult = await Connectivity().checkConnectivity();

    if(conResult == ConnectivityResult.mobile || conResult == ConnectivityResult.wifi || conResult == ConnectivityResult.ethernet){
      try{
        final result = await InternetAddress.lookup('www.google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          conStatus = "success";
          return conStatus;
        }else{
          conStatus = "weak";
          return conStatus;
        }
      }on SocketException catch(_){
        conStatus = "weak";
        return conStatus;
      }
    }
      conStatus = "no connection";
      return conStatus;
  }

  static Future<String?> uploadFile(String destination, var imageFile) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("$destination/doctor"+DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(imageFile);
    var dowUrl = await (await uploadTask).ref.getDownloadURL();
    String url = dowUrl.toString();
    return url;
  }
  static Future<bool> addToCollection(String collectionName, var dataBody) async {
    bool check = false;
    await FirebaseFirestore.instance.collection(collectionName).add(dataBody).then((value){
      //print(value.toString());
      check = true;
    });
    return check;
  }
  static Future<bool> setToCollection(String collectionName, String docID, var dataBody) async {
    bool check = false;
    await FirebaseFirestore.instance.collection(collectionName).doc(docID).set(dataBody).then((value){
      check = true;
    });
    return check;
  }
  static Future<bool> updateToCollection(String collectionName, String docID, var dataBody) async {
    bool check = false;
    await FirebaseFirestore.instance.collection(collectionName).doc(docID).update(dataBody).then((value){
      check = true;
    });
    return check;
  }
  static Future<bool> addToSubCollection(String collectionName, var dataBody) async {
    bool check = false;
    await FirebaseFirestore.instance.collection(collectionName).add(dataBody).then((value){
      //print(value.toString());
      check = true;
    });
    return check;
  }
  static Future<File?> urlToFile(String imageUrl) async {
    var rng = Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File(tempPath+ (rng.nextInt(100)).toString() +'.jpg');
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }
}