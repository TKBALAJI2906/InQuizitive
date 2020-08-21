import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inquizitive/player_page/playQuiz.dart';
import 'package:inquizitive/widgets/appBar.dart';


class StartQuiz extends StatefulWidget {
  final DocumentSnapshot docs;
  final String gamePin;
  StartQuiz(this.docs, this.gamePin);

  @override
  _StartQuizState createState() => _StartQuizState(docs);
}

class _StartQuizState extends State<StartQuiz> {

  GlobalKey<ScaffoldState> _key = GlobalKey();

  DocumentSnapshot docs ;

  _StartQuizState(this.docs);
  
  List<String> quizDetailsList = [];
  
  @override
  void initState() {
    super.initState();
    quizDetailsList.add(widget.docs.data["Title"]);
    quizDetailsList.add(widget.docs.data["Desc"]);
    quizDetailsList.add(widget.docs.data["iURL"]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: customAppBar(_key, profileNeeded: false),
      body: Center(
        child: GestureDetector(
          onTap: (){
//            print("*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-");
//            print(docs.data);

            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => PlayQuiz( docs: docs, gamePin: widget.gamePin, quizDetailsList: quizDetailsList,)
            ));
          },
          child: Container(
            margin: EdgeInsets.only(left: 24.0, bottom: 6.0, right: 24.0),
            height: 250,
            child: Material(
              elevation: 10.0,
              borderRadius: BorderRadius.circular(8.0),
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                      child:  FadeInImage(image: NetworkImage(widget.docs.data["iURL"],),
                            placeholder: AssetImage('assets/images/inquizitive_logo.png'),
                              fit: BoxFit.cover, width: MediaQuery.of(context).size.width - 48 ,)
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(widget.docs.data["Title"], style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),),
                        SizedBox(height: 6,),
                        Text(widget.docs.data["Desc"], style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),),
                        SizedBox(height: 6,),
                        RaisedButton(
                          onPressed: null,
                            child: Text("Start InQuiz",
                              style: GoogleFonts.nunito(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                textStyle: TextStyle(letterSpacing: 1, color: Colors.white),
                              ),
                            ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[900],
                  offset: Offset(0.0, 1.0),
                  blurRadius: 16.0
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}
