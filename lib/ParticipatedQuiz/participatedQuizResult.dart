import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inquizitive/widgets/appBar.dart';
import 'package:inquizitive/widgets/drawer.dart';

class ParticipatedQuizList extends StatefulWidget {

  final  Map<String, dynamic> participationDetailsMap;
  ParticipatedQuizList(this.participationDetailsMap);
  @override
  _ParticipatedQuizListState createState() => _ParticipatedQuizListState();
}

class _ParticipatedQuizListState extends State<ParticipatedQuizList> {
  GlobalKey<ScaffoldState> _key = GlobalKey();

  bool isLoading = false;

  String getTitle(int index) {
    return widget.participationDetailsMap.values.elementAt(index)[0];
  }

  String getSubtitle(int index){
    return widget.participationDetailsMap.values.elementAt(index)[1];
  }

  String getScore(int index){
    return widget.participationDetailsMap.values.elementAt(index)[3];
  }

  String getQuizId(int index){
    return widget.participationDetailsMap.keys.elementAt(index);
  }

  getImage(int index) {
    return Image.network(widget.participationDetailsMap.values.elementAt(index)[2]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: customAppBar(_key),
        drawer: customDrawer(context),
        body: isLoading ? Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ) : Container(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemCount: widget.participationDetailsMap.length,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index){
              return Card(
//                margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                color: Color.fromARGB(255, 190, 230, 243),
                child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      child: getImage(index)
                    ),
                    title: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(getTitle(index), style: TextStyle(color: Color.fromARGB(255, 42, 87, 131), fontWeight: FontWeight.bold),),
                          ),
                          SizedBox(height: 1,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(getQuizId(index), style: TextStyle(color: Color.fromARGB(255, 42, 87, 131),)),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Container(
                      margin: EdgeInsets.only(top: 3),
                      child: Text(getSubtitle(index), style: TextStyle(color: Color.fromARGB(255, 42, 87, 131)),)
                    ),
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
          ),
        )
    );
  }
}
