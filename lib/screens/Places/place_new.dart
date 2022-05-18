import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:weqaya/components/components.dart';
import 'package:weqaya/screens/Places/places.dart';
import 'package:weqaya/components/stuff.dart';
import 'package:location/location.dart';

import '../../components/provider.dart';

class NewPlace extends StatefulWidget {
  final String? docID;
  const NewPlace({Key? key, this.docID}) : super(key: key);

  @override
  _NewPlaceState createState() => _NewPlaceState();
}

class _NewPlaceState extends State<NewPlace> {
  final GlobalKey<FormState> _placeFormKey = GlobalKey<FormState>();
  final TextEditingController _placeName = TextEditingController();
  final TextEditingController _placePhone = TextEditingController();
  final TextEditingController _placeEmail = TextEditingController();
  final TextEditingController _placeAddress = TextEditingController();
  String? _placeType = "دواخانه";
  String? _docCity;
  bool isOK = false;
  bool inProcess = false;

  Env env = Env();

  GoogleMapController? _googleMapController;
  LatLng? latLongPosition;
  String long = "0";
  String lat = "0";

  File? imgFile;

  final LatLng _initialCameraPosition = const LatLng(36.6983985, 67.1150008);
  GoogleMapController? _controller;
  Location location = Location();

  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(36.6983985, 67.1150008),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    getCurrentLocation();
  }

  checkLocationPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }
  Future<void> getCurrentLocation() async{
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      latLongPosition = LatLng(position.latitude, position.longitude);
    });
  }
  googleMap() async {
    Position position = await Geolocator.getCurrentPosition();
    LatLng latLongPosition = LatLng(position.latitude, position.longitude);
    CameraPosition _initialCameraPosition = CameraPosition(target: latLongPosition, zoom: 10);
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _initialCameraPosition,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      onMapCreated: (controller) async{
        _googleMapController = controller;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Place"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () async {
                bool chk = false;
                String? url;
                if (_placeFormKey.currentState!.validate()) {
                  if(Env.imageFile != null){
                    url = await Env.uploadFile("Places", Env.imageFile);
                    chk = await _modifyPlace(url);
                    chk == true ? Navigator.push(context, MaterialPageRoute(builder: (context) => const Places(),),) : env.aDialog(context, "خطا", "مشخصات داکتر صاحب به سیستم علاوه نگردید");
                    Env.imageFile = null;
                  }else{
                    chk = await _modifyPlace(null);
                    chk == true ? Navigator.push(context, MaterialPageRoute(builder: (context) => const Places(),),) : env.aDialog(context, "خطا", "مشخصات داکتر صاحب به سیستم علاوه نگردید");
                  }
                }else{

                }
              },
              icon: const Icon(Icons.check),
            ),
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _placeFormKey,
            child: Column(
              children: [
                Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text("دواخانه"),
                        Radio(
                          value: 'دواخانه',
                          groupValue: _placeType,
                          onChanged: (val) =>
                              setState(() => _placeType = val.toString()),
                        ),
                      ],
                    ),
                    const SizedBox(width: 30),
                    Row(
                      children: [
                        const Text("کلینیک"),
                        Radio(
                          value: 'کلینیک',
                          groupValue: _placeType,
                          onChanged: (val) =>
                              setState(() => _placeType = val.toString()),
                        ),
                      ],
                    ),
                    const SizedBox(width: 30),
                    Row(
                      children: [
                        const Text("شفاخانه"),
                        Radio(
                          value: 'شفاخانه',
                          groupValue: _placeType,
                          onChanged: (val) => setState(() => _placeType = val.toString()),
                        ),
                      ],
                    ),
                  ],
                ),
                InputSingleText(
                  controller: _placeName,
                  hintText: "طاهری درملتون",
                  labelText: "اسم محل",
                  maxLength: 50,
                ),
                InputNumber(
                  controller: _placePhone,
                  maxLength: 10,
                  minLength: 10,
                  hintText: "0707525294",
                  labelText: "شماره تماس",
                ),
                InputEmail(
                  controller: _placeEmail,
                  labelText: "ایمیل آدرس",
                  hintText: "sample@location.com",
                  isMandatory: false,
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
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  height: 200,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target:  latLongPosition!,
                        zoom: 17
                      ),
                      compassEnabled: true,
                      indoorViewEnabled: true,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      // zoomGesturesEnabled: false,
                      zoomControlsEnabled: false,
                      //onMapCreated: _onMapCreated,
                      onTap: (value){
                        //openMapDialog(context, _kGooglePlex);
                        print("I am Clicked on Map" + value.toString());
                      },
                      mapType: MapType.normal,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InputSingleText(
                  controller: _placeAddress,
                  hintText: "آپارتمان شماره 5, غرب چوک ذبیح الله, گذر قبادیان",
                  labelText: "آدرس محل",
                  maxLength: 50,
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
                                text: "اضافه نمودن تصویر محل به بازدید کنندگان کمک میکند تا بهتر ردیابی نمایند و کاملاً اختیاری بوده و در صورت لزوم میتوانید تصویر از محل متذکره را علاوه کنید در غیر آن میتوانید صرف نظر نمائید.",
                              ),
                            ]
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                RoundedButtonForm(
                  enable: isOK,
                  color: Env.appColor,
                  press: () {
                    if (_placeFormKey.currentState!.validate()) {
                      setState(() => inProcess = true);
                      if(widget.docID == null){
                        // _addDoctor().whenComplete(() {
                        //   setState(() => inProcess = false);
                        //   env.aDialog(context, "داکتر جدید", "مشخصات داکتر صاحب موفقانه درج گردید و بعد از یک بررسی کوتاه به دسترس عموم قرار خواهد گرفت");
                        // });
                      }else{
                        // _setDoctor().whenComplete((){
                        //   setState(() => inProcess = false);
                        //   env.aDialog(context, "تغییر داکتر", "مشخصات داکتر صاحب موفقانه تغییر داده شد و بعد از یک بررسی کوتاه به دسترس عموم قرار خواهد گرفت");
                        // });
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
        ),
      ),
    );
  }

  openMapDialog(BuildContext context, CameraPosition cameraPosition) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: GoogleMap(
              initialCameraPosition: cameraPosition,
            ),
          );
        },
    );
  }
  _onMapCreated(GoogleMapController _myControl) {
    _controller = _myControl;
    location.onLocationChanged.listen((l) {
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(l.latitude!.toDouble(), l.longitude!.toDouble())),
        ),
      );
      long = l.longitude.toString();
      lat = l.latitude.toString();
    });
  }
  Future<bool> _modifyPlace(url) async {
    bool chk = false;
    await FirebaseFirestore.instance.collection("places").add({
      "plcType": env.typeChoose,
      "plcName": _placeName.text,
      "plcContact": _placePhone.text,
      "plcEmail": _placeEmail.text,
      "plcCity": env.cityChoose,
      "plcAddress": _placeAddress.text,
      "plcPhoto": url,
      "plcLatitude":  lat,
      "plcLongitude":  long,
      "plcVerify": false,
    }).then((value){
      chk = true;
    });
    return chk;
  }
}