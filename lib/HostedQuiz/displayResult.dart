import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inquizitive/helper/functions.dart';
import 'package:inquizitive/widgets/appBar.dart';
import 'package:inquizitive/widgets/drawer.dart';

class DisplayResult extends StatefulWidget {
  final String quizId;
  DisplayResult(this.quizId);

  @override
  _DisplayResultState createState() => _DisplayResultState(quizId);
}

class _DisplayResultState extends State<DisplayResult> {

  GlobalKey<ScaffoldState> _key = GlobalKey();

  bool isLoading = true;

  final String quizId;

  _DisplayResultState(this.quizId);

  List<Map<dynamic, dynamic>> resultMapList = [];

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    getResults();
    super.initState();
  }

  Future<void> getResults() async {
    await FirebaseAuth.instance.currentUser().then((user) async {
      FirebaseDatabase.instance.reference().child("result").child(user.uid).child(quizId).once().then((value) {
        value.value.forEach((k,v)  {
          resultMapList.add(v);
        });
      }).then((value) {
        setState(() {
          isLoading = false;
        });
      });
    });

  }

  String getTitle(int index) {
    return resultMapList[index].keys.toList().elementAt(0).toString();
  }

  String getSubtitle(int index){
    return resultMapList[index].values.toList().elementAt(0).toString().split(',').elementAt(0);
  }

  String getScore(int index){
    return resultMapList[index].values.toList().elementAt(0).toString().split(',').elementAt(1);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: customAppBar(_key),
        drawer: customDrawer(context),
        body: isLoading ?  Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ) : Container(
            child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10),
                itemCount: resultMapList.length,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index){
                  return Card(
//                margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    color: Color.fromARGB(255, 190, 230, 243),
                    child: ListTile(
                        leading: Icon(Icons.account_circle, color: Color.fromARGB(255, 6, 88, 157), size: 37,),
                        title: Text(getTitle(index), style: TextStyle(color: Color.fromARGB(255, 42, 87, 131), fontWeight: FontWeight.bold),),
                        subtitle: Text(getSubtitle(index), style: TextStyle(color: Color.fromARGB(255, 42, 87, 131)),),
                        trailing: Column(
                          children: <Widget>[
                            Spacer(),
                            Text("SCORE", style: TextStyle(color: Color.fromARGB(255, 29, 60, 90), fontWeight: FontWeight.w500),),
                            Text(getScore(index), style: TextStyle(color: Color.fromARGB(255, 42, 87, 131)),),
                            Spacer(),
                          ],
                        )
                    ),
                  );
                }
            )
        )
    );
  }


}