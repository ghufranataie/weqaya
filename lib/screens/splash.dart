import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weqaya/components/stuff.dart';
import 'package:weqaya/screens/check.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 2), (){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const CheckLogin()), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Env.appColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                Env.slogan,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 25),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                  width: 150,
                  child: Image.asset(
                    "assets/icons/appLogo.png",
                  )),
              const SizedBox(height: 50),
              const SpinKitCircle(
                color: Colors.white,
                size: 80.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}