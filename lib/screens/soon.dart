import 'package:flutter/material.dart';
import '../components/mainAppBar.dart';
import '../components/mainDrawer.dart';


class Soon extends StatelessWidget {
  final String pageName;
  const Soon({Key? key, required this.pageName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppBar(pageName: pageName),
      ),
      endDrawer: const MainDrawer(),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 50),
              constraints: const BoxConstraints(
                maxWidth: 1001,
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage("assets/icons/appLogo.png"),
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.1), BlendMode.dstATop),
                  )
              ),
              child: const Center(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text("بزودی...", style: TextStyle(fontSize: 30),),
                ),
              ),

              // RichText(
              //   text: const TextSpan(
              //       children: [
              //         TextSpan(text: "Hello world"),
              //       ]
              //   ),
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
