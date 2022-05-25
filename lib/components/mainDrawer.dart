import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weqaya/screens/Dashboard/home.dart';
import 'package:weqaya/screens/Dashboard/pending_bar.dart';
import 'package:weqaya/screens/contactUs.dart';
import 'package:weqaya/screens/soon.dart';
import 'package:weqaya/screens/users/userServices.dart';
import 'package:weqaya/components/stuff.dart';

import '../screens/aboutUs.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}
class _MainDrawerState extends State<MainDrawer> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Env env = Env();
  UserServices us = UserServices();
  String usrFullName = "";
  String noPhotoUrl = "https://firebasestorage.googleapis.com/v0/b/weqaya-sehat-d2bf3.appspot.com/o/noPhoto.png?alt=media&token=6f611d4f-bc68-4c7f-86ac-277cec3e04c3";
  String pendingPosts = "0";


  inputData() async {
    final User? user = _auth.currentUser;
    DocumentSnapshot<Map<String, dynamic>> snapshot =  await FirebaseFirestore.instance
        .collection("users").doc(user!.uid).get();
    usrFullName = snapshot['usrFullName'];
  }

  getPending(String collectionName, String fieldName) async {
    QuerySnapshot _docs = await FirebaseFirestore.instance.collection(collectionName).where(fieldName, isEqualTo: false).get();
    List<DocumentSnapshot> _docsCount = _docs.docs;
    setState(() {
      pendingPosts = _docsCount.length.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getPending('medicalPosts', "postVerify").toString();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    return Drawer(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(
                    height: 180,
                    child: DrawerHeader(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: Env.appColor,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(user!.photoURL ?? noPhotoUrl),
                            ),
                            Text(user.displayName.toString(), style: const TextStyle(color: Colors.white, fontSize: 18),),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: ListTile(
                      leading: const Icon(Icons.home_max_outlined),
                      title: const Text("خانه"),
                      onTap: (){
                        Navigator.of(context).pop();
                        Env.goto(context, const Home());
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: ListTile(
                      leading: const Icon(Icons.account_circle_sharp),
                      title: const Text("مشخصات کاربر"),
                      onTap: (){
                        Navigator.of(context).pop();
                        Env.goto(context, const Soon(pageName: "مشخصات یوزر",));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text("تنظیمات"),
                        onTap: (){
                          Navigator.of(context).pop();
                          Env.goto(context, const Soon(pageName: "تنظیمات",));
                        },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: ListTile(
                        leading: const Icon(Icons.pending),
                        title: const Text("تائیده نشده ها"),
                        onTap: () {
                          Navigator.of(context).pop();
                          Env.goto(context, const PendingBar());
                        },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text("در باره ما"),
                      onTap: () {
                        Navigator.of(context).pop();
                        Env.goto(context, const AboutUs());
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: ListTile(
                      leading: const Icon(Icons.contact_support),
                      title: const Text("تماس با ما"),
                      onTap: () {
                        Navigator.of(context).pop();
                        Env.goto(context, const ContactUs());
                      }
                    ),
                  ),
                ],
              ),
            ),
            Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Divider(),
                    ListTile(
                      contentPadding: const EdgeInsets.only(right: 50),
                      leading: const Icon(Icons.logout),
                      title: const Text('خروج'),
                      onTap: () async {
                        await us.signOut(context);
                      },
                    ),
                  ],
                )),
          ],
        )
        ),
      );
  }
}