import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weqaya/screens/QA/questions.dart';
import 'package:weqaya/components/stuff.dart';
import 'package:weqaya/screens/splash.dart';

class AskQuestion extends StatefulWidget {
  const AskQuestion({Key? key}) : super(key: key);

  @override
  _AskQuestionState createState() => _AskQuestionState();
}

class _AskQuestionState extends State<AskQuestion> {
  Env env = Env();
  double qHeight = 150;
  bool loading = false;
  final GlobalKey<FormState> _questionKey = GlobalKey<FormState>();
  final TextEditingController _subject = TextEditingController();
  final TextEditingController _details = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loading ? const Splash() : Scaffold(
        //bottomNavigationBar: env.mainBottomNavigation(context, setState),
        //endDrawer: MainDrawer(),
        appBar: AppBar(
          title: const Text("پرسش طبی"),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                onPressed: () async {
                  bool chk = false;
                  String? url;
                  if (_questionKey.currentState!.validate()) {
                    if(Env.imageFile != null){
                      url = await Env.uploadFile("Questions", Env.imageFile);
                      chk = await _modifyQuestions(url);
                      chk == true ? Navigator.push(context, MaterialPageRoute(builder: (context) => const Questions(),),) : env.aDialog(context, "خطا", "مشخصات داکتر صاحب به سیستم علاوه نگردید");
                      Env.imageFile = null;
                    }else{
                      chk = await _modifyQuestions(null);
                      chk == true ? Navigator.push(context, MaterialPageRoute(builder: (context) => const Questions(),),) : env.aDialog(context, "خطا", "مشخصات داکتر صاحب به سیستم علاوه نگردید");
                    }
                  }else{
                  }
                },
                icon: const Icon(Icons.check),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Form(
                key: _questionKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(right: 10, bottom: 5),
                            alignment: Alignment.centerRight,
                            child: const Text("عنوان سوال:", style: TextStyle(fontSize: 14, color: Colors.black54),),
                          ),
                          TextFormField(
                            controller: _subject,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                            validator: (value){
                              if(value!.isEmpty || value.length < 10){
                                return "عنوان سوال بیشتر از 10 حرف ضروری میباشد";
                              }
                              return null;
                            },
                            //maxLength: 50,
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 10, top: 20, bottom: 5),
                            alignment: Alignment.centerRight,
                            child: const Text("موضوع سوال:", style: TextStyle(fontSize: 14, color: Colors.black54),),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: TextFormField(
                              controller: _details,
                              validator: (value){
                                if(value!.isEmpty || value.length < 100){
                                  return "موضوع سوال بیشتر از 100 حرف ضروری میباشد";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              maxLength: 1000,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(5),
                               border: OutlineInputBorder(
                                 borderSide: BorderSide.none,
                               )
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(15)),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 170,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)),
                                  padding: EdgeInsets.zero,
                                  margin: EdgeInsets.zero,
                                  child: Env.imageFile == null
                                      ? Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Image.asset(
                                      "assets/images/photo.png",
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                      : Image.file(
                                    Env.imageFile!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  bottom: 10,
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        color: Colors.white, shape: BoxShape.circle),
                                    child: IconButton(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        Env.chooseImageSource(context, setState);
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        size: 50,
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool>_modifyQuestions(url) async {
    bool chk = false;
    await FirebaseFirestore.instance.collection("questions").add({
      "queSubject": _subject.text,
      "queDetails": _details.text,
      "quePhoto": url,
      "queUserID": user!.uid,
      "queUserName": user!.displayName,
      "queUserPhoto": user!.photoURL,
      "queDateTime": DateTime.now(),
      "queVerify": false,
    }).then((value){
      chk = true;
    });
    return chk;
  }
}
