import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:weqaya/screens/QA/question_new.dart';
import 'package:weqaya/screens/QA/question_single.dart';
import 'package:weqaya/components/stuff.dart';
import 'package:readmore/readmore.dart';
import 'package:weqaya/components/mainAppBar.dart';
import 'package:weqaya/screens/splash.dart';

class Questions extends StatefulWidget {
  const Questions({Key? key}) : super(key: key);

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {

  String? userName;
  String? userPhoto;

  @override
  Widget build(BuildContext context) {
    CollectionReference questions = FirebaseFirestore.instance.collection('questions');
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.00),
        child: CustomAppBar(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Env.goto(context, const AskQuestion()),
        child: const Icon(Icons.question_answer_outlined),
      ),
      body: StreamBuilder(
        stream: questions.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          //CollectionReference َanswers = FirebaseFirestore.instance.collection('users');
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index){
                var questionsData = snapshot.data!.docs[index];
                Timestamp t = questionsData['queDateTime'];
                DateTime d = t.toDate();
                _getUserDetails(questionsData['queUserID']);
                return InkWell(
                  onTap: (){
                    Env.goto(context, QA(questionsData: questionsData));
                  },
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
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
                              //title: Text(questionsData['queUserName'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                              subtitle: Text(d.toString(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.normal),),
                              //leading: ClipOval(child: Image.network(questionsData['queUserPhoto'], width: 50, ),),
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
                                      Text(questionsData['queSubject'], style: const TextStyle(fontWeight: FontWeight.bold),),
                                      questionsData['quePhoto']!=null ? const Icon(Icons.attachment) : Container(),
                                    ],
                                  ),
                                ),
                                ReadMoreText(
                                  questionsData['queDetails'],
                                  // trimLines: 5,
                                  trimLength: 90,
                                  style: const TextStyle(color: Colors.black),
                                  trimCollapsedText: '...بیشتر',
                                  trimExpandedText: ' کمتر',
                                ),
                                // Text(questionsData['queDetails']),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Text("جوابات (20)"),
                                Text("قلبک ها (124)")
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
          }
          return const Splash();
        },
      ),
    );
  }

  Future<String> _getUserDetails(String userID) async{
    CollectionReference _ref = FirebaseFirestore.instance.collection('users');
    var snapshot = await _ref.doc(userID).get();
    String username = snapshot['usrFullName'];
    print("The username is" + username);
    return username;
    // var userName = snapshot.data?.docs.map();
    // print("The Data is" + data.toString());
  }
}