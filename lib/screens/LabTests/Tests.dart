import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weqaya/screens/LabTests/labTest_new.dart';
import 'package:weqaya/screens/LabTests/labTest_single.dart';
import 'package:weqaya/components/stuff.dart';

import '../../components/mainAppBar.dart';

class Tests extends StatelessWidget {
  const Tests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference ref = FirebaseFirestore.instance.collection('medicalTests');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Env.goto(context, const NewTest()),
        child: const Icon(Icons.add),
      ),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.00),
        child: CustomAppBar(),
      ),
      body: StreamBuilder(
        stream: ref.where("tstVerify", isEqualTo: true ).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,index){
                var doc = snapshot.data!.docs[index];
                return InkWell(
                  onTap: () => Env.goto(context, SingleTest(doc:doc)),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: const Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 1, 186, 118),
                                Color(0xFFFFFFFF),
                              ],
                              begin: FractionalOffset(0.0, 0.0),
                              end: FractionalOffset(0.6, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const ClipRRect(
                                borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
                                // child: doc['plcPhoto'] != null ?
                                // Image.network(doc['plcPhoto'], width: 110, height: 100, fit: BoxFit.cover,) :
                                // Image.asset("assets/images/photo.png", width: 110, height: 100, fit: BoxFit.cover,),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 150, child: Text(doc['tstName'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, size: 10,),
                                        const SizedBox(width: 5,),
                                        Text(snapshot.data!.docs[index].id,  style: const TextStyle(fontSize: 10),)
                                      ],),
                                    Row(
                                      children: const [
                                        Icon(Icons.phone, size: 10),
                                        SizedBox(width: 5,),
                                        // Text(doc['plcContact'],  style: TextStyle(fontSize: 10),)
                                      ],),
                                    // Row(children: [
                                    //   Icon(Icons.location_on, size: 10,),
                                    //   SizedBox(width: 5,),
                                    //   SizedBox(
                                    //     width: 150,
                                    //     child: Text(doc['plcAddress'],overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10),),)
                                    // ],)
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: const Icon(Icons.local_hospital, size: 30, color: Colors.red,),
                              ),
                              // ListTile(
                              //   title: Text(doc['plcName']),
                              //   subtitle: Column(
                              //     children: [
                              //       Row(
                              //         children: [
                              //           Icon(Icons.phone),
                              //           Text(doc['plcContact']),
                              //         ],
                              //       ),
                              //       Row(
                              //         children: [
                              //           Icon(Icons.location_on),
                              //           Text(doc['plcAddress']),
                              //         ],
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
    );
  }
}
