import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:weqaya/components/components.dart';
import 'package:weqaya/components/provider.dart';
import 'package:weqaya/components/stuff.dart';
import 'package:weqaya/screens/MedicalPosts/medicalPostNew.dart';
import 'package:weqaya/components/mainAppBar.dart';
import 'package:weqaya/components/mainDrawer.dart';

class MedicalPostView extends StatelessWidget {
  final DocumentSnapshot post;
  const MedicalPostView({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.00),
        child: CustomAppBar(pageName: post['postSection']),
      ),
      endDrawer: const MainDrawer(),
      body: ScreenLayout(
        mobile: SingleChildScrollView(child: _viewPost(context)),

        tablet: SingleChildScrollView(
          child: Container(
            child: _viewPost(context),
          ),
        ),

        web: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              constraints: const BoxConstraints(
                maxWidth: 1000,
              ),
              child: _viewPost(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _viewPost(context) {
    String role = Provider.of<SettingProvider>(context).userRole;
    String loginID = Provider.of<SettingProvider>(context).userID;
    CollectionReference postDetailsRef = FirebaseFirestore.instance.collection('medicalPosts');
    return Column(
      children: [
        const SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (role == "Super" || loginID == post['postUser']) ?
            IconButton(
              onPressed: () {
                Env.goto(context, NewPost(docID: post.id, subject: post['postSubject'],));
              },
              icon: const Icon(Icons.edit, size: 30,),
            ) : Container(),
            Text(post['postSubject'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          ],
        ),
        const SizedBox(height: 10),
        Directionality(
          textDirection: TextDirection.rtl,
          child: StreamBuilder(
            stream: postDetailsRef.doc(post.id).collection('postDetails').orderBy("pdEntryTime", descending: false).snapshots(),
            builder:  (context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasData){
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index){
                    var postDetails = snapshot.data!.docs[index];
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(postDetails['pdSubject'], textAlign: TextAlign.right,style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          Text(postDetails['pdContent']),
                          postDetails['pdPhoto']!=null ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0, top: 10),
                              child: CachedNetworkImage(
                                  imageUrl: postDetails['pdPhoto'],
                                  progressIndicatorBuilder: (context, url, downloadProgress) {
                                    return SpinKitFadingCube(
                                      color: Env.appColor,
                                    );
                                  }
                              ),
                            ),
                          ) : Container(),
                          const SizedBox(height: 20,),
                        ],
                      );
                    },
                  );
                }else if(snapshot.hasError){
                  return Center(
                    child: SpinKitCircle(
                      color: Env.appColor,
                      size: 150,
                    ),
                  );
                }else if(snapshot.connectionState == ConnectionState.waiting){
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
          ),
        ),
        const Divider(
          height: 5,
          color: Colors.grey,
        ),
        OperationButtons(
          docID: post.id,
          collection: 'medicalPosts',
          showField: "postShow",
          verifyField: "postVerify",
          docAddBy: post['postUser'],
          isVerified: post['postVerify'].toString(),
          isShow: "true",
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}