import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inquizitive/ParticipatedQuiz/participatedQuizResult.dart';
import 'package:inquizitive/home.dart';
import 'package:inquizitive/HostedQuiz/hostedQuizList.dart';
import 'package:inquizitive/widgets/appBar.dart';
import 'package:inquizitive/widgets/drawer.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  String _displayName, _uid;

  List<String> hostedQuizList = [];

  Map<String, dynamic> participationDetailsMap = {};

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getResultDetails().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> getResultDetails() async{
    await FirebaseAuth.instance.currentUser().then((user) {
      _uid = user.uid;
      _displayName = user.displayName[0].toUpperCase() + user.displayName.substring(1);
    }).then((value) async {
      await FirebaseDatabase.instance.reference().child("result").child(_uid).once().then((value) {
        value.value.forEach((k,v) => hostedQuizList.add(k.toString()));
//        print(hostedQuizList);
      });
    }).then((value) async {
      await Firestore.instance.collection("result").document(_uid).get().then((documentSnapshot) {
        if(documentSnapshot.exists){
          participationDetailsMap = documentSnapshot.data;
//          print(participationDetailsMap);
        }
      });
    });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _globalKey,
      appBar: customAppBar(
          _globalKey,
          actions: <Widget>[
            IconButton(
                iconSize: 29.0,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(right: 10.0, bottom: 5.0),
                color: Colors.blue[700],
                icon: Icon(Icons.home),
                onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => HomeScreen()
                  ));
                }
            )
          ]
      ),
      drawer: customDrawer(context),
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) :new Stack(
        children: <Widget>[
          ClipPath(
            child: Container(
              color: Colors.black.withOpacity(0.8),
            ),
            clipper: GetClipper(),
          ),
          Positioned(
            width: 400,
            top: MediaQuery.of(context).size.height / 5,
            child: Column(
              children: <Widget>[
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(58, 176, 158, .8),
                    borderRadius: BorderRadius.all(Radius.circular(75.0)),
                    boxShadow: [
                      BoxShadow(color: Colors.black, blurRadius: 7.0)
                    ]
                  ),
                  child: Icon(
                    Icons.account_circle,
                    size: 150.0,
                  ),
                ),
                SizedBox(height: 20.0,),
                Text(_displayName, style: GoogleFonts.quando(fontSize: 20),),
                SizedBox(height: 20.0,),
                isLoading ? Container() : Container(
                 // alignment: Alignment.centerLeft,
                    child:  Column(
                      children: <Widget>[
                        GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => HostedQuizList(quizList: hostedQuizList)
                              ));
                            },
                            child: Card(
//                          margin: EdgeInsets.only(top: 40, ),//left: 60
                              elevation: 5.0,
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child:  Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                padding: const EdgeInsets.all(20.0),
                                child: Text("Hosted InQuiz : ${hostedQuizList.length}", style: TextStyle(fontSize: 15.0),),
                              ),
                            )
                        ),
                        GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ParticipatedQuizList(participationDetailsMap)
                              ));
                            },
                            child: Card(
//                          margin: EdgeInsets.only(top: 40, ),//left: 60
                              elevation: 5.0,
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child:  Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text("Partcipated InQuiz : ${participationDetailsMap.length}", style: TextStyle(fontSize: 15.0),),
                              ),
                            )
                        ),
                      ],
                    ),
                ),
                SizedBox(height: 20.0,),
              ],
            ),
          )
        ],
      )
    );
  }
}

class GetClipper extends CustomClipper<Path>{

  @override
  Path getClip(Size size){
    var path = new Path();
    path.lineTo(0.0, size.height/1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper){
    return true;
  }
}
