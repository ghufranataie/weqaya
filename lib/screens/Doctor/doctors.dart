import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weqaya/components/components.dart';
import 'package:weqaya/screens/Doctor/doctorEntry.dart';
import 'package:weqaya/screens/Doctor/doctorView.dart';
import 'package:weqaya/components/stuff.dart';
import 'package:weqaya/components/mainAppBar.dart';
import 'package:weqaya/components/mainDrawer.dart';

class Doctors extends StatefulWidget {
  final String? docField;
  const Doctors({Key? key, this.docField}) : super(key: key);

  @override
  _DoctorsState createState() => _DoctorsState();
}
class _DoctorsState extends State<Doctors> {
  CollectionReference ref = FirebaseFirestore.instance.collection('doctors');
  Env env = Env();
  bool? isSearch = false;
  String? searchVal = "";
  String? gender = "هر دو";
  String? specialization = "همه";
  String? city = "انتخاب شهر";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.00),
        child: CustomAppBar(pageName: widget.docField!),
      ),
      endDrawer: const MainDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Env.goto(context, const NewDoctor()),
        child: const Icon(Icons.add),
      ),
      body: ScreenLayout(
        mobile: _docMobile(),
        tablet: _docTablet(),
        web: _docWeb(),
      ),
    );
  }

  Widget _docMobile() {
    return Column(
      children: [
        _filters(),
        Expanded(
          child: StreamBuilder(
            stream: _doctorsList(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    return Container(
                        margin: const EdgeInsets.only(
                            top: 10, right: 20, left: 20, bottom: 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 4,
                              offset:
                              const Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () async{
                                //var ratingSnapshot = await FirebaseFirestore.instance.collection("doctors").doc(doc.id).collection("rate").doc().get();
                                Env.goto(context, ViewDoctor(docID: doc.id));
                              },
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    //color: Colors.blue,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Row(
                                      children: [
                                        doc['docVerify'] == true
                                            ? Icon(Icons.verified_rounded,
                                            color: Env.appColor)
                                            : Container(),
                                        Text(
                                          " " + doc['docFullName'],
                                          style: const TextStyle(
                                              fontSize: 20, color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      children: [
                                        if (doc['docSpecialization'] != null)
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                doc['docSpecialization'],
                                                style:
                                                const TextStyle(fontSize: 12),
                                              )),
                                        if (doc['docEmail'] != null)
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                doc['docEmail'],
                                                style:
                                                const TextStyle(fontSize: 12),
                                              )),
                                        if (doc['docPhone'] != null)
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                doc['docPhone'],
                                                style:
                                                const TextStyle(fontSize: 12),
                                              )),
                                        if (doc['docWorkAddress'] != null)
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                doc['docWorkAddress'],
                                                style:
                                                const TextStyle(fontSize: 12),
                                              ))
                                      ],
                                    ),
                                    //leading: Icon(Icons.account_circle),
                                    leading: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromARGB(255, 202, 216, 255),
                                      ),
                                      child: ClipOval(
                                        child: doc['docPhotoUrl'] == null
                                            ? Image.asset(
                                            "assets/images/drPhoto.png")
                                            : Image.network(doc['docPhotoUrl']),
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_right,
                                      size: 35,
                                      color: Env.appColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 20),
                                doc['docPhone'] != null
                                    ? IconButton(
                                    icon: const Icon(
                                      FontAwesomeIcons.phoneAlt,
                                      size: 30,
                                    ),
                                    onPressed: () async {
                                      if (doc['docPhone'] != null) {
                                        // await FlutterPhoneDirectCaller.callNumber(doc['docPhone']);
                                      }
                                    })
                                    : Container(),
                                doc['docPhone'] != null
                                    ? IconButton(
                                    icon: const Icon(
                                      FontAwesomeIcons.whatsapp,
                                      size: 25,
                                    ),
                                    onPressed: () async {
                                      // await FlutterPhoneDirectCaller.callNumber(doc['docPhone']);
                                    })
                                    : Container(),
                                doc['docPhone'] != null
                                    ? IconButton(
                                    icon: const Icon(
                                      Icons.email_outlined,
                                      size: 25,
                                    ),
                                    onPressed: () async {
                                      // await FlutterPhoneDirectCaller.callNumber(doc['docPhone']);
                                    })
                                    : Container(),
                                doc['docPhone'] != null
                                    ? IconButton(
                                    icon: const Icon(
                                      FontAwesomeIcons.map,
                                      size: 25,
                                    ),
                                    onPressed: () async {
                                      // await FlutterPhoneDirectCaller.callNumber(doc['docPhone']);
                                    })
                                    : Container(),
                              ],
                            ),
                            const SizedBox(height: 10)
                          ],
                        ));
                  },
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SpinKitCircle(
                    color: Env.appColor,
                    size: 150,
                  ),
                );
              } else {
                return const Text("No Data");
              }
            },
          ),
        ),
      ],
    );
  }
  Widget _docTablet() {
    return Column(
      children: [
        _filters(),
        Expanded(
          child: _getDoctors(),
        ),
      ],
    );
  }
  Widget _docWeb() {
    return Row(
      children: [
        Container(
          color: Colors.white70,
          width: MediaQuery.of(context).size.width-200,
          child: _getDoctors(),
        ),
        _webFilters(),
      ],
    );
  }

  Widget _getDoctors() {
    return StreamBuilder(
      stream: _doctorsList(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 260, mainAxisExtent: 210),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs[index];
                  return GestureDetector(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      elevation: 5.0,
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipOval(
                                    child: doc['docPhotoUrl'] == null
                                        ? Image.asset("assets/images/drPhoto.png",
                                        width: 70)
                                        : CachedNetworkImage(
                                      width: 70,
                                      height: 70,
                                      imageUrl: doc['docPhotoUrl'],
                                      placeholder: (context, url) =>
                                          SpinKitCircle(color: Env.appColor),
                                      errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: doc['docVerify'] == true
                                        ? Container(
                                      decoration: const BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.white,
                                                spreadRadius: 1,
                                                blurRadius: 10)
                                          ]),
                                      child: const Icon(
                                        Icons.verified_rounded,
                                        size: 25,
                                      ),
                                    )
                                        : Container(),
                                  ),
                                ],
                              ),
                              Text(
                                doc['docFullName'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              ShowRatingStars(
                                docID: doc.id,
                                collection: 'doctors',
                                starSize: 15,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.location_on, color: Colors.red, size: 15,),
                                  Text(
                                    doc['docCity'] ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ), // :
                              //Container(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text((doc['docSpecialization']?? ' ') + ' ',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.grey, height: 1, fontSize: 12),
                                  ),
                                  Text(doc['docField'] ?? '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.grey, height: 1, fontSize: 12),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    onTap: () async{
                      //var ratingSnapshot = await FirebaseFirestore.instance.collection("doctors").doc(doc.id).collection("rate").doc().get();
                      Env.goto(context, ViewDoctor(docID: doc.id));
                    },
                  );
                },
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SpinKitCircle(
              color: Env.appColor,
              size: 150,
            ),
          );
        } else if(snapshot.connectionState == ConnectionState.none){
          return const Center(child: Text("داکتر وجود ندارد"));
        } else {
          return const Center(child: Text("داکتر وجود ندارد"));
        }
      },
    );
  }
  Widget _filters() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 100,
                    height: 40,
                    child: DropdownButtonFormField(
                      value: gender,
                      items: <String>['هر دو', 'خانم', 'آقا'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(value, textAlign: TextAlign.center),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          gender = newValue.toString();
                          isSearch = true;
                        });
                      },
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 110,
                    height: 40,
                    child: DropdownButtonFormField(
                      alignment: Alignment.center,
                      value: specialization,
                      items: <String>['همه', 'معالج', 'متخصص', 'پروفیسور']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          specialization = newValue.toString();
                          isSearch = true;
                        });
                      },
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 115,
                    height: 40,
                    child: DropdownButtonFormField(
                      alignment: Alignment.center,
                      value: city,
                      items:
                          Env.cities.map<DropdownMenuItem<String>>((String T) {
                        return DropdownMenuItem<String>(
                          value: T,
                          child: Container(
                            alignment: Alignment.center,
                            //width: double.infinity,
                            child: Text(T, textAlign: TextAlign.center),
                          ),
                        ); //DropMenuItem
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          city = newValue.toString();
                          isSearch = true;
                        });
                      },
                      decoration: InputDecoration(
                        //labelText: gender,
                        alignLabelWithHint: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                      ),
                    ),
                  ),
                ),
                isSearch == true ?
                Flexible(
                  child: IconButton(
                    icon: const Icon(Icons.cancel),
                    hoverColor: Colors.transparent,
                    tooltip: "حذف فیلتر",
                    onPressed: () {
                      setState(() {
                        city = "انتخاب شهر";
                        specialization = "همه";
                        gender = "هر دو";
                        isSearch = false;
                      });
                    },
                  ),
                ) : Container()
              ],
            ),
          ),
        ),
        // Container(
        //   width: 500,
        //   margin: const EdgeInsets.symmetric(vertical: 5),
        //   decoration: const BoxDecoration(
        //       borderRadius: BorderRadius.all(Radius.circular(10))),
        //   child: TextFormField(
        //     textAlign: TextAlign.right,
        //     decoration: InputDecoration(
        //         hintText: "جستجو",
        //         contentPadding: EdgeInsets.zero,
        //         prefixIcon: IconButton(
        //           onPressed: () {},
        //           icon: const Icon(Icons.search),
        //         ),
        //         border: OutlineInputBorder(
        //             borderRadius: BorderRadius.circular(10))),
        //     onChanged: (String newValue){
        //       searchVal = newValue;
        //       setState(() {
        //         isSearch = true;
        //       });
        //     },
        //   ),
        // ),
      ),
    );
  }
  Widget _webFilters() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.teal.shade50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            isSearch == true ?
            IconButton(
              icon: const Icon(Icons.cancel),
              hoverColor: Colors.transparent,
              tooltip: "حذف فیلتر",
              onPressed: () {
                setState(() {
                  city = "انتخاب شهر";
                  specialization = "همه";
                  gender = "هر دو";
                  isSearch = false;
                });
              },
            ) : Container(),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              //width: 120,
              height: 50,
              child: DropdownButtonFormField(
                value: gender,
                items: <String>['هر دو', 'خانم', 'آقا'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(value, textAlign: TextAlign.center),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    gender = newValue.toString();
                    isSearch = true;
                  });
                },
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 0),
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                      BorderSide(color: Colors.grey.shade400)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                      BorderSide(color: Colors.grey.shade400)),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              //width: 120,
              height: 50,
              child: DropdownButtonFormField(
                alignment: Alignment.center,
                value: specialization,
                items: <String>['همه', 'معالج', 'متخصص', 'پروفیسور']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        value,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    specialization = newValue.toString();
                    isSearch = true;
                  });
                },
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                      BorderSide(color: Colors.grey.shade400)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                      BorderSide(color: Colors.grey.shade400)),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              //width: 120,
              height: 50,
              child: DropdownButtonFormField(
                alignment: Alignment.center,
                value: city,
                items:
                Env.cities.map<DropdownMenuItem<String>>((String T) {
                  return DropdownMenuItem<String>(
                    value: T,
                    child: Container(
                      alignment: Alignment.center,
                      //width: double.infinity,
                      child: Text(T, textAlign: TextAlign.center),
                    ),
                  ); //DropMenuItem
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    city = newValue.toString();
                    isSearch = true;
                  });
                },
                decoration: InputDecoration(
                  //labelText: gender,
                  alignLabelWithHint: true,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                      BorderSide(color: Colors.grey.shade400)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                      BorderSide(color: Colors.grey.shade400)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Stream<QuerySnapshot> _doctorsList() {
    if(isSearch == true && city != "انتخاب شهر" && gender != "هر دو" && specialization != "همه"){
      isSearch = true;
      return ref.where("docShow", isEqualTo: true)
          .where("docCity", isEqualTo: city)
          .where("docGender", isEqualTo: gender)
          .where("docSpecialization", isEqualTo: specialization)
          .where("docField", isEqualTo: widget.docField)
          .snapshots();

    }else if(isSearch == true && city != "انتخاب شهر" && gender != "هر دو" && specialization == "همه"){
      isSearch = true;
      return ref.where("docShow", isEqualTo: true)
          .where("docCity", isEqualTo: city)
          .where("docGender", isEqualTo: gender)
          .where("docField", isEqualTo: widget.docField)
          .snapshots();

    }else if(isSearch == true && city != "انتخاب شهر" && gender == "هر دو" && specialization != "همه"){
      isSearch = true;
      return ref.where("docShow", isEqualTo: true)
          .where("docCity", isEqualTo: city)
          .where("docSpecialization", isEqualTo: specialization)
          .where("docField", isEqualTo: widget.docField)
          .snapshots();

    }else if(isSearch == true && city == "انتخاب شهر" && gender != "هر دو" && specialization != "همه"){
      isSearch = true;
      return ref.where("docShow", isEqualTo: true)
          .where("docGender", isEqualTo: gender)
          .where("docSpecialization", isEqualTo: specialization)
          .where("docField", isEqualTo: widget.docField)
          .snapshots();

    }else if(isSearch == true && city != "انتخاب شهر" && gender == "هر دو" && specialization == "همه"){
      isSearch = true;
      return ref.where("docShow", isEqualTo: true)
          .where("docCity", isEqualTo: city)
          .where("docField", isEqualTo: widget.docField)
          .snapshots();
    }else if(isSearch == true && city == "انتخاب شهر" && gender != "هر دو" && specialization == "همه"){
      isSearch = true;
      return ref.where("docShow", isEqualTo: true)
          .where("docGender", isEqualTo: gender)
          .where("docField", isEqualTo: widget.docField)
          .snapshots();

    }else if(isSearch == true && city == "انتخاب شهر" && gender == "هر دو" && specialization != "همه"){
      isSearch = true;
      return ref.where("docShow", isEqualTo: true)
          .where("docSpecialization", isEqualTo: specialization)
          .where("docField", isEqualTo: widget.docField)
          .snapshots();
    }else{
      return ref.where("docShow", isEqualTo: true).where("docField", isEqualTo: widget.docField).snapshots();
    }
  }
}