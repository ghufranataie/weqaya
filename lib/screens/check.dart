import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weqaya/components/stuff.dart';
import 'package:weqaya/screens/Dashboard/home.dart';
import 'package:weqaya/screens/users/login.dart';

class CheckLogin extends StatelessWidget {
  const CheckLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ErrorSplash();
          } else if (snapshot.hasError) {
            return const ErrorSplash();
          } else if (snapshot.hasData) {
            return const Home();
          } else {
            return const Login();
          }
        },
      ),
    );
  }
}
class ErrorSplash extends StatelessWidget {
  const ErrorSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}