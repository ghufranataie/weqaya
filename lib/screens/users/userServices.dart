// ignore_for_file: file_names
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:weqaya/components/stuff.dart';
import 'package:weqaya/screens/check.dart';

class UserServices {
  Env env = Env();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final FirebaseAuthWeb _authWeb = FirebaseAuthWeb.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  List<String> gData = [];

  // Create new user and add to users collection in firestore database
  Future newUser(id, bool isDoctor, fullName, phone, email, specialization, field, city, address, photo) async {
    var doctorData = {
      "docGender": null,
      "docFullName": fullName,
      "docPhone": phone,
      "docEmail": email,
      "docBio": "",
      "docSpecialization": specialization,
      "docField": field,
      "docCity": city,
      "docWorkAddress": address,
      "docPhotoUrl": photo,
      "docEntryTime": DateTime.now(),
      "docAddBy": id,
      "docVerify": false,
      "docShow": false,
    };
    var regularData = {
      "usrFullName": fullName,
      "usrPhone": phone,
      "usrEmail": email,
      "usrType": isDoctor == true ? "Doctor" : "Regular",
      "usrCity": city,
      "usrPhotoUrl": photo,
      "usrEntryTime": DateTime.now(),
      "usrVerify": false,
    };
    if (isDoctor == true) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .set(regularData);
      await FirebaseFirestore.instance
          .collection("doctors")
          .doc(id)
          .set(doctorData);
    } else {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .set(regularData);
    }
  }

  // Create user with email and password
  Future createUserWithEmail(String fullName, String email, String password, bool isDoctor, context) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      user!.updateDisplayName(fullName);
      newUser(user.uid, isDoctor, fullName, null, email, null, null, null, null,
          null);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Directionality(
                textDirection: TextDirection.rtl,
                child: Text("ایمیل قبلاً در سیستم مورد استفاده میباشد")),
          ));
          break;
        case 'invalid-email':
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Directionality(
                textDirection: TextDirection.rtl,
                child: Text("ایمیل اشتباه میباشد")),
          ));
          break;
        case 'operation-not-allowed':
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Directionality(
                textDirection: TextDirection.rtl,
                child: Text("این عملیات قابل اجرا نمیباشد")),
          ));
          break;
        case 'weak-password':
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Directionality(
                textDirection: TextDirection.rtl,
                child: Text("رمز شما مطابق قوانین رمز نگاری نمیباشد")),
          ));
          break;
      }
    }
  }

  // SignIn with created email and password
  Future signInWithEmail(String email, String password, context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Directionality(
                textDirection: TextDirection.rtl,
                child: Text("رمز شما اشتباه میباشد")),
          ));
          break;
        case 'invalid-email':
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Directionality(
                textDirection: TextDirection.rtl,
                child: Text("ایمیل اشتباه میباشد")),
          ));
          break;
        case 'user-disabled':
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Directionality(
                textDirection: TextDirection.rtl,
                child: Text("کاربر شما غیر فعال میباشد")),
          ));
          break;
        case 'user-not-found':
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Directionality(
                textDirection: TextDirection.rtl,
                child: Text("ایمیل شما راجستر نمیباشد")),
          ));
          break;
      }
    }
  }

  // SignIn with google account and store user details such as display name, photo url and email address in users collection
  Future<List<String>> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
      // Get User Information from google account and assign it to the string variables for storing them to users collection
      final googleResult = await _auth.signInWithCredential(authCredential);
      String uID = googleResult.user!.uid.toString();
      String fName = googleResult.user!.displayName.toString();
      String eMail = googleResult.user!.email.toString();
      String urlPhoto = googleResult.user!.photoURL.toString();
      gData = [uID, eMail, fName, urlPhoto];
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Directionality(
            textDirection: TextDirection.rtl, child: Text(e.code)),
      ));
    }
    return gData;
  }

  // Sign out from any logged in account
  Future signOut(context) async {
    if(kIsWeb){
      //await _googleSignIn.signOut();
      //await _authWeb.signOut();
      Env.goto(context, const CheckLogin());

    }else if(Platform.isAndroid || Platform.isIOS){
      await _googleSignIn.signOut();
      await _auth.signOut();
      Env.goto(context, const CheckLogin());
    }

  }

// Ask user whether he/she is a doctor or a regular user
  Future<bool> askUserType(BuildContext context) async {
    bool isDoctor = false;
    // set up the buttons
    Widget noButton = TextButton(
      child: const Text(
        "نخیر",
        style: TextStyle(fontSize: 18),
      ),
      onPressed: () async {
        isDoctor = false;
        Navigator.pop(context);
      },
    );
    Widget yesButton = TextButton(
      child: const Text(
        "بلی",
        style: TextStyle(fontSize: 18),
      ),
      onPressed: () {
        isDoctor = true;
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 350,
            decoration: BoxDecoration(
                color: Env.appColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "نوع کاربر (یوزر)",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          Center(
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: const Text(
                  "آیا شما داکتر هستید؟",
                  style: TextStyle(fontSize: 16),
                )),
          ),
          const Divider(
            height: 5,
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            noButton,
            yesButton,
          ],
        ),
      ],
    );

    // show the dialog
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dContext) {
        return Directionality(textDirection: TextDirection.rtl, child: alert);
      },
    );
    return isDoctor;
  }

  // Check if the email is already registered as user in database
  Future<int> checkIfUserExists(String email) async {
    List dataList = [];
    int check = 0;
    await FirebaseFirestore.instance
        .collection("users")
        .where("usrEmail", isEqualTo: email)
        .get()
        .then((value) => {
      for (var result in value.docs) {dataList.add(result.data())},
      //print(dataList[0]["usrEmail"]),
      if (dataList.isEmpty) {check = 0} else {check = 1}
    });
    return check;
  }
}
