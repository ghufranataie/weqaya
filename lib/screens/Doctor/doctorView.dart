// ignore_for_file: file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weqaya/components/components.dart';
import 'package:weqaya/components/mainAppBar.dart';
import 'package:weqaya/components/mainDrawer.dart';
import 'package:weqaya/components/stuff.dart';
import 'package:weqaya/screens/Doctor/doctorEntry.dart';

String? photoUrl;

class ViewDoctor extends StatelessWidget {
  final String docID;
  const ViewDoctor({Key? key, required this.docID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
        mobile: _viewDocMobile(context),
        tablet: _viewDocTablet(context),
        web: _viewDocWeb(context),
    );
  }
  Widget _viewDocMobile(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(pageName: "مشخصات داکتر"),
      ),
      endDrawer: const MainDrawer(),
      body:_doctorProfile(context)
    );
  }
  Widget _viewDocTablet(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60), child: CustomAppBar()),
        endDrawer: const MainDrawer(),
        body: _doctorProfile(context),
    );
  }
  Widget _viewDocWeb(BuildContext context) {
    TextStyle ts = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    return Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60), child: CustomAppBar()),
        endDrawer: const MainDrawer(),
        body: SingleChildScrollView(
          child: Center(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                alignment: Alignment.center,
                width: 900, //MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    //Rating Stars
                    Container(
                      alignment: Alignment.center,
                      child: DoRatingStars(
                        docID: docID,
                        collection: "doctors",
                      ),
                    ),
                    const SizedBox(height: 20),
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance.collection('doctors').doc(docID).snapshots(),
                      builder: (context, snapshot){
                        if (snapshot.hasError) return Text('Error = ${snapshot.error}');
                        if (snapshot.hasData){
                          var doc = snapshot.data!.data();
                          DateTime date = doc!['docEntryTime'].toDate();
                          photoUrl = doc['docPhotoUrl'].toString();
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  photoUrl == null
                                      ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                      child: Image.asset("assets/images/drPhoto.png", width: 300))
                                      : CachedNetworkImage(
                                    width: 300,
                                    height: 300,
                                    fit: BoxFit.cover,
                                    imageUrl: photoUrl!,
                                    placeholder: (context, url) =>
                                        SpinKitCircle(color: Env.appColor),
                                    errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                  ),
                              const SizedBox(width: 50),
                              SizedBox(
                                height: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: const [
                                    Text("اسم و تخلص:"),
                                    Text("تداوی:"),
                                    Text("شماره تماس:"),
                                    Text("ایمیل آدرس:"),
                                    Text("آدرس دفتر:"),
                                    Text("تاریخ ثبت:"),
                                    Text("شماره ثبت:"),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 50),
                              SizedBox(
                                height: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        Text(doc['docGender']=="خانم" ? "دوکتورس " : "داکتر ", style: ts),
                                        Text(doc['docFullName'] ?? "", style: ts),
                                        const SizedBox(width: 5),
                                        doc['docVerify'] == true ? const Icon(
                                          Icons.verified_rounded,
                                          size: 20,
                                        ): Container(),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(doc['docSpecialization'] ?? "", style: ts),
                                        const SizedBox(width: 5),
                                        Text(doc['docField'] ?? "", style: ts),
                                      ],
                                    ),
                                    Text(doc['docPhone'] ?? "", style: ts),
                                    Text(doc['docEmail'] ?? "", style: ts),
                                    Row(
                                      children: [
                                        Text(doc['docWorkAddress'] ?? "", style: ts),
                                        const SizedBox(width: 1),
                                        Text(doc['docCity'] ?? "", style: ts),
                                      ],
                                    ),
                                    Text(date.toString(), style: ts),
                                    Text(snapshot.data!.id ,style: const TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                              const SizedBox(height: 20),
                              RichText(
                                textAlign: TextAlign.right,
                                text: TextSpan(
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Dubai",
                                    ),
                                    text: doc['docBio'] ?? ""),
                              ),
                              const Divider(
                                height: 2,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 20),
                              OperationButtons(
                                collection: "doctors",
                                showField: "docShow",
                                verifyField: "docVerify",
                                docID: snapshot.data!.id,
                                isShow: doc['docShow'].toString(),
                                isVerified: doc['docVerify'].toString(),
                              ),
                            ],
                          );
                        }
                        return const Center(child: CircularProgressIndicator());

                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
  Widget _doctorProfile(context){
    TextStyle ts = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    return SingleChildScrollView(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('doctors').doc(docID).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text('Error = ${snapshot.error}');
            if (snapshot.hasData) {
              var doc = snapshot.data!.data();
              DateTime date = doc!['docEntryTime'].toDate();
              photoUrl = doc['docPhotoUrl'].toString();
              return Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 230,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 244, 244, 244),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 0,
                          child: ClipOval(
                            clipBehavior: Clip.antiAlias,
                            child: doc['docPhotoUrl'] == null
                                ? Image.asset("assets/images/drPhoto.png", width: 150, height: 150,)
                                : CachedNetworkImage(
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                              imageUrl: doc['docPhotoUrl'],
                              placeholder: (context, url) => SpinKitCircle(color: Env.appColor),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 40,
                          child: IconButton(
                            onPressed: () {
                              Env.goto(context, NewDoctor(docID: snapshot.data!.id));
                            },
                            icon: const Icon(Icons.edit, size: 40,),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: DoRatingStars(
                            docID: docID,
                            collection: "doctors",
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 300,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: const [
                                  Text("اسم و تخلص:"),
                                  Text("تداوی:"),
                                  Text("شماره تماس:"),
                                  Text("ایمیل آدرس:"),
                                  Text("آدرس دفتر:"),
                                  Text("تاریخ ثبت:"),
                                  Text("شماره ثبت:"),
                                ],
                              ),
                            ),
                            const SizedBox(width: 30),
                            SizedBox(
                              height: 300,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Text(doc['docGender']=="خانم" ? "دوکتورس " : "داکتر ", style: ts),
                                      Text(doc['docFullName'] ?? "", style: ts),
                                      const SizedBox(width: 5),
                                      doc['docVerify'] == true ? const Icon(
                                        Icons.verified_rounded,
                                        size: 20,
                                      ): Container(),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(doc['docSpecialization'] ?? "", style: ts),
                                      const SizedBox(width: 5),
                                      Text(doc['docField'] ?? "", style: ts),
                                    ],
                                  ),
                                  Text(doc['docPhone'] ?? "", style: ts),
                                  Text(doc['docEmail'] ?? "", style: ts),
                                  Row(
                                    children: [
                                      Text(doc['docWorkAddress'] ?? "", style: ts),
                                      const SizedBox(width: 1),
                                      Text(doc['docCity'] ?? "", style: ts),
                                    ],
                                  ),
                                  Text(date.toString(), style: ts),
                                  Text(snapshot.data!.id, style: const TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          alignment: Alignment.topRight,
                          child: Text(doc['docBio'] ?? ""),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 2,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  OperationButtons(
                    collection: "doctors",
                    verifyField: "docVerify",
                    showField: "docShow",
                    docID: snapshot.data!.id,
                    docAddBy: doc['docAddBy'],
                    isShow: doc['docShow'].toString(),
                    isVerified: doc['docVerify'].toString(),
                  ),
                  const SizedBox(height: 30),
                ],
              );
            }else if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: SpinKitCircle(
                  color: Env.appColorLight,
                  size: 50,
                ),
              );
            }
            return Center(
                child: SpinKitCircle(
                  color: Env.appColorLight,
                  size: 50,
                ),
            );
          },
        ),
      ),
    );
  }
}