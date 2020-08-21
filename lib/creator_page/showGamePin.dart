import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inquizitive/helper/functions.dart';
import 'package:inquizitive/home.dart';
import 'package:inquizitive/widgets/appBar.dart';
import 'package:inquizitive/widgets/drawer.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';

class GamePin extends StatefulWidget {
  final String quizID;
  GamePin(this.quizID);
  @override
  _GamePinState createState() => _GamePinState();
}

class _GamePinState extends State<GamePin> {

  GlobalKey<ScaffoldState> _key = GlobalKey();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: customAppBar(_key),
      drawer: customDrawer(context),
      body: Builder(
        builder: (context) => Center(
          child: Container(
            width: 260.0,
            height: 230.0,
            child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 56.0,),
                    Text("InQuiz pin", style: GoogleFonts.nunitoSans(fontStyle: FontStyle.normal, fontWeight: FontWeight.bold, fontSize: 20.0, textStyle: TextStyle(letterSpacing: 3, color: Colors.green))),
                    SizedBox(height: 10.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(widget.quizID, style: GoogleFonts.roboto(fontWeight: FontWeight.bold),),
                        IconButton(
                            icon: Icon(Icons.content_copy),
                              onPressed: () {
                                ClipboardManager.copyToClipBoard(widget.quizID).then((result) {
                                    final snackBar = SnackBar(
                                      content: Text('Copied to Clipboard'),
                                      action: SnackBarAction(
                                        label: 'Undo',
                                        onPressed: () {
                                          Clipboard.setData(new ClipboardData(text: ""));
                                        },
                                      ),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  print("changed");
                                });
                              }
                          ),
                         IconButton(
                            iconSize: 25.0,
                              icon: Icon(Icons.share),
                              onPressed: () {
//                              final RenderBox box = context.findRenderObject();
                                Share.share(widget.quizID, subject: "Hey there, Join this InQuiz!");
                              },
                            ),
                      ],
                    ),
                    SizedBox(height: 40.0,),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 45.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(40), bottomLeft: Radius.circular(40)),
                          color: Colors.green[500],
                        ),
                        child: Text("Home Screen", style: GoogleFonts.nunito(fontStyle: FontStyle.normal, fontWeight: FontWeight.bold)),
                      ),
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => HomeScreen()
                        ));
                      },
                    )
                  ],
                )
            ),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                      color:Colors.grey[500],
                      offset: Offset(5.0,5.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0
                  ),
                  BoxShadow(
                      color:Colors.white,
                      offset: Offset(-5.0,-5.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0
                  )
                ]
            ),
          ),
        ),
      )
    );
  }
}
