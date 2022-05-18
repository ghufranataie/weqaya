import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:weqaya/components/stuff.dart';
import 'package:weqaya/components/provider.dart';
import 'package:intl/intl.dart';
import 'medicalPostView.dart';

class PendingPosts extends StatefulWidget {
  const PendingPosts({Key? key}) : super(key: key);

  @override
  _PendingPostsState createState() => _PendingPostsState();
}

class _PendingPostsState extends State<PendingPosts> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<SettingProvider>(context, listen: false).getUserRole();
  }
  @override
  Widget build(BuildContext context) {
    CollectionReference postRef = FirebaseFirestore.instance.collection('medicalPosts');
    return StreamBuilder(
        stream: Provider.of<SettingProvider>(context).userRole=="Super" ?
        postRef.where("postShow", isEqualTo: false).snapshots():
        postRef.where("postShow", isEqualTo: false).where("postUser", isEqualTo: _auth.currentUser!.uid).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 260, mainAxisExtent: 150),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index){
                var post = snapshot.data!.docs[index];
                 final f = DateFormat('yyyy-MM-dd hh:mm');
                 DateTime date = post['postEntryTime'].toDate();
                return GestureDetector(
                  onTap: () => Env.goto(context, MedicalPostView(post: post)),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    elevation: 5.0,
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            Text(post['postSubject'], textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(post['postSection']),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(f.format(date), style: TextStyle(color: Colors.grey.shade300),),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: SpinKitCircle(
              color: Env.appColor,
              size: 150,
            ),
          );
        }
    );
  }
}
