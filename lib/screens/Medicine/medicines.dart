import 'package:flutter/material.dart';
import 'package:weqaya/components/components.dart';
import 'package:weqaya/components/mainAppBar.dart';
import 'package:weqaya/components/mainDrawer.dart';
import 'package:weqaya/screens/MedicalPosts/medicalPosts.dart';

class Medicines extends StatelessWidget {
  const Medicines({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50.00),
          child: CustomAppBar(pageName: "دارو ها"),
        ),
        endDrawer: const MainDrawer(),
        body: ScreenLayout(
          mobile: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: loadPosts("دارو"),
          ),
          tablet: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: loadPosts("دارو"),
          ),
          web: Center(
            child: Container(
              constraints: const BoxConstraints(
                  maxWidth: 1000
              ),
              child: loadPosts("دارو"),
            ),
          ),
        ));
  }
}
