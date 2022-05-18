import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:weqaya/components/provider.dart';
import 'package:weqaya/components/stuff.dart';
import 'package:weqaya/firebase_options.dart';
import 'package:weqaya/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );

  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   // systemNavigationBarColor: Colors.white,
  //   // systemNavigationBarDividerColor: Colors.transparent,
  //   // systemNavigationBarIconBrightness: Brightness.light,
  //   // statusBarIconBrightness: Brightness.light,
  //   // statusBarColor: Color.fromARGB(255, 1, 186, 118),
  //   // statusBarBrightness: Brightness.light,
  // ));

  runApp(
    ChangeNotifierProvider(
        create: (_) => SettingProvider(),
    child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Splash(),
      theme: ThemeData(
        fontFamily: "Dubai",
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Env.appColor,
          elevation: 5,
        ),
        appBarTheme: AppBarTheme(
          color: Env.appColor,
        ),
        iconTheme: IconThemeData(
          color: Env.appColor
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Env.appColor,
            textStyle: const TextStyle(color: Colors.white, fontFamily: "Dubai", fontWeight: FontWeight.bold, fontSize: 12)
          ),
        )
      ),
    );
  }
}


