import 'package:flutter/material.dart';
import 'package:weqaya/components/components.dart';
import '../components/mainAppBar.dart';
import '../components/mainDrawer.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final GlobalKey<FormState> _newContactKey = GlobalKey<FormState>();
  final TextEditingController _conName = TextEditingController();
  final TextEditingController _conPhone = TextEditingController();
  final TextEditingController _conDetail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.00),
        child: CustomAppBar(pageName: "تماس با ما"),
      ),
      endDrawer: const MainDrawer(),
      body: ScreenLayout(
        mobile: Container(),
        tablet: Container(),
        web: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 1000
            ),
            child: _contactForm(),
          ),
        ),
      ),
    );
  }

  Widget _contactForm(){
    return Form(
      key: _newContactKey,
      child: Column(
        children: [
          const SizedBox(height: 50),
          InputSingleText(
            controller: _conName,
            hintText: "رضوان عطائی",
            labelText: "اسم مکمل",
          ),
          InputNumber(
            controller: _conPhone,
            hintText: "0707525294",
            labelText: "شماره تماس",
          ),
        ],
      ),
    );
  }
}
