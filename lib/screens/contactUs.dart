import 'package:flutter/material.dart';
import 'package:weqaya/components/components.dart';
import 'package:weqaya/components/stuff.dart';
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
  final TextEditingController _conEmail = TextEditingController();
  final TextEditingController _conSubject = TextEditingController();
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
        mobile: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _contactForm(),
          ),
        ),
        tablet: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: _contactForm(),
          ),
        ),
        web: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 1000
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 420,
                    child: _contactForm(),
                  ),
                  SizedBox(
                    width: 420,
                    height: MediaQuery.of(context).size.height-200,
                    child: Center(
                      child: Image.asset("assets/images/noData.png", width: 420, fit: BoxFit.contain,),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _contactForm(){
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Form(
        key: _newContactKey,
        child: Column(
          children: [
            const SizedBox(height: 50),
            InputSingleText(
              controller: _conName,
              hintText: "رضوان عطائی",
              labelText: "اسم مکمل",
              icon: Icons.person,
            ),
            InputEmail(
              controller: _conEmail,
              hintText: "test@sample.com",
              labelText: "ایمیل آدرس",
              icon: Icons.email,
            ),
            InputSingleText(
              controller: _conSubject,
              hintText: "خواستن معلومات",
              maxLength: 50,
              minLength: 5,
              labelText: "عنوان موضوع",
              icon: Icons.person,
            ),
            InputText(
              controller: _conDetail,
              maxLength: 1000,
              minLength: 50,
              hintText: "مشخصات مکمل موضع",
              labelText: "اصل موضوع",
              isMandatory: true,
            ),
            RoundedButtonForm(
              color: Env.appColor,
              text: "ارسال",
              press: (){},
            ),
            const SizedBox(height: 20),
            const Text("برای اطلاعات بیشتر و یا تماس مستقیم لطفاً به شماره های ذیل تماس حاصل نمائید")
          ],
        ),
      ),
    );
  }
}
