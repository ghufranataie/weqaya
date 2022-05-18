import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:weqaya/components/provider.dart';
import 'package:weqaya/components/stuff.dart';

class RoundedInputField extends StatelessWidget {
  final String? hintText;
  final IconData icon;
  final IconData prefix;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String? message;
  final TextInputType? inputType;
  final int? maxLength;
  const RoundedInputField({
    Key? key,
    this.inputType,
    this.controller,
    this.prefix = Icons.person,
    this.hintText,
    this.message,
    this.icon = Icons.person,
    this.onChanged,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final formKey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '';
          }
          return null;
        },
        keyboardType: inputType,
        controller: controller,
        onChanged: onChanged,
        maxLength: maxLength,
        cursorColor: Env.appColor,
        decoration: InputDecoration(
            counterText: '',
            hintStyle: const TextStyle(fontSize: 14),
            contentPadding:
                const EdgeInsets.only(left: 0.0, right: 5.0, top: 5),
            prefixIcon: Icon(icon, color: Env.appColor, size: 20),
            hintText: hintText,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.7, color: Env.appColor),
              borderRadius: BorderRadius.circular(20),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Env.appColor),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1.5, color: Colors.red),
              borderRadius: BorderRadius.circular(20),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(20),
            ),
            errorStyle: const TextStyle(height: 0)),
      ),
    );
  }
}
class InputSingleText extends StatelessWidget {
  final TextEditingController? controller;
  final int? maxLine;
  final int? maxLength;
  final int? minLength;
  final bool? isMandatory;
  final IconData? icon;
  final TextInputType? inputType;
  final String? hintText;
  final double? radius;
  final String? labelText;
  const InputSingleText({
    Key? key,
    required this.controller,
    this.maxLine = 1,
    this.maxLength = 20,
    this.minLength = 1,
    this.isMandatory = true,
    this.icon,
    this.inputType = TextInputType.text,
    this.hintText,
    this.radius = 10.0,
    this.labelText = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Container(
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.only(top: 0, bottom: 0),
        //color: Colors.red,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius!)),
        child: TextFormField(
          maxLines: maxLine,
          maxLength: maxLength,
          textAlignVertical: TextAlignVertical.center,
          validator: (value) {
            if (value!.isEmpty && isMandatory == true) {
              return 'درج $hintText ضروری میباشد';
            } else if (value.length < minLength! && isMandatory == true) {
              return ' تعدا حروف باید کمتر از $minLength نباشد ';
            }
            return null;
          },
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: inputType,
          decoration: InputDecoration(
            labelText: isMandatory == false
                ? labelText! + " (اختیاری)"
                : labelText! + " (*) ",
            alignLabelWithHint: true,
            counterText: '',
            errorStyle: const TextStyle(
              height: 0.6,
            ),
            hintStyle: TextStyle(color: Colors.grey.shade400),
            contentPadding: const EdgeInsets.all(10),
            hintText: hintText,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(radius!),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(radius!),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(radius!),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Env.appColor, width: 2),
              borderRadius: BorderRadius.circular(radius!),
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.singleLineFormatter,
            LengthLimitingTextInputFormatter(maxLength),
            FilteringTextInputFormatter.deny(
              RegExp(r'[0-9۱۲۳۴۵۶۷۸۹۰!@#$%^&*()*+-/?><:;~"-=`.\_,]'),
            ),
          ],
        ),
      ),
    );
  }
}
class InputNumber extends StatelessWidget {
  final TextEditingController controller;
  final int? maxLine;
  final int? maxLength;
  final int? minLength;
  final bool? isMandatory;
  final IconData? icon;
  final TextInputType? inputType;
  final String? hintText;
  final String? labelText;
  const InputNumber({
    Key? key,
    required this.controller,
    this.maxLine,
    this.maxLength = 20,
    this.minLength = 1,
    this.isMandatory = true,
    this.icon,
    this.inputType = TextInputType.number,
    this.hintText,
    this.labelText = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Container(
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.only(top: 0, bottom: 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          textDirection: TextDirection.rtl,
          maxLines: maxLine,
          maxLength: maxLength,
          textAlignVertical: TextAlignVertical.center,
          validator: (value) {
            if (value!.isEmpty && isMandatory == true) {
              return 'درج $labelText ضروری میباشد.';
            } else if (value.length < minLength!) {
              return ' تعدا عدد باید کمتر از $minLength نباشد ';
            }
            return null;
          },
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: inputType,
          decoration: InputDecoration(
            label: isMandatory == false
                ? Text(labelText! + " (اختیاری)")
                : Text(labelText! + " (*) "),
            counterText: '',
            // errorStyle: const TextStyle(
            //   height: 0.5,
            // ),
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
              borderSide: BorderSide(color: Env.appColor, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      ),
    );
  }
}
class InputEmail extends StatelessWidget {
  final TextEditingController controller;
  final int? maxLine;
  final int? maxLength;
  final int? minLength;
  final bool? isMandatory;
  final IconData? icon;
  final TextInputType? inputType;
  final String? hintText;
  final String? labelText;
  const InputEmail({
    Key? key,
    required this.controller,
    this.maxLine,
    this.maxLength = 50,
    this.minLength = 1,
    this.isMandatory = true,
    this.icon,
    this.inputType = TextInputType.emailAddress,
    this.hintText,
    this.labelText = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Container(
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.only(top: 0, bottom: 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          textDirection: TextDirection.rtl,
          maxLines: maxLine,
          maxLength: maxLength,
          textAlignVertical: TextAlignVertical.center,
          validator: (value) {
            if (value!.isEmpty && isMandatory == true) {
              return 'درج $labelText ضروری میباشد.';
            } else if (!value.contains("@") && isMandatory == true) {
              return 'ایمیل وارد شده درست نمیباشد';
            }
            return null;
          },
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: inputType,
          decoration: InputDecoration(
            label: isMandatory == false
                ? Text(labelText! + " (اختیاری) ")
                : Text(labelText! + " (*) "),
            counterText: '',
            errorStyle: const TextStyle(
              height: 0.5,
            ),
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
              borderSide: BorderSide(color: Env.appColor, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'[a-z0-9@.-_]'),
            ),
          ],
        ),
      ),
    );
  }
}
class InputText extends StatelessWidget {
  final TextEditingController? controller;
  final int? maxLine;
  final int? maxLength;
  final int? minLength;
  final bool? isMandatory;
  final IconData? icon;
  final TextInputType? inputType;
  final String? hintText;
  final double? radius;
  final String? labelText;
  const InputText({
    Key? key,
    this.controller,
    this.maxLine = 5,
    this.maxLength = 500,
    this.minLength = 0,
    this.isMandatory = false,
    this.icon,
    this.inputType = TextInputType.text,
    this.hintText = "",
    this.radius = 10,
    this.labelText = "",
  }) :super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: maxLine,
      maxLength: maxLength,
      validator: (value) {
        if (value!.isEmpty && isMandatory == true) {
          return 'درج $hintText ضروری میباشد';
        } else if (value.length < minLength! && isMandatory == true) {
          return ' تعدا حروف باید کمتر از $minLength نباشد ';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: isMandatory == false
            ? labelText! + " (اختیاری)"
            : labelText! + " (*) ",
        alignLabelWithHint: true,
        //counterText: '',
        errorStyle: const TextStyle(
          height: 0.6,
        ),
        hintStyle: TextStyle(color: Colors.grey.shade400),
        contentPadding: const EdgeInsets.all(10),
        hintText: hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(radius!),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(radius!),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(radius!),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Env.appColor, width: 2),
          borderRadius: BorderRadius.circular(radius!),
        ),
      ),
    );
  }
}
class RoundedPasswordField extends StatefulWidget {
  final String? hintText;
  final IconData icon;
  final IconData prefix;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String? message;
  final TextInputType inputType;
  final int? maxLength;
  const RoundedPasswordField({
    Key? key,
    this.inputType = TextInputType.text,
    this.controller,
    this.prefix = Icons.person,
    this.hintText,
    this.message,
    this.icon = Icons.person,
    this.onChanged,
    this.maxLength,
  }) : super(key: key);

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}
class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    //final formKey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        obscureText: !_passwordVisible,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '';
          } else if (value.trim().length < 8) {
            return '';
          } else {
            return null;
          }
        },
        keyboardType: widget.inputType,
        controller: widget.controller,
        onChanged: widget.onChanged,
        cursorColor: Colors.black,
        decoration: InputDecoration(
            hintStyle: const TextStyle(fontSize: 14),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1.5, color: Colors.red),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: Env.appColor),
              borderRadius: BorderRadius.circular(20),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Env.appColor),
              borderRadius: BorderRadius.circular(20),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding:
                const EdgeInsets.only(left: 0.0, right: 5.0, top: 5.0),
            prefixIcon: Icon(widget.icon, color: Env.appColor, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                size: 20,
              ),
              color: Env.appColor,
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
            hintText: widget.hintText!,
            border: InputBorder.none,
            errorStyle: const TextStyle(height: 0)),
      ),
    );
  }
}
class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback? press;
  final Color color, textColor;
  const RoundedButton({
    Key? key,
    this.text = "button",
    this.press,
    required this.color,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //double _w = MediaQuery.of(context).size.width;
    return SizedBox(
      width: size.width * 1,
      height: 46,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.all(8.0)),
            elevation: MaterialStateProperty.all(40),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Env.appColor;
                }
                return Env.appColor; // Use the component's default.
              },
            ),
          ),
          onPressed: press,
          child: Text(
            text,
            style: const TextStyle(
                fontFamily: "avenir",
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
class RoundedButtonForm extends StatelessWidget {
  final String text;
  final VoidCallback? press;
  final Color color, textColor;
  final bool? enable;
  const RoundedButtonForm({
    Key? key,
    this.text = "button",
    this.press,
    required this.color,
    this.enable = true,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //double _w = MediaQuery.of(context).size.width;
    return SizedBox(
      width: size.width * 1,
      height: 46,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.all(8.0)),
            elevation: MaterialStateProperty.all(40),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return enable == true ? Env.appColor : Colors.grey;
                }
                return enable == true
                    ? Env.appColor
                    : Colors.grey; // Use the component's default.
              },
            ),
          ),
          onPressed: enable == true ? press : null,
          child: Text(
            text,
            style: const TextStyle(
                fontFamily: "avenir",
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
class ScreenLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget web;
  const ScreenLayout(
      {Key? key, required this.mobile, required this.tablet, required this.web})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 480) {
          return mobile;
        } else if (constraints.maxWidth < 900) {
          return tablet;
        } else {
          return web;
        }
      },
    );
  }
}

class OperationButtons extends StatelessWidget {
  final String docID;
  final String? docAddBy;
  final String collection;
  final String showField;
  final String verifyField;
  final String? isVerified;
  final String? isShow;
  const OperationButtons({
    Key? key,
    required this.docID,
    this.docAddBy,
    required this.collection,
    required this.showField,
    required this.verifyField,
    this.isVerified,
    this.isShow,
  }) : super(key: key);
  void _updateDocument(context, String col, String fieldName, bool val) async {
    Env env = Env();
    var collection = FirebaseFirestore.instance.collection(col);
    await collection.doc(docID).update({fieldName: val}).whenComplete(() {
      Navigator.of(context).pop();
    }).catchError((error) => env.aDialog(context, "خطا", error.toString()));
  }
  @override
  Widget build(BuildContext context) {
    String role = Provider.of<SettingProvider>(context).userRole;
    double wSize = MediaQuery.of(context).size.width;
    return SizedBox(
      width: wSize,
      //color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          (role == "Super")
              ? SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () => _updateDocument(
                      context,
                      collection.toString(),
                      verifyField,
                      isVerified == "true" ? false : true,
                    ),
                    child: Text(isVerified == "true" ? "عدم تائید" : "تائید"),
                  ),
                )
              : Container(),
          (role == "Super")
              ? SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () => _updateDocument(
                        context,
                        collection.toString(),
                        showField,
                        isShow == "true" ? false : true),
                    child: Text(isShow == "true" ? "عدم نمایش" : "نمایش"),
                  ),
                )
              : Container(),
          (role == "Super")
              ? SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection(collection)
                          .doc(docID)
                          .delete();
                      //Env.goto(context, const DoctorCategory());
                      Navigator.of(context).pop();
                    },
                    child: const Text("حذف"),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
class DoRatingStars extends StatelessWidget {
  final String? collection;
  final String? docID;
  const DoRatingStars({Key? key, this.collection, this.docID}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    _checkUserRating(context);
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(collection!)
          .doc(docID)
          .collection('rating')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text("Snapshot Has Error\n" + snapshot.error.toString()));
        }
        if (snapshot.hasData) {
          var ds = snapshot.data!.docs;
          double sum = 0.0;
          int rateCount = snapshot.data!.docs.length;
          double average = 0.0;
          for (int i = 0; i < ds.length; i++) {
            sum += (ds[i]['value']).toDouble();
          }
          average = sum / rateCount;
          return Column(
            children: [
              GestureDetector(
                child: RatingBar(
                  glow: true,
                  glowColor: Colors.red,
                  tapOnlyMode: false,
                  updateOnDrag: false,
                  ignoreGestures: true,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 3),
                  itemSize: 25,
                  initialRating: average.isNaN ? 0.00 : average,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  ratingWidget: RatingWidget(
                      full: Image.asset("assets/stars/star-full.png"),
                      half: Image.asset("assets/stars/star-half.png"),
                      empty: Image.asset("assets/stars/star-empty.png")),
                  onRatingUpdate: (rating) {},
                ),
                onTap: () {
                  _rateOnUpdate(context);
                },
              ),
              Text("محبوبیت: " +
                  (average.isNaN ? 0.00 : average.toStringAsFixed(1))
                      .toString()),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Future<void> _checkUserRating(context) async {
    String ratingID = "";
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(collection!);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String user = _auth.currentUser!.uid;
    var snapshot = await collectionReference
        .doc(docID)
        .collection('rating')
        .where("user", isEqualTo: user)
        .get();
    snapshot.docs.map((e) {
      //Map value = e.data();
      ratingID = e.id;
    }).toString();
    if (ratingID.isEmpty) {
      showDialog(
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
                    const SizedBox(height: 50),
                    Center(
                        child: Image.asset("assets/images/drPhoto.png",
                            width: 80)),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 30),
                        child: RatingBar(
                          itemPadding: const EdgeInsets.all(5),
                          itemSize: 40,
                          initialRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          ratingWidget: RatingWidget(
                              full: Image.asset("assets/stars/star-full.png"),
                              half: Image.asset("assets/stars/star-half.png"),
                              empty:
                                  Image.asset("assets/stars/star-empty.png")),
                          onRatingUpdate: (rating) async {
                            await collectionReference
                                .doc(docID)
                                .collection('rating')
                                .doc(user)
                                .set({
                              "user": user,
                              "value": rating,
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 300,
                        decoration: BoxDecoration(
                            color: Env.appColor,
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
        },
      );
    }
  }

  Future<void> _rateOnUpdate(context) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(collection!);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String user = _auth.currentUser!.uid;
    showDialog(
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
                  const SizedBox(height: 50),
                  Center(
                      child:
                          Image.asset("assets/images/drPhoto.png", width: 80)),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      child: RatingBar(
                        itemPadding: const EdgeInsets.all(5),
                        itemSize: 40,
                        initialRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        ratingWidget: RatingWidget(
                            full: Image.asset("assets/stars/star-full.png"),
                            half: Image.asset("assets/stars/star-half.png"),
                            empty: Image.asset("assets/stars/star-empty.png")),
                        onRatingUpdate: (rating) async {
                          await collectionReference
                              .doc(docID)
                              .collection('rating')
                              .doc(user)
                              .set({
                            "user": user,
                            "value": rating,
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                          color: Env.appColor,
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
      },
    );
  }
}
class ShowRatingStars extends StatelessWidget {
  final String? collection;
  final String? docID;
  final double? starSize;
  const ShowRatingStars({Key? key, this.collection, this.docID, this.starSize}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(collection!)
          .doc(docID)
          .collection('rating')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text("Snapshot Has Error\n" + snapshot.error.toString()));
        }
        if (snapshot.hasData) {
          var ds = snapshot.data!.docs;
          double sum = 0.0;
          int rateCount = snapshot.data!.docs.length;
          double average = 0.0;
          for (int i = 0; i < ds.length; i++) {
            sum += (ds[i]['value']).toDouble();
          }
          average = sum / rateCount;
          return RatingBar(
            glow: true,
            glowColor: Colors.red,
            tapOnlyMode: false,
            updateOnDrag: false,
            ignoreGestures: true,
            itemPadding: const EdgeInsets.symmetric(horizontal: 2),
            itemSize: starSize!,
            initialRating: average.isNaN ? 0.00 : average,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            ratingWidget: RatingWidget(
                full: Image.asset("assets/stars/star-full.png"),
                half: Image.asset("assets/stars/star-half.png"),
                empty: Image.asset("assets/stars/star-empty.png")),
            onRatingUpdate: (rating) {},
          );
        } else {
          return Container();
        }
      },
    );
  }
}
class SelectImageDialog extends StatefulWidget {
  final int cropHeight;
  final int cropWidth;
  final IconData? icn;
  final Color? icnColor;
  final double? icnSize;
  const SelectImageDialog(
      {Key? key, required this.cropHeight, required this.cropWidth, this.icnColor = Colors.teal, this.icnSize = 40.0, this.icn = Icons.camera})
      : super(key: key);
  @override
  State<SelectImageDialog> createState() => _SelectImageDialogState();
}
class _SelectImageDialogState extends State<SelectImageDialog> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(widget.icn, size: widget.icnSize, color: widget.icnColor),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
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
                              color: Env.appColor,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "انتخاب منبع",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
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
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                elevation: 6,
                                child: SizedBox(
                                  height: 60,
                                  //width: 160,
                                  //color: Colors.redAccent,
                                  child: InkWell(
                                    onTap: () async {
                                      await _selectFile(ImageSource.camera);
                                      Navigator.pop(context);
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: const [
                                          Text("کمره", style: TextStyle(fontSize: 16)),
                                          Icon(Icons.camera_alt, size: 38)
                                        ],
                                      ),
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
                                    color: Colors.white70,
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      _selectFile(ImageSource.gallery);
                                      Navigator.pop(context);
                                      },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: const [
                                        Text("گالری", style: TextStyle(fontSize: 16)),
                                        Icon(Icons.photo, size: 40),
                                      ],
                                    ),
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
      },
    );
  }
  Future<void> _selectFile(ImageSource source) async {
    File? imageFile;
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      imageFile = File(pickedImage.path);
    }

    if(kIsWeb){
      Provider.of<SettingProvider>(context, listen: false).setWebImage(pickedImage!.path);
    }else if(Platform.isAndroid || Platform.isIOS){
      ImageCropper imageCropper = ImageCropper();
      File? croppedFile = await imageCropper.cropImage(
        // androidUiSettings: AndroidUiSettings(
        //   toolbarTitle: 'تنظیم تصویر مطابق چوکات',
        //   toolbarColor: Env.appColor,
        //   toolbarWidgetColor: Colors.white,
        //   lockAspectRatio: true,
        //   cropFrameStrokeWidth: 5,
        //   initAspectRatio: CropAspectRatioPreset.ratio16x9,
        // ),
        // iosUiSettings: const IOSUiSettings(
        //   title: 'Cropper',
        // ),
        // aspectRatioPresets: Platform.isAndroid
        //     ? [CropAspectRatioPreset.ratio16x9]
        //     : [CropAspectRatioPreset.square],
        sourcePath: imageFile!.path,
        // aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressFormat: ImageCompressFormat.jpg,
        cropStyle: CropStyle.rectangle,
        compressQuality: 76,
        maxHeight: widget.cropHeight,
        maxWidth: widget.cropWidth,
      );
      if (croppedFile != null) {
        Provider.of<SettingProvider>(context, listen: false).setImage(croppedFile);
      }
    }
  }
}

class UserDetails extends StatelessWidget {
  final String userID;
  const UserDetails({Key? key, required this.userID}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    return StreamBuilder(
      stream: ref.doc(userID).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
        if (snapshot.hasError){
          return Text ('Error = ${snapshot.error}');
        }else if (snapshot.hasData) {
          //var usr = snapshot.data?.data();
          // String usrName = data!['usrFullName']; // <-- Your value
          // String usrPhotoUrl = data['usrPhotoUrl'];
          return Text(snapshot.data!['usrFullName']);
          //   Row(
          //   children: [
          //     const Icon(Icons.supervised_user_circle),
          //     Column(
          //       children: [
          //         Text(snapshot.data!['usrFullName']),
          //         //Text(usrName)
          //       ],
          //     )
          //   ],
          // );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

}