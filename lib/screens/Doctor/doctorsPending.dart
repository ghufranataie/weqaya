// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:weqaya/components/provider.dart';
import 'package:weqaya/screens/Doctor/doctorView.dart';
import 'package:weqaya/components/stuff.dart';

class PendingDoctors extends StatefulWidget {
  const PendingDoctors({Key? key}) : super(key: key);

  @override
  _PendingDoctorsState createState() => _PendingDoctorsState();
}

class _PendingDoctorsState extends State<PendingDoctors> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference doctorsRef = FirebaseFirestore.instance.collection('doctors');
    return StreamBuilder(
        stream: Provider.of<SettingProvider>(context).userRole == "Super" ?
        doctorsRef.where("docShow", isEqualTo: false).snapshots() :
        doctorsRef.where("docShow", isEqualTo: false).where("docAddBy", isEqualTo: _auth.currentUser!.uid).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250, mainAxisExtent: 200),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs[index];
                  return GestureDetector(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      elevation: 5.0,
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipOval(
                                child: doc['docPhotoUrl'] == null
                                    ? Image.asset("assets/images/drPhoto.png",
                                    width: 80)
                                    : Image.network(doc['docPhotoUrl'],
                                    width: 80),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: doc['docVerify'] == true ?
                                Container(
                                  decoration: const BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.white,
                                            spreadRadius: 1,
                                            blurRadius: 10
                                        )
                                      ]
                                  ),
                                  child: const Icon(
                                    Icons.verified_rounded, size: 25,),
                                ) :
                                Container(),
                              ),
                            ],
                          ),
                          Text(
                            doc['docFullName'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                doc['docCity'] ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    doc['docSpecialization'] ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.grey, height: 1, fontSize: 10),
                                  ),
                                  const Text("  "),
                                  Text(
                                    doc['docField'] ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.grey, height: 1, fontSize: 10),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                    onTap: () => Env.goto(context, ViewDoctor(docID: doc.id)),
                  );
                },
              ),
            );
          } else if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: SpinKitCircle(
                color: Env.appColor,
                size: 150,
              ),
            );
          } else {
            return Center(
              child: SpinKitCircle(
                color: Env.appColor,
                size: 150,
              ),
            );
          }
        }
    );
  }
}