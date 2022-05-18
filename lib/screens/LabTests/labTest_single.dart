import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weqaya/components/stuff.dart';
import '../../components/mainAppBar.dart';


class SingleTest extends StatelessWidget {
  final DocumentSnapshot doc;
  const SingleTest({Key? key, required this.doc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference ref = FirebaseFirestore.instance.collection('medicalTests').doc(doc.id).collection("medicalTestDetails");
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.00),
        child: CustomAppBar(),
      ),
      body: Column(
        children: [
          Text(doc['tstName']),
          Flexible(
            child: StreamBuilder(
              stream: ref.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.hasData){
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        var tstDetails = snapshot.data!.docs[index];
                        return Center(
                          child: Text(tstDetails['tsdName']),
                        );
                      }
                  );
                }else if (snapshot.hasError){
                  return Center(
                    child: SpinKitCircle(
                      color: Env.appColor,
                      size: 150,
                    ),
                  );
                } else if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: SpinKitCircle(
                      color: Env.appColor,
                      size: 150,
                    ),
                  );
                }
                return const Text("No Data");
              },
            ),
          ),
        ],
      ),
    );
  }
}
