import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inquizitive/home.dart';
import 'package:inquizitive/services/database.dart';
import 'package:inquizitive/widgets/appBar.dart';
import 'package:inquizitive/widgets/drawer.dart';

class ResultPage extends StatefulWidget {

  final List answerList, dataList;
  final String gamePin, hostID;
  final List<String> quizDetailsList;
  ResultPage({Key key, @required this.answerList, @required this.dataList, @required this.gamePin, @required this.hostID, @required this.quizDetailsList}) : super(key : key);

  @override
  _ResultPageState createState() => _ResultPageState(answerList, dataList);
}

class _ResultPageState extends State<ResultPage> {

  final List answerList, dataList;

  int result = 0;

  bool isLoading = false;

  _ResultPageState(this.answerList, this.dataList);

  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  DatabaseServices databaseServices = new DatabaseServices();

  Map<String, String> resultMap;

  String _name, _mail;

  @override
  void initState() {
    for(int i = 0 ; i < dataList.length ; i++){
      result = (dataList[i].toString().compareTo(answerList[i].toString()) == 0) ? result + 1 : result ;
    }
    print(answerList);
    print(dataList);
    super.initState();
    uploadResult();
  }


  void uploadResult() async{
    setState(() {
      isLoading = true;
    });

    final _auth = FirebaseAuth.instance;
    String displayName;
    List<String> resultList = [];
    FirebaseUser user;
    await _auth.currentUser().then((value) => user = value).then((value) async {
      resultList.add(user.email);
      resultList.add((result/dataList.length*100).toStringAsFixed(2)+"%");
      await _auth.currentUser().then((value) => displayName = value.displayName).then((value) async {
        resultMap = {
          displayName : resultList.toString().substring(1,resultList.toString().length - 1)
        };
        await databaseServices.uploadResult(resultMap, widget.gamePin, widget.hostID, widget.quizDetailsList).then((value) => print("Success!!!"));
      });
    });


    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return isLoading ? Center(
      child: CircularProgressIndicator(),
    ): Scaffold(
      appBar: customAppBar(
          _globalKey,
          profileNeeded: false,
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: ((result/dataList.length*100) < 35) ? Container(
                child: Center(
                  child: SizedBox(
                    child: Image.asset('assets/gifs/sorry.gif'),
                  ),
                ),
              ) : ((result/dataList.length*100) < 75) ? Container(
                child: Center(
                  child: SizedBox(
                    child: Image.asset('assets/gifs/hurray.gif'),
                  ),
                ),
              ) : Container(
                child: Center(
                  child: SizedBox(
                    child: Image.asset('assets/gifs/congrats.gif'),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Text("You have scored", style: GoogleFonts.nunito(fontStyle: FontStyle.normal, fontWeight: FontWeight.w500, letterSpacing: 1)),
            Text((result/dataList.length*100).toStringAsFixed(2)+"%",style: GoogleFonts.abhayaLibre(fontStyle: FontStyle.normal, fontWeight: FontWeight.bold,color: Colors.redAccent, fontSize: 25))
          ],
        ),
      ),
    );
  }
}
