import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weqaya/components/stuff.dart';
import 'package:weqaya/components/components.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:weqaya/screens/users/register.dart';
import 'package:weqaya/screens/users/userServices.dart';
import 'package:weqaya/components/services.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Env env = Env();
  UserServices userServices = UserServices();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool inProcess = false;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      mobile: _loginMobile(),
      tablet: _loginMobile(),
      web: _loginMobile(),
    );
  }

  Widget _loginMobile() {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              constraints: const BoxConstraints(maxWidth: 480, minWidth: 300),
              child: Column(
                children: [
                  Image.asset(
                    "assets/icons/appLogo.png",
                    height: 100,
                  ),
                  Text(
                    env.welcomeText,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        RoundedInputField(
                          controller: _email,
                          maxLength: 100,
                          hintText: 'ایمیل',
                          icon: Icons.email,
                          inputType: TextInputType.emailAddress,
                        ),
                        RoundedPasswordField(
                          controller: _password,
                          inputType: TextInputType.text,
                          icon: Icons.lock,
                          hintText: 'رمز',
                          maxLength: 100,
                        ),
                        RoundedButton(
                          press: () async {
                            if (_loginFormKey.currentState!.validate()) {
                              setState(() => inProcess = true);
                              if (kIsWeb) {
                                userServices
                                    .signInWithEmail(
                                        _email.text, _password.text, context)
                                    .then((_) => inProcess = false);
                              } else if (Platform.isAndroid || Platform.isIOS) {
                                //running on android or ios device

                                String con =
                                    await Services.checkConnection(context);
                                switch (con) {
                                  case "success":
                                    userServices
                                        .signInWithEmail(_email.text,
                                            _password.text, context)
                                        .then((_) => inProcess = false);
                                    break;
                                  case "weak":
                                    setState(() => inProcess = false);
                                    env.conDialog(
                                        context, "امکان ضعیف بودن انترنت");
                                    break;
                                  case "no connection":
                                    setState(() => inProcess = false);
                                    env.conDialog(
                                        context, "عدم اتصال به انترنت");
                                    break;
                                  default:
                                    break;
                                }
                              }
                            } else {
                              env.aDialog(context, "خطا",
                                  "درج کاربر (یوزر) و رمز شما حتمی میباشد");
                            }
                          },
                          color: Env.appColor,
                          text: "ورود",
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              child: Text(
                                "فراموشی رمز",
                                style: TextStyle(color: Env.appColor),
                              ),
                              onPressed: () {
                                //Env.goto(context, const ResetPassword());
                              },
                            ),
                            TextButton(
                              child: Text(
                                "ایجاد حساب",
                                style: TextStyle(color: Env.appColor),
                              ),
                              onPressed: () {
                                Env.goto(context, const Register());
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  SignInButton(
                    Buttons.Google,
                    text: "با حساب گوگل داخل شوید",
                    onPressed: () async {
                      setState(() => inProcess = true);
                      if (kIsWeb) {
                        bool? isDoctor = await askUserTypeDialog();
                        List<String> data = await userServices.signInWithGoogle(context).whenComplete(() => inProcess = false);
                        int chk = await userServices.checkIfUserExists(data[1]);
                        if (chk == 0) {
                          (isDoctor == true)
                              ? await userServices.newUser(data[0], true, data[2], null, data[1], null, null, null, null, data[3])
                              : await userServices.newUser(data[0], false, data[2], null, data[1], null, null, null, null, data[3]);
                        }
                      }
                      else if (Platform.isAndroid || Platform.isIOS) {
                        String con = await Services.checkConnection(context);
                        switch (con) {
                          case "success":
                            bool? isDoctor = await askUserTypeDialog();
                            List<String> data = await userServices.signInWithGoogle(context).whenComplete(() => inProcess = false);
                            int chk = await userServices.checkIfUserExists(data[1]);
                            if (chk == 0) {
                              (isDoctor == true)
                                  ? await userServices.newUser(data[0], true, data[2], null, data[1], null, null, null, null, data[3])
                                  : await userServices.newUser(data[0], false, data[2], null, data[1], null, null, null, null, data[3]);
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
                    },
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
    );
  }


  Future<bool?> askUserTypeDialog() async{
    bool? isDoctor;
    await showDialog(
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
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                          color: Env.appColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                          ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "نوع کاربر (یوزر)",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                          top: 30, right: 20, left: 20, bottom: 50),
                      child: Text("آیا شما یک داکتر هستید؟", textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.teal.shade300,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(onPressed: (){
                            isDoctor = true;
                            Navigator.of(context).pop();
                          }, child: const Text("بلی", style: TextStyle(color: Colors.black, fontSize: 18),)),
                          TextButton(
                            onPressed: (){
                              isDoctor = false;
                              Navigator.of(context).pop();
                          },
                            child: const Text(
                              "نخیر",
                              style: TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          )
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
    return isDoctor;
  }

}