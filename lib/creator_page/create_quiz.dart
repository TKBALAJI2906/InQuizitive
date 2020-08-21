import 'package:flutter/material.dart';
import 'package:inquizitive/creator_page/creator.dart';
import 'package:inquizitive/helper/functions.dart';
import 'package:inquizitive/widgets/appBar.dart';
import 'package:inquizitive/widgets/BaseButton.dart';
import 'package:inquizitive/widgets/drawer.dart';

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {

  final _formKey = GlobalKey<FormState>();

  GlobalKey <ScaffoldState> _key = GlobalKey();

  String _title, _desc, _iURL, quizID;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: customAppBar(_key),
      drawer: customDrawer(context),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: (value) => value.isEmpty ? "Enter Quiz title" : null,
                  decoration: InputDecoration(
                      hintText: "InQuiz title"
                  ),
                  onChanged: (val){
                    _title = val;
                  },
                ),
                SizedBox(height: 6,),
                TextFormField(
                  validator: (value) => value.isEmpty ? "Enter Quiz description" : null,
                  decoration: InputDecoration(
                      hintText: "InQuiz Description"
                  ),
                  onChanged: (val){
                    _desc = val;
                  },
                ),
                SizedBox(height: 6,),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: "InQuiz Image URL (optional)"
                  ),
                  onChanged: (val){
                    _iURL = val;
                  },
                ),
                Spacer(),
                GestureDetector(
                    onTap: () {
                      if(_formKey.currentState.validate()){
                        Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => CreateScreen(_title, _desc, _iURL)
                        ));
//                        print(_title+" "+ _desc+" "+ _iURL);
                      print(_title);
                      print(_desc);
                      print(_iURL);
                      }
                    },
                    child: baseColorButton(context,"Create Quiz")
                ),
                SizedBox(height: 50,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}