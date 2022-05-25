import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weqaya/components/components.dart';

import '../components/mainAppBar.dart';
import '../components/mainDrawer.dart';
import '../components/stuff.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(pageName: "وقایه"),
      ),
      endDrawer: const MainDrawer(),
      body: ScreenLayout(
        mobile: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
              child: _loadAbout(),
            ),
          ),
        ),
        tablet: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(top: 30, left: 50, right: 50),
              child: _loadAbout(),
            ),
          ),
        ),
        web: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(top: 30),
              constraints: const BoxConstraints(
                maxWidth: 1000,
              ),
              child: _loadAbout(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loadAbout() {
    CollectionReference _ref = FirebaseFirestore.instance.collection('aboutUs');
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/icons/appLogo.png"),
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.1), BlendMode.dstATop),
      )),
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "در مورد وقایه",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
          StreamBuilder(
            stream: _ref.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: NoData(
                        content:
                            "معذرت میخواهیم داکتر مورد نظر دریافت نگردید!"),
                  );
                } else {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: Center(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var au = snapshot.data!.docs[index];
                          return Text(
                            au['content'],
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                          );
                        },
                      ),
                    ),
                  );
                }
              } else {
                return Center(
                  child: SpinKitCircle(
                    color: Env.appColor,
                    size: 150,
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 30),
          Column(
            children: [
              Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                  color: const Color(0xff7c94b6),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/ataie.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(100.0)),
                  border: Border.all(
                    color: Colors.teal,
                    width: 2.0,
                  ),
                ),
              ),
              const Text("غفران عطائی"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/icons/facebook.png", width: 20),
                  Image.asset("assets/icons/instagram.png", width: 20),
                  Image.asset("assets/icons/twitter.png", width: 20),
                  const SizedBox(width: 20),
                  const Text("@ghufranatie"),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ],
      ),
    );
  }
}
