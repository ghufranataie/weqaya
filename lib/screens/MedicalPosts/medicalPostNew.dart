// ignore_for_file: file_names
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:weqaya/components/components.dart';
import 'package:weqaya/components/provider.dart';
import 'package:weqaya/components/services.dart';
import 'package:weqaya/components/stuff.dart';
import 'package:weqaya/components/mainAppBar.dart';
import 'package:weqaya/components/mainDrawer.dart';

class NewPost extends StatefulWidget {
  final String? docID;
  final String? subject;
  const NewPost({Key? key, this.docID, this.subject}) : super(key: key);

  @override
  _NewPostState createState() => _NewPostState();
}
class _NewPostState extends State<NewPost> {
  Env env = Env();
  final GlobalKey<FormState> _postDetailsKey = GlobalKey<FormState>();
  final TextEditingController _subject = TextEditingController();
  final TextEditingController _body = TextEditingController();
  String? pdID = "";
  String? imgUrl;
  File? imgFile;
  final CollectionReference _ref = FirebaseFirestore.instance.collection('medicalPosts');
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    clear();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.00),
        child: CustomAppBar(pageName: widget.subject),
      ),
      endDrawer: const MainDrawer(),
      body: ScreenLayout(
        mobile: SingleChildScrollView(
          child: Container(
            child: _entryForm(),
          ),
        ),
        tablet: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: _entryForm(),
          ),
        ),
        web: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 1000
              ),
              child:  _entryForm(),
            ),
          ),),
      ),
    );
  }

  Widget _entryForm(){
    imgFile = Provider.of<SettingProvider>(context).imageFile;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Form(
          key: _postDetailsKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InputSingleText(
                controller: _subject,
                hintText: "عنوان موضوع",
                labelText: "عنوان موضوع",
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: InputText(
                  controller: _body,
                  labelText: "موضوع",
                  hintText: "موضوع",
                  maxLine: null,
                  maxLength: null,
                  isMandatory: true,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 110,
                    width: 150,
                    //color: Colors.red,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: SizedBox(
                            height: 110,
                              child: imgFile==null ? Image.asset("assets/images/image.png"): Image.file(imgFile!),
                          ),
                        ),
                        (imgFile == null) ? const SelectImageDialog(
                          cropHeight: 200,
                          cropWidth: 280,
                          icnColor: Colors.white,
                          icn: Icons.cloud_upload,
                        ) :
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            height: 30,
                            width: 30,
                            padding: EdgeInsets.zero,
                            margin: EdgeInsets.zero,
                            color: Colors.white,
                            child: IconButton(
                              onPressed: (){
                                Provider.of<SettingProvider>(context, listen: false).clearImage();
                              },
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.cancel_outlined, color: Colors.red, size: 30),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //child: Image.asset("assets/icons/appLogo.png"),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                          children: [
                            TextSpan(text: "نوت: ", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                            TextSpan(
                              style: TextStyle(color: Colors.black),
                              text: "اضافه نمودن تصویر در موضوع کاملاً اختیاری بوده و در صورت لزوم میتوانید تصویر مورد نظر مرتبط به موضوع را علاوه کنید در غیر آن میتوانید صرف نظر نمائید.",
                            ),
                          ]
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              RoundedButtonForm(
                enable: true,
                text: pdID == "" ? "اضافه کردن" : "ثبت تغییر",
                color: Env.appColor,
                press: () async {
                  if(_postDetailsKey.currentState!.validate()){
                    await modifyPostDetails();
                  }
                },
              ),
              _loadPostDetails(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _loadPostDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: StreamBuilder(
        stream: _ref.doc(widget.docID).collection('postDetails').orderBy("pdEntryTime", descending: false).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index){
                var pdList = snapshot.data!.docs[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 20),
                          Text(
                            pdList['pdSubject']??"",
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          IconButton(
                            onPressed: () async {
                              File? tmp;
                              _subject.text = pdList['pdSubject'];
                              _body.text = pdList['pdContent'];
                              pdID = pdList.id;
                              if(pdList['pdPhoto'] != null){
                                tmp = await Services.urlToFile(pdList['pdPhoto']);
                                Provider.of<SettingProvider>(context, listen: false).setImage(tmp!);
                              }else{
                                Provider.of<SettingProvider>(context, listen: false).clearImage();
                              }
                              _scrollController.animateTo(
                                0.0,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 300),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          pdList['pdContent']??"",
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    pdList['pdPhoto'] != null ?
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: CachedNetworkImage(
                          imageUrl: pdList['pdPhoto'],
                          progressIndicatorBuilder: (context, url, downloadProgress) {
                            return SpinKitFadingCube(
                              color: Env.appColor,
                            );
                          }
                        ),
                      ),
                    ): Container(),
                  ],
                );
              },
            );
          }else if(snapshot.hasError){
            return Text(snapshot.error.toString());
          }else if(snapshot.connectionState == ConnectionState.waiting){
            return const Text("waiting");
          }else{
            return const Text("No Data");
          }
        },
      ),
    );
  }
  void clear(){
    Provider.of<SettingProvider>(context, listen: false).clearImage();
    _subject.text = "";
    _body.text = "";
    imgUrl = null;
    imgFile = null;
    pdID = "";
  }
  Future<void> modifyPostDetails() async{
    if(imgFile != null){
      imgUrl = await Env.uploadFile('posts', imgFile);
      pdID == "" ? await _ref.doc(widget.docID).collection("postDetails").add({
        "pdSubject": _subject.text,
        "pdContent": _body.text,
        "pdPhoto": imgUrl,
        "pdEntryTime": DateTime.now(),
      }).whenComplete((){
        clear();
      }) :  await _ref.doc(widget.docID).collection("postDetails").doc(pdID).update({
        "pdSubject": _subject.text,
        "pdContent": _body.text,
        "pdPhoto": imgUrl,
      }).whenComplete((){
        clear();
      });
    }else{
      pdID == "" ? await _ref.doc(widget.docID).collection("postDetails").add({
        "pdSubject": _subject.text,
        "pdContent": _body.text,
        "pdPhoto": null,
        "pdEntryTime": DateTime.now(),
      }).whenComplete((){
        clear();
      }) :  await _ref.doc(widget.docID).collection("postDetails").doc(pdID).update({
        "pdSubject": _subject.text,
        "pdContent": _body.text,
        "pdPhoto": null,
      }).whenComplete((){
        clear();
      });
    }
  }

}