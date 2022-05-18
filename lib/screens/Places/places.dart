import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weqaya/screens/Places/place_new.dart';
import 'package:weqaya/components/stuff.dart';
import 'package:weqaya/components/mainAppBar.dart';

class Places extends StatelessWidget {
  const Places({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference ref = FirebaseFirestore.instance.collection('places');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const NewPlace())),
        child: const Icon(Icons.add),
      ),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.00),
        child: CustomAppBar(),
      ),
      body: StreamBuilder(
        stream: ref.where("plcShow", isEqualTo: true ).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 350, mainAxisExtent: 210),
              padding: const EdgeInsets.all(10),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,index){
                var plc = snapshot.data!.docs[index];
                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        //margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              //opacity: Op,
                              image: NetworkImage(plc['plcPhoto']),
                            )
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red,
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.teal,
                            ],
                            stops: [0.0, 1.0],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        top: 5,
                        child: Container(
                          height: 60,
                          width: 60,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: plc['plcType'] == "شفاخانه" ? Image.asset("assets/icons/clinic.png") : Image.asset("assets/icons/lab.png"),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        top: 100,
                        child: Text(plc['plcName']??"", textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18,),),
                      ),
                      Positioned(
                        right: 20,
                        top: 130,
                        child: Row(
                          children: [
                            Text(plc['plcCity']??"", textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14,),),
                            const SizedBox(width: 5),
                            const Icon(Icons.location_on, color: Colors.red, size: 15),                          ],
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 140,
                        child: Row(
                          children: [
                            IconButton(onPressed: (){}, icon: const Icon(Icons.call, color: Colors.white)),
                            IconButton(onPressed: (){}, icon: const Icon(Icons.map, color: Colors.white)),
                            IconButton(onPressed: (){}, icon: const Icon(Icons.email, color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
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
