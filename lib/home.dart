import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inquizitive/player_page/player_home.dart';
import 'package:inquizitive/creator_page/create_quiz.dart';
import 'package:inquizitive/widgets/BaseButton.dart';
import 'package:inquizitive/widgets/appBar.dart';
import 'package:inquizitive/widgets/drawer.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawerEdgeDragWidth: 0.0,
      drawerEnableOpenDragGesture: false,
      drawer: customDrawer(context),
      appBar: customAppBar(_key),
      body: CreateOrJoinButton(),
    );
  }
}

class CreateOrJoinButton extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize : MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => CreateQuiz()
              ));
            },
              child: baseColorButton(context, "Host InQuiz", color: Colors.red[500])
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => Player()
              ));
            },
              child: baseColorButton(context, "Join InQuiz", color: Colors.green[500])
          ),
        ],
      ),
    );
  }
}
