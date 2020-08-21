import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inquizitive/views/signin.dart';
import 'package:inquizitive/widgets/BaseButton.dart';
import 'package:inquizitive/widgets/appBar.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController _mailIDController = new TextEditingController();

  bool isEmpty = false;

  bool isSent =  false;

  GlobalKey<ScaffoldState> globalKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(globalKey, profileNeeded: false),
      body: Container(
          child: Column(
            children: <Widget>[
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Align(
                  alignment: Alignment.topLeft,
                    child: Text("Enter your mail ID")
                ),
              ),
              Container(
                padding: EdgeInsets.all(15.0),
                child: TextField(
                  controller: _mailIDController,
                  onTap: (){
                    setState(() {
                      isEmpty = false;
                    });
                  },
                  decoration: InputDecoration(
                    focusedBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      gapPadding: 10.0
                    ),
                    hintText: "Enter the mail address"
                  ),
                ),
              ),
              isEmpty ? Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: <Widget>[
                      Text("Enter a valid mail ID", style: TextStyle(color: Colors.red),),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              ): Container(),
              GestureDetector(
                onTap: (){
                  if(_mailIDController.text.isEmpty){
                    setState(() {
                      isEmpty =  true;
                    });
                  } else {
                      FirebaseAuth.instance.sendPasswordResetEmail(email: _mailIDController.text).then((value){
                        setState(() {
                          isSent = true;
                        });
                      });
                  }
                },
                  child: baseColorButton(context, "Reset", isUpload: true)
              ),
              isSent ? Column(
                children: <Widget>[
                  SizedBox(height: 10,),
                  Text("A reset link will be sent to this mail Id if valid", style: TextStyle(color: Colors.green),),
                ],
              ) : Container(),
              SizedBox(height: 10,),
              GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => SignIn()
                    ));
                  },
                  child: Text("Sign In", style: TextStyle(fontSize: 15.5,decoration: TextDecoration.underline),)
              ),
              Spacer(),
            ],
          ),
      ),
    );
  }
}
 