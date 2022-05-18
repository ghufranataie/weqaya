import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weqaya/components/components.dart';
import 'package:weqaya/components/services.dart';
import 'package:weqaya/components/stuff.dart';
import 'package:weqaya/screens/users/userServices.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Env env =  Env();
  final GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  UserServices userServices = UserServices();
  bool inProcess = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
        mobile: _registerMobile(),
        tablet: _registerMobile(),
        web: _registerMobile(),
    );
  }

  Widget _registerMobile() {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              constraints: const BoxConstraints(
                maxWidth: 480,
                minWidth: 300,
              ),
              child: Form(
                key: _signUpKey,
                child: Column(
                  children: [
                    Image.asset("assets/icons/appLogo.png", height: 100,),
                    const Text(
                      "راجستر",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 50),
                    RoundedInputField(
                      maxLength: 50,
                      icon: Icons.account_circle,
                      inputType: TextInputType.text,
                      controller: _fullName,
                      hintText: "اسم مکمل",
                    ),
                    RoundedInputField(
                      maxLength: 50,
                      icon: Icons.email,
                      inputType: TextInputType.text,
                      controller: _username,
                      hintText: "کاربر",
                    ),
                    RoundedPasswordField(
                      controller: _password,
                      inputType: TextInputType.text,
                      icon: Icons.lock,
                      hintText: 'رمز',
                      maxLength: 100,
                    ),
                    const SizedBox(height: 15),
                    RoundedButton(
                      text: "راجستر",
                      color: Env.appColor,
                      press: () async {
                        if (_signUpKey.currentState!.validate()) {
                          setState(() => inProcess = true);
                          if(kIsWeb){
                            int chk = await userServices.checkIfUserExists(_username.text);
                            if(chk == 0){
                              bool isDoctor = await userServices.askUserType(context);
                              userServices.createUserWithEmail(_fullName.text, _username.text, _password.text, isDoctor, context)
                                  .then((_) => inProcess = false);
                            }else{
                              env.aDialog(context, "خطا", "ایمیل مورد نظر قبلاً راجستر میباشد");
                            }
                          }else if (Platform.isAndroid || Platform.isIOS){
                            String con = await Services.checkConnection(context);
                            switch (con){
                              case "success":
                                int chk = await userServices.checkIfUserExists(_username.text);
                                if(chk == 0){
                                  bool isDoctor = await userServices.askUserType(context);
                                  userServices.createUserWithEmail(_fullName.text, _username.text, _password.text, isDoctor, context)
                                      .then((_) => inProcess = false);
                                }else{
                                  env.aDialog(context, "خطا", "ایمیل مورد نظر قبلاً راجستر میباشد");
                                }
                                break;
                              case "weak":
                                setState(() => inProcess = false);
                                env.conDialog(context, "امکان ضعیف بودن انترنت");
                                break;
                              case "no connection":
                                setState(() => inProcess = false);
                                env.conDialog(context, "عدم اتصال به انترنت");
                                break;
                              default:
                                break;
                            }
                          }
                        } else {
                          env.aDialog(context, "خطا", "یوزر و یا رمز شما مطابق قوانین اپلیکیشن نمیباشد");
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                          style: const TextStyle(fontSize: 16, color:  Colors.black54),
                          text: "حساب دارم ",
                          children: [
                            TextSpan(
                                style: TextStyle(fontSize: 16, color: Env.appColor),
                                text: " ورود حساب",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Login()),
                                    );
                                  }),
                          ]),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 60,
                      child: inProcess
                          ? SpinKitCircle(
                        color: Env.appColor,
                        size: 50,
                      )
                          : Container(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

