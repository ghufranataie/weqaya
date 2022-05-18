import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weqaya/screens/QA/question_new.dart';
import 'package:weqaya/components/stuff.dart';
import 'package:intl/intl.dart' as formatdate;
import 'package:weqaya/screens/splash.dart';
import 'package:weqaya/components/mainAppBar.dart';

class QA extends StatefulWidget {
  const QA({Key? key, required this.questionsData}) : super(key: key);
  final DocumentSnapshot? questionsData;

  @override
  _QAState createState() => _QAState();
}

class _QAState extends State<QA> {
  Env env = Env();
  DateTime? d;
  final GlobalKey<FormState> _answerKey = GlobalKey<FormState>();
  final TextEditingController _comment = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timestamp t = widget.questionsData!['queDateTime'];
    d = t.toDate();
    user = _auth.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    CollectionReference answers = FirebaseFirestore.instance.collection('questions');
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.00),
        child: CustomAppBar(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const AskQuestion())),
        child: const Icon(Icons.question_answer_outlined),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      ),
                      child: ListTile(
                        // tileColor: Colors.grey.shade300,
                        contentPadding: const EdgeInsets.only(right: 20),
                        //title: Text(widget.questionsData!['queUserName'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                        subtitle: Text(d.toString(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.normal),),
                        //leading: ClipOval(child: Image.network(widget.questionsData!['queUserPhoto'], width: 50, ),),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.questionsData!['queSubject'], style: const TextStyle(fontWeight: FontWeight.bold),),
                                widget.questionsData!['quePhoto']!=null ? const Icon(Icons.attachment) : Container(),
                              ],
                            ),
                          ),
                          Text(
                            widget.questionsData!['queDetails'],
                            style: const TextStyle(color: Colors.black),
                          ),
                          widget.questionsData!['quePhoto'] !=null ? Image.network(widget.questionsData!['quePhoto']) : Container(),
                        ],
                      ),
                    ),
                    Form(
                      key: _answerKey,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26),
                            ),
                            child: TextFormField(
                              controller: _comment,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none
                                ),
                                // icon: ClipOval(child: Image.network(user!.photoURL.toString(), width: 30,)),
                                hintText: 'جواب شما؟',
                                hintStyle: TextStyle(color: Colors.grey.shade400),
                                suffixIcon: IconButton(icon: const Icon(Icons.domain_verification), onPressed: (){
                                  _submitAnswer();
                                  setState(() {
                                    _comment.text = "";
                                  });
                                },)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: SizedBox(
                height: 400,
                child: StreamBuilder(
                  stream: answers.doc(widget.questionsData!.id).collection('answers').orderBy("ansDateTime", descending: true).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context,index){
                            var queAnswers = snapshot.data!.docs[index];
                            Timestamp t = queAnswers['ansDateTime'];
                            DateTime d = t.toDate();
                            String formattedDate = formatdate.DateFormat('hh:mm yyyy-MM-dd').format(d);
                            return Column(
                              children: [
                                ListTile(
                                  leading: queAnswers['ansUserPhoto'] != null ? ClipOval(child: Image.network(queAnswers['ansUserPhoto'], width: 40,)) : Container(),
                                  title: Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    padding: const EdgeInsets.only(top: 5, bottom: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(queAnswers['ansUserName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                                        Text(formattedDate, style: const TextStyle(fontSize: 10),),
                                        const SizedBox(height: 10,),
                                        Text(queAnswers['ansDetails']),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                      );
                    }else if(snapshot.hasError){
                      return Center(
                        child: SpinKitCircle(
                          color: Env.appColor,
                          size: 150,
                        ),
                      );
                    } else if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(
                        child: SpinKitCircle(
                          color: Env.appColor,
                          size: 150,
                        ),
                      );
                    }
                    return const Splash();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitAnswer() async {
    await FirebaseFirestore.instance.collection("questions").doc(widget.questionsData!.id).collection('answers').add({
      "ansDetails": _comment.text,
      "ansUserID": user!.uid,
      "ansUserName": user!.displayName,
      "ansUserPhoto": user!.photoURL,
      "ansDateTime": DateTime.now(),
      "ansVerify": false,
    });
  }


}
