import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';


class Env{
  //static Color appColor = const Color.fromARGB(255, 1, 186, 118);
  static Color appColor = Colors.teal;
  static Color appColorLight = Colors.teal.shade300;
  String welcomeText = "خوش آمدید";
  static String slogan = "وقایه بهتر از معالجه است";
  static String appName = "وقایه";

  String? typeChoose;
  String? cityChoose;
  var list = ["پرسش و پاسخ طبی", "معلومات طبی", "محلات طبی", "داکتران", "ادویه جات", "معاینات لابراتواری",];
  static List<String> cities = [
    "انتخاب شهر",
    "مزارشریف",
    "کابل",
    "هرات",
    "قندهار",
    "جلال آباد",
    "کندز",
    "شبرغان",
    "میمنه",
    "سرپل",
    "پلخمری",
    "چاریکار",
    "آقچه",
    "خلم",
    "فیروز کوه",
    "میدان شهر",
  ];
  static List<String> docCategories = [
    "امراض",
    "داخله عمومی",
    "دندان",
    "نسایی ولادی",
    "داخله اطفال",
    "چشم",
    "ارتوپیدی",
    "جلدی",
    "امراض قلبی",
    "عقلی و عصبی",
    "جراحی عمومی",
    "گوش و گلو",
    "حساسیت",
    "رادیولوژی",
    "التراسوند",
    "فزیوتراپی",
    "امراض سرطانی",
    "لیبرانت",
    "نرس",
    "داروساز"
  ];

  static List<String> postCategory = ["دارو", "اناتومی", "بیوشیمی", "پتالوژی", "فارمکولوژی", "ارتوپیدی", "فزیولوژی", "عقلی و عصبی",
    "جلدی", "اطفال", "نسائی و ولادی", "یورولوژی", "مایکرو بیولوژی", "پرازیتولوژی", "جرائی",
    "داخله", "اناستازیز", "صحت عامه", "گوش و گلو", "اخلاق طبابت", "بیوفیزیک", "تروماتولوژی"];

  static File? imageFile;
  static String noPhoto = "https://firebasestorage.googleapis.com/v0/b/weqaya-sehat-d2bf3.appspot.com/o/noPhoto.png?alt=media&token=6f611d4f-bc68-4c7f-86ac-277cec3e04c3";

  conDialog(context, String content) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            content: SizedBox(
              width: 300,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 30),
                    Image.asset("assets/icons/noCon.png", width: 100, height: 100,),
                    //Content of the Dialog
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, right: 20, left: 20, bottom: 30),
                      child: Text(
                        content,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 300,
                        decoration: BoxDecoration(
                            color: appColor,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            "خوب",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
  // void ratingDialog(context, String collection, String docID){
  //   showDialog(
  //     context: context,
  //     builder: (context){
  //       return AlertDialog(
  //         contentPadding: EdgeInsets.zero,
  //         shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(30)),
  //         ),
  //         content: SizedBox(
  //           width: 300,
  //           child: Directionality(
  //             textDirection: TextDirection.rtl,
  //
  //           ),
  //         ),
  //       );
  //     }
  //   );
  // }

  aDialog(context, String subject, String content) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            content: SizedBox(
              width: 300,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      subject,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, color: appColor),
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 30, right: 20, left: 20, bottom: 50),
                      child: Text(
                        content,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 300,
                        decoration: BoxDecoration(
                            color: appColor,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Ok",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
  floatingActionButton(BuildContext context, voidCallback){
    return FloatingActionButton(
      child: const Icon(Icons.add),
      elevation: 5,
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => voidCallback())),
      backgroundColor: Colors.redAccent,
      splashColor: Colors.green,
    );
  }
  textField(textValue, int maxLine, int maxLength, minLength, hintText, TextInputType inputType, isMandatory) {
    return Container(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(top: 0, bottom: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          maxLines: maxLine,
          maxLength: maxLength,
          textDirection: TextDirection.rtl,
          textAlignVertical: TextAlignVertical.center,
          validator: (value) {
            if (value!.isEmpty && isMandatory==true) {
              return '    این بخش ضروری میباشد';
            } else if(value.length < minLength && isMandatory==true){
              return ' تعدا حروف باید کمتر از $minLength نباشد ';
            } return null;
          },
          controller: textValue,
          textAlign: TextAlign.center,
          keyboardType: inputType,
          decoration: InputDecoration(
            counterText: '',
            errorStyle: const TextStyle(height: 0.5,),
            hintStyle: TextStyle(color: Colors.grey.shade400),
            contentPadding: const EdgeInsets.all(10),
            hintText: hintText,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.lime.shade900),
              borderRadius: BorderRadius.circular(10),
            ),

          ),
        ),
      ),
    );
  }
  dropDownField(list, String message, voidCallBack){
    return Container(
        alignment: AlignmentDirectional.centerStart,
        margin: const EdgeInsets.only(bottom: 10),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: DropdownButtonFormField(
            validator: (value){
              if(value == list[0]){
                return 'نوع محل باید انتخاب گردد';
              }
              return null;
            },
            isExpanded: true,
            decoration: InputDecoration(
              counterText: '',
              errorStyle: const TextStyle(height: 1,),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade400)
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade400)
              ),
            ),
            hint: Text(message),
            value: list[0],
            onChanged: (value) => (){
              voidCallBack(() {
                typeChoose = value!.toString();
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: SizedBox(
                  width: double.infinity,
                  child: Text(value, textAlign: TextAlign.center,),
                ),
              ); //DropMenuItem
            }).toList(),
          ),
        )
    );
  }

  static Future<File> _selectFile(ImageSource source, voidCallBack) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if(pickedImage != null){
      voidCallBack(() {
        imageFile = File(pickedImage.path);
      });
    }
    ImageCropper imageCropper = ImageCropper();
    File? croppedFile = await imageCropper.cropImage(
      sourcePath: imageFile!.path,
      aspectRatio: const CropAspectRatio(ratioX: 1.5, ratioY: 1),
      compressQuality: 76,
      maxHeight: 267,
      maxWidth: 400,
    );
    if (croppedFile != null) {
      voidCallBack(() {
        imageFile = croppedFile;
      });
    }
    return imageFile!;
  }
  static chooseImageSource(BuildContext context, voidCallBack){
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            content: SizedBox(
              width: 300,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                          color: appColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "انتخاب منبع",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      height: 200,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            elevation: 6,
                            child: SizedBox(
                              height: 60,
                              //width: 160,
                              //color: Colors.redAccent,
                              child: InkWell(
                                  onTap: () {
                                    _selectFile(ImageSource.camera, voidCallBack);
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: const [
                                      Text("کمره", style: TextStyle(fontSize: 16),),
                                      Icon(Icons.camera_alt, size: 38,)
                                    ],
                                  )
                              ),
                            ),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            elevation: 6,
                            child: Container(
                              height: 60,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white70
                              ),
                              child: InkWell(
                                  onTap: () {
                                    _selectFile(ImageSource.gallery, voidCallBack);
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: const [
                                      Text("گالری", style: TextStyle(fontSize: 16),),
                                      Icon(Icons.photo, size: 40,)
                                    ],
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
    );
  }
  static Future<String?> uploadFile(String destination, var imageFile) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("$destination/doctor"+DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(imageFile);
    var dowUrl = await (await uploadTask).ref.getDownloadURL();
    String url = dowUrl.toString();
    return url;
  }
  static Future<String?> uploadImageFile(String destination, var file) async {
    try {
      TaskSnapshot upload = await FirebaseStorage.instance.ref(
          '$destination/doctors/'+DateTime.now().toString())
          .putData(
        file.bytes,
        SettableMetadata(contentType: 'image/${file.extension}'),
      );

      String url = await upload.ref.getDownloadURL();
      return url;
    } catch (e) {
      print('error in uploading image for : ${e.toString()}');
      return '';
    }
  }
  static void goto(BuildContext context, voidCallBack){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => voidCallBack),
    );
  }


}
