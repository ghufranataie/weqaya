// ignore_for_file: file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weqaya/components/components.dart';
import 'package:weqaya/screens/MedicalPosts/medicalPostNew.dart';
import 'package:weqaya/screens/MedicalPosts/medicalPosts.dart';
import 'package:weqaya/components/stuff.dart';

import '../../components/mainAppBar.dart';
import '../../components/mainDrawer.dart';

class PostCategory extends StatefulWidget {
  const PostCategory({Key? key}) : super(key: key);
  @override
  _PostCategoryState createState() => _PostCategoryState();
}

class _PostCategoryState extends State<PostCategory> {
  Env env = Env();
  final GlobalKey<FormState> _newPostKey = GlobalKey<FormState>();
  final TextEditingController _postSubject = TextEditingController();
  String? _postSection;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50.00),
          child: CustomAppBar(pageName: "کتگوری"),
        ),
        endDrawer: const MainDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(context: context, builder: (context){
            return Form(
              key: _newPostKey,
              child: SimpleDialog(
                contentPadding: const EdgeInsets.all(20),
                title: const Text("مشخصات اولیه", textAlign: TextAlign.center,),
                alignment: Alignment.center,
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: InputSingleText(
                      controller: _postSubject,
                      maxLine: 1,
                      isMandatory: true,
                      radius: 10,
                      maxLength: 50,
                      hintText: "عنوان موضوع",
                      labelText: "عنوان موضوع",
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: DropdownButtonFormField(
                        value: _postSection,
                        alignment: Alignment.center,
                        validator: (String? val) {
                          if (val == null) {
                            return 'انتخاب بخش کتگوری ضروری میباشد';
                          }
                          return null;
                        },
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: "کتگوری موضوع",
                          errorStyle: const TextStyle(height: 0.5, fontSize: 12),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Env.appColor, width: 2),
                          ),
                        ),
                        hint: Text(Env.postCategory[0]),
                        onChanged: (String? val) =>
                            setState(() => _postSection = val!),
                        items: Env.postCategory
                            .map<DropdownMenuItem<String>>((String T) {
                          return DropdownMenuItem<String>(
                            value: T,
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(T, textAlign: TextAlign.center),
                            ),
                          ); //DropMenuItem
                        }).toList(),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: const Text("ادامه"),
                    onPressed: () async{
                      if(_newPostKey.currentState!.validate()){
                        await FirebaseFirestore.instance.collection("medicalPosts").add({
                          "postSubject": _postSubject.text,
                          "postSection": _postSection,
                          "postVerify": false,
                          "postUser": _auth.currentUser!.uid,
                          "postEntryTime": DateTime.now(),
                          "postShow": false,
                        }).then((value){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NewPost(docID: value.id, subject: _postSubject.text)));
                        });
                      }
                    },
                  ),
                ],
              ),
            );
          });
        },
        child: const Icon(Icons.add),
      ),
      body: ScreenLayout(
        mobile: Container(
          padding: const EdgeInsets.all(20),
          child: _postCategories(),
        ),
        tablet: Container(
          padding: const EdgeInsets.all(20),
          child: _postCategories(),
        ),
        web: Container(
          padding: const EdgeInsets.all(20),
          child: _postCategories(),
        ),
      )
    );
  }
  Widget _postCategories(){
    CollectionReference postCategories = FirebaseFirestore.instance.collection('medicalPostCategory');
    return StreamBuilder(
      stream: postCategories.where("mpcShow", isEqualTo: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasData){
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 160, mainAxisExtent: 170),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
              var posts = snapshot.data!.docs[index];
              return GestureDetector(
                onTap: () => Env.goto(context, MedicalPosts(categoryName: posts['mpcName'])),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  elevation: 5.0,
                  color: Env.appColorLight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      posts['mpcIcon'] != "" ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: CachedNetworkImage(
                            height: 60,
                            width: 60,
                            imageUrl: posts['mpcIcon'],
                            progressIndicatorBuilder: (context, url, downloadProgress) {
                              return SpinKitFadingCube(
                                color: Env.appColor,
                              );
                            },
                          ),
                        ),
                      ) :
                      const SizedBox(
                        height: 60,
                        width: 60,
                        child: SpinKitCubeGrid(
                          size: 50,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(posts['mpcName'], style: const TextStyle(fontSize: 20), textAlign: TextAlign.center,),
                    ],
                  ),
                ),
              );
            },
          );
        } else if(snapshot.hasError){
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("The Error is " + snapshot.error.toString()),
                const SizedBox(height: 50),
                SpinKitCircle(
                  color: Env.appColor,
                  size: 150,
                ),
              ],
            ),
          );
        } else if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Loading Data..."),
                const SizedBox(height: 50),
                SpinKitCircle(
                  color: Env.appColor,
                  size: 150,
                ),
              ],
            ),
          );
        }
        return  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("No Data"),
              const SizedBox(height: 50),
              SpinKitCircle(
                color: Env.appColor,
                size: 150,
              ),
            ],
          ),
        );
      },
    );
  }
}