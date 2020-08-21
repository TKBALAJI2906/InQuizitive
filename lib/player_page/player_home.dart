import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inquizitive/helper/functions.dart';
import 'package:inquizitive/player_page/quiz_start.dart';
import 'package:inquizitive/widgets/appBar.dart';
import 'package:inquizitive/widgets/drawer.dart';
import 'package:inquizitive/services/database.dart';

class Player extends StatefulWidget {

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final _playerFormKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _key = GlobalKey();

  String _gamePin = null;

  bool isInvalidPin = false;

  bool isLoading =  false;

  String _name, _mail;

  Future<void> checkGamePin() async {
    setState(() {
      isLoading = true;
    });
    DatabaseServices databaseServices = new DatabaseServices();
    if(_playerFormKey.currentState.validate()) {
      
      Duration timelimit = const Duration(seconds: 10);
      QuerySnapshot collectionSnapShot = await databaseServices.getQuizData(_gamePin).catchError((err){
        setState(() {
          isLoading = false;
        });
        print(err.toString());
      }).timeout(timelimit, onTimeout: () {
        setState(() {
          isLoading = false;
        });
        return ;
       });
      if(collectionSnapShot == null){
        setState(() {
          isInvalidPin = true;
          return;
        });
      }
      List<DocumentSnapshot> temp = collectionSnapShot.documents;
//      print(temp.length);
      DocumentSnapshot documentSnapshot = temp[0];
//      print(documentSnapshot.data);
//      startQuiz(documentSnapshot);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => StartQuiz(documentSnapshot, _gamePin)
      ));
      setState(() {
        isLoading = false;
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      key: _key,
      drawerEdgeDragWidth: 0.0,
      drawerEnableOpenDragGesture: false,
      drawer: customDrawer(context),
      appBar: customAppBar(_key),
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ): Container(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width* 0.65,
            height: MediaQuery.of(context).size.height*0.1,
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
            child: Container(
              width: 10.0,
              alignment: Alignment.center,
              child: Form(
                key: _playerFormKey,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(letterSpacing: 5, fontSize: 20.0, ),
                  onChanged: (value) {
                    _gamePin = value;
                  },
                  onFieldSubmitted: _handleSubmitted,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: checkGamePin,
                    ),
                    hintText: "Enter InQuiz pin",
                    hintStyle: TextStyle(letterSpacing: 0, fontSize: 15.0, ),
                  ),
                  validator: (val) {
                    return val.isEmpty ? "Enter Pin" : isInvalidPin ? "Enter valid InQuiz Pin" : null;
                  },
                ),
              ),
            ),
          ),
        ),
      ),

    );
  }

  void _handleSubmitted(String value) {
    checkGamePin();
  }
}
