// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:weqaya/components/provider.dart';
import 'package:weqaya/components/stuff.dart';
import 'package:weqaya/components/services.dart';
import 'package:weqaya/components/components.dart';
import 'package:weqaya/components/mainAppBar.dart';
import 'package:weqaya/screens/Doctor/docCategories.dart';
import 'dart:io';


class NewDoctor extends StatefulWidget {
  final String? docID;
  const NewDoctor({Key? key, this.docID}) : super(key: key);
  @override
  _NewDoctorState createState() => _NewDoctorState();
}

class _NewDoctorState extends State<NewDoctor> {

  final GlobalKey<FormState> _newDoctorKey = GlobalKey<FormState>();
  final TextEditingController _docName = TextEditingController();
  final TextEditingController _docEmail = TextEditingController();
  final TextEditingController _docPhone = TextEditingController();
  final TextEditingController _docBio = TextEditingController();
  final TextEditingController _docAddress = TextEditingController();
  String _docSpecialization = "متخصص";
  String _docGender = "آقا";
  String? _docField;
  String? _docCity;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isOK = false;
  String? url;
  bool inProcess = false;
  Env env = Env();
  File? imgFile;
  String? webUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fillData();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      mobile: _newDocMobile(),
      tablet: _newDocTablet(),
      web: _newDocWeb(),
    );
  }

  Widget _newDocMobile() {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50.00),
        child: CustomAppBar(),
      ),
      body: _newDocEntryForm(20, 400),
    );
  }
  Widget _newDocTablet() {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.00),
        child: CustomAppBar(),
      ),
      body: _newDocEntryForm(0.00, 500),
    );
  }
  Widget _newDocWeb() {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.00),
        child: CustomAppBar(),
      ),
      body: _newDocEntryForm(0.00, 700),
    );
  }

  Future<void> _addDoctor() async {
    bool chk;
      if (imgFile != null) {
        url = await Env.uploadFile('Doctors', imgFile);
        chk = await Services.addToCollection("doctors", {
          "docGender": _docGender,
          "docFullName": _docName.text,
          "docPhone": _docPhone.text,
          "docEmail": _docEmail.text,
          "docBio": _docBio.text,
          "docSpecialization": _docSpecialization,
          "docField": _docField,
          "docCity": _docCity,
          "docWorkAddress": _docAddress.text,
          "docPhotoUrl": url,
          "docEntryTime": DateTime.now(),
          "docAddBy": _auth.currentUser?.uid,
          "docVerify": false,
          "docShow": false,
        }).whenComplete((){
          Provider.of<SettingProvider>(context, listen: false).clearImage();
        });
        chk == true
            ? Env.goto(context, const DoctorCategory())
            : env.aDialog(context, "خطا", "مشخصات داکتر صاحب به سیستم علاوه نگردید");
      } else {
        chk = await Services.addToCollection("doctors", {
          "docGender": _docGender,
          "docFullName": _docName.text,
          "docPhone": _docPhone.text,
          "docEmail": _docEmail.text,
          "docBio": _docBio.text,
          "docSpecialization": _docSpecialization,
          "docField": _docField,
          "docCity": _docCity,
          "docWorkAddress": _docAddress.text,
          "docPhotoUrl": url,
          "docEntryTime": DateTime.now(),
          "docAddBy": _auth.currentUser?.uid,
          "docVerify": false,
          "docShow": false,
        }).whenComplete((){
          Provider.of<SettingProvider>(context, listen: false).clearImage();
        });
        chk == true
            ? Env.goto(context, const DoctorCategory())
            : env.aDialog(context, "خطا", "مشخصات داکتر صاحب به سیستم علاوه نگردید");
      }
  }
  Future<void> _setDoctor() async {
    bool chk;
    if (imgFile != null) {
      url = await Env.uploadFile('Doctors', imgFile);
      chk = await Services.setToCollection("doctors", widget.docID!,  {
        "docGender": _docGender,
        "docFullName": _docName.text,
        "docPhone": _docPhone.text,
        "docEmail": _docEmail.text,
        "docBio": _docBio.text,
        "docSpecialization": _docSpecialization,
        "docField": _docField,
        "docCity": _docCity,
        "docWorkAddress": _docAddress.text,
        "docPhotoUrl": url,
        "docEntryTime": DateTime.now(),
        "docAddBy": _auth.currentUser?.uid,
        "docVerify": false,
        "docShow": false,
      }).whenComplete((){
        Provider.of<SettingProvider>(context, listen: false).clearImage();
      });
      chk == true
          ? Env.goto(context, const DoctorCategory())
          : env.aDialog(context, "خطا", "مشخصات داکتر صاحب به سیستم علاوه نگردید");
    } else {
      chk = await Services.setToCollection("doctors", widget.docID!,  {
        "docGender": _docGender,
        "docFullName": _docName.text,
        "docPhone": _docPhone.text,
        "docEmail": _docEmail.text,
        "docBio": _docBio.text,
        "docSpecialization": _docSpecialization,
        "docField": _docField,
        "docCity": _docCity,
        "docWorkAddress": _docAddress.text,
        "docPhotoUrl": url,
        "docEntryTime": DateTime.now(),
        "docAddBy": _auth.currentUser?.uid,
        "docVerify": false,
        "docShow": false,
      }).whenComplete((){
        Provider.of<SettingProvider>(context, listen: false).clearImage();
      });
      chk == true
          ? Env.goto(context, const DoctorCategory())
          : env.aDialog(context, "خطا", "مشخصات داکتر صاحب به سیستم علاوه نگردید");
    }
  }
  Future<void> _fillData() async {
    CollectionReference _ref = FirebaseFirestore.instance.collection('doctors');
    await _ref.doc(widget.docID).get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists){
        Map data = documentSnapshot.data() as Map;
        setState(() {
          _docName.text = data['docFullName'];
          _docBio.text = data['docBio'];
          _docEmail.text = data['docEmail'];
          _docPhone.text = data['docPhone'];
          _docSpecialization = data['docSpecialization'];
          _docGender = data['docGender'];
          _docField = data['docField'];
          _docAddress.text = data['docWorkAddress'];
          _docCity = data['docCity'];
          webUrl = data['docPhotoUrl'];
        });
        File? img = await Services.urlToFile(data['docPhotoUrl']);
        Provider.of<SettingProvider>(context, listen: false).setImage(img!);
        //Provider.of<SettingProvider>(context, listen: false).setWebImage(data['docPhotoUrl']);
      }
    });
  }

  Widget _newDocEntryForm(double padding, double maxWidth) {
    imgFile = Provider.of<SettingProvider>(context).imageFile;
    webUrl = Provider.of<SettingProvider>(context).imgUrl;
    return SingleChildScrollView(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Form(
          key: _newDoctorKey,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 244, 244, 244),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // kIsWeb ?
                    // Positioned(
                    //   child: webUrl == null
                    //       ? Image.asset(
                    //           "assets/images/drPhoto.png",
                    //           fit: BoxFit.fitHeight,
                    //           height: 150,
                    //           width: 200,
                    //         )
                    //       : ClipOval(
                    //           child: Image.network(
                    //             webUrl!,
                    //             fit: BoxFit.fitHeight,
                    //             height: 150,
                    //             width: 150,
                    //           ),
                    //   ),
                    // ):
                    Positioned(
                      child: imgFile == null
                          ? Image.asset(
                        "assets/images/drPhoto.png",
                        fit: BoxFit.fitHeight,
                        height: 150,
                        width: 200,
                      )
                          : ClipOval(
                        child: Image.file(
                          imgFile!,
                          fit: BoxFit.fitHeight,
                          height: 150,
                          width: 150,
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: 0,
                      right: 50,
                      child: SelectImageDialog(cropHeight: 300, cropWidth: 300)
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: EdgeInsets.symmetric(horizontal: padding),
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  children: [
                    Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 40),
                            const Text("آقا"),
                            Radio(
                              value: 'آقا',
                              groupValue: _docGender,
                              onChanged: (val) =>
                                  setState(() => _docGender = val.toString()),
                            ),
                          ],
                        ),
                        const SizedBox(width: 30),
                        Row(
                          children: [
                            const Text("خانم"),
                            Radio(
                              value: 'خانم',
                              groupValue: _docGender,
                              onChanged: (val) =>
                                  setState(() => _docGender = val.toString()),
                            ),
                          ],
                        ),
                      ],
                    ),
                    InputSingleText(
                      controller: _docName,
                      hintText: "اسم مکمل داکتر",
                      maxLength: 50,
                      minLength: 5,
                      isMandatory: true,
                      labelText: "اسم داکتر",
                      maxLine: 1,
                    ),
                    InputNumber(
                      controller: _docPhone,
                      hintText: "0707525294",
                      labelText: "شماره تماس",
                      inputType: TextInputType.phone,
                      isMandatory: true,
                      minLength: 10,
                      maxLength: 10,
                    ),
                    InputEmail(
                      controller: _docEmail,
                      hintText: "example@yahoo.com",
                      labelText: "ایمیل آدرس",
                      inputType: TextInputType.emailAddress,
                      isMandatory: false,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 20),
                          Row(
                            children: [
                              const Text("معالج"),
                              Radio(
                                value: 'معالج',
                                groupValue: _docSpecialization,
                                onChanged: (val) => setState(
                                    () => _docSpecialization = val.toString()),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Row(
                            children: [
                              const Text("متخصص"),
                              Radio(
                                value: 'متخصص',
                                groupValue: _docSpecialization,
                                onChanged: (val) => setState(
                                    () => _docSpecialization = val.toString()),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Row(
                            children: [
                              const Text("پروفیسور"),
                              Radio(
                                value: 'پروفیسور',
                                groupValue: _docSpecialization,
                                onChanged: (val) => setState(
                                    () => _docSpecialization = val.toString()),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 80,
                      child: DropdownButtonFormField(
                        value: _docField,
                        validator: (String? val) {
                          if (val == null) {
                            return 'انتخاب بخش تداوی و تخصص داکتر حتمی میباشد';
                          }
                          return null;
                        },
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: Env.docCategories[0],
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
                        hint: Text(Env.docCategories[0]),
                        onChanged: (String? val) =>
                            setState(() => _docField = val!),
                        items: Env.docCategories
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
                    SizedBox(
                      height: 80,
                      child: DropdownButtonFormField(
                        value: _docCity,
                        validator: (String? val) {
                          if (val == null) {
                            return 'شهر که داکتر در آن فعالیت دارد باید انتخاب گردد';
                          }
                          return null;
                        },
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: Env.cities[0],
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
                        hint: Text(Env.cities[0]),
                        onChanged: (String? val) =>
                            setState(() => _docCity = val!),
                        items: Env.cities
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
                    InputSingleText(
                      controller: _docAddress,
                      hintText: "ادرس دفتر",
                      maxLength: 80,
                      minLength: 5,
                      isMandatory: true,
                      labelText: "آدرس محل کار",
                      //radius: 0,
                    ),
                    InputText(
                      controller: _docBio,
                      maxLine: 5,
                      maxLength: 1000,
                      hintText: "بیوگرافی",
                      labelText: "بیوگرافی",
                      //isMandatory: true,
                    ),
                    const SizedBox(height: 20),
                    RoundedButtonForm(
                      enable: isOK,
                      color: Env.appColor,
                      press: () {
                        if (_newDoctorKey.currentState!.validate()) {
                          setState(() => inProcess = true);
                          if(widget.docID == null){
                            _addDoctor().whenComplete(() {
                              setState(() => inProcess = false);
                              env.aDialog(context, "داکتر جدید", "مشخصات داکتر صاحب موفقانه درج گردید و بعد از یک بررسی کوتاه به دسترس عموم قرار خواهد گرفت");
                            });
                          }else{
                            _setDoctor().whenComplete((){
                              setState(() => inProcess = false);
                              env.aDialog(context, "تغییر داکتر", "مشخصات داکتر صاحب موفقانه تغییر داده شد و بعد از یک بررسی کوتاه به دسترس عموم قرار خواهد گرفت");
                            });
                          }
                        }
                      },
                      text: "ذخیره",
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: isOK,
                          onChanged: (bool? val) {
                            setState(() {
                              isOK = val!;
                            });
                          },
                        ),
                        const Flexible(
                          child: Text(
                              "با انتخاب (تک) نمودن این گزینه شما تائید میکنید که معلومات فوق کاملاً"
                              " درست بوده و از طریق خدمات اپلیکیشن وقایه به دسترس عموم قرار بگیرد."),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 60,
                      child: inProcess
                          ? SpinKitCircle(
                              color: Env.appColor,
                              size: 50,
                            )
                          : Container(height: 60),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}