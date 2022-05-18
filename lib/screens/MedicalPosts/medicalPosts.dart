// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readmore/readmore.dart';
import 'package:weqaya/components/components.dart';
import 'package:weqaya/components/stuff.dart';
import 'package:weqaya/screens/MedicalPosts/medicalPostView.dart';
import 'package:weqaya/components/mainAppBar.dart';
import 'package:weqaya/components/mainDrawer.dart';

class MedicalPosts extends StatelessWidget {
  final String? categoryName;
  const MedicalPosts({Key? key, this.categoryName}) : super(key: key);
  // final DocumentSnapshot category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.00),
          child: CustomAppBar(pageName: categoryName),
        ),
        endDrawer: const MainDrawer(),
        body: ScreenLayout(
          mobile: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: loadPosts(categoryName!),
          ),
          tablet: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: loadPosts(categoryName!),
          ),
          web: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 1000
              ),
              child: loadPosts(categoryName!),
            ),
          ),
        ));
  }
}

Widget loadPosts(String catName) {
  CollectionReference ref = FirebaseFirestore.instance.collection('medicalPosts');
  //MedicalPosts mp = const MedicalPosts();
  return StreamBuilder(
    stream: ref
        .where("postShow", isEqualTo: true)
        .where("postSection", isEqualTo: catName)
        .snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

      if(snapshot.hasData){
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var posts = snapshot.data!.docs[index];
            return GestureDetector(
              onTap: () => Env.goto(context, MedicalPostView(post: posts,)),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                elevation: 5,
                child: Container(
                  height: 100,
                  //color: Colors.teal.shade200,
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(posts['postSubject'] ?? "", textAlign: TextAlign.right, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        ),
                        postDetails(posts.id),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }else if(snapshot.data == null){
        return const Center(child: Text("معلومات موجود نمیباشد"));
      }else{
        return const Text("Empty");
      }

      // if (snapshot.hasData) {
      //   return ListView.builder(
      //     itemCount: snapshot.data!.docs.length,
      //     itemBuilder: (context, index) {
      //       var posts = snapshot.data!.docs[index];
      //       return GestureDetector(
      //         onTap: () => Env.goto(context, MedicalPostView(post: posts,)),
      //         child: Card(
      //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      //           elevation: 5,
      //           child: Container(
      //             height: 100,
      //             //color: Colors.teal.shade200,
      //             margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      //             child: SingleChildScrollView(
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.end,
      //                 children: [
      //                   Padding(
      //                     padding: const EdgeInsets.only(right: 20),
      //                     child: Text(posts['postSubject'] ?? "", textAlign: TextAlign.right, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
      //                   ),
      //                   postDetails(posts.id),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ),
      //       );
      //     },
      //   );
      // } else if (snapshot.connectionState == ConnectionState.waiting) {
      //   return Center(
      //     child: SpinKitCircle(
      //       color: Env.appColor,
      //       size: 150,
      //     ),
      //   );
      // } else if(snapshot.data == null) {
      //   return const Center(child: Text("معلومات موجود نمیباشد"));
      // }else{
      //   return Center(
      //     child: SpinKitCircle(
      //       color: Env.appColor,
      //       size: 150,
      //     ),
      //   );
      // }
    },
  );
}
Widget postDetails(String docID) {
  CollectionReference ref =
  FirebaseFirestore.instance.collection('medicalPosts');
  return StreamBuilder(
    stream: ref.doc(docID).collection('postDetails').snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasData) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index){
            var pd = snapshot.data!.docs[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                ReadMoreText(
                  pd['pdContent']?? "",
                  style: const TextStyle(color: Colors.grey),
                  trimLines: 1,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,

                ),
              ],
            );
          },
        );
      } else if (snapshot.hasError) {
        return Center(
          child: SpinKitCircle(
            color: Env.appColor,
            size: 150,
          ),
        );
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: SpinKitCircle(
            color: Env.appColor,
            size: 150,
          ),
        );
      }
      return Center(
        child: SpinKitCircle(
          color: Env.appColor,
          size: 150,
        ),
      );
    },
  );
}