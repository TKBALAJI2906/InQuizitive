import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inquizitive/HostedQuiz/displayResult.dart';
import 'package:inquizitive/helper/functions.dart';
import 'package:inquizitive/services/database.dart';
import 'package:inquizitive/widgets/appBar.dart';
import 'package:inquizitive/widgets/drawer.dart';

class HostedQuizList extends StatefulWidget {
  final List<String> quizList;
  HostedQuizList({@required this.quizList});
  @override
  _HostedQuizListState createState() => _HostedQuizListState(quizList);
}

class _HostedQuizListState extends State<HostedQuizList> {

  final List<String> quizList;

  bool isLoading = true;

  _HostedQuizListState(this.quizList);
  
  GlobalKey<ScaffoldState> _key = GlobalKey();

  final List<String> quizNameList = [];
  final List<String> quizDescriptionList = [];
  final List<String> quizImgList = [];


  @override
  void initState()  {

//    print(quizList);
//    print(quizList.length.toString());
    DatabaseServices databaseServices = new DatabaseServices();
    quizList.forEach((quizID) async {
      await databaseServices.getQuizData(quizID).then((collectionSnapshot) {
        quizNameList.add(collectionSnapshot.documents[0].data["Title"]);
        quizDescriptionList.add(collectionSnapshot.documents[0].data["Desc"]);
        quizImgList.add(collectionSnapshot.documents[0].data["iURL"]);
      }).catchError((onError) => print(onError.toString())).then((value) {
        setState(() {
          isLoading = false;
        });
//        for(int i = 0 ; i < quizNameList.length ; i++){
//          print(quizNameList[i] + i.toString());
//          print(quizDescriptionList[i] + i.toString());
//          print(quizImgList[i] + i.toString());
//        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
        margin: EdgeInsets.all(10),
        child: ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: quizList.length,
            itemBuilder: (context, index) {
              return Card(
                  child: Material(
                        elevation: 10.0,
                        borderRadius: BorderRadius.circular(8.0),
                        child:Stack(
                            children: <Widget>[
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child:  FadeInImage(image: NetworkImage(quizImgList[index]),
                                    placeholder: AssetImage("assets/images/inquizitive_logo.png"),
                                    fit: BoxFit.fill, width: MediaQuery.of(context).size.width , height: 225,)
                              ),
                               GestureDetector(
                                 onTap: () {
                                   Navigator.of(context).push(MaterialPageRoute(
                                       builder: (context) => DisplayResult(quizList[index])
                                   ));
                                 },
                                 child: Container(
                                   height: MediaQuery.of(context).size.height / 3.28,
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(quizNameList[index], style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),),
                                          SizedBox(height: 6,),
                                          Text(quizDescriptionList[index], style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),),
                                          SizedBox(height: 6,),
                                        ],
                                      ),
                                  ),
                               ),
                            ],
                          ),

                      ),

//                child: ListTile(
//                  title: ,
//                  subtitle: Center(
//                      child: Text(quizList[index])
//                  ),
//                ),
                );
            }
        ),


      ),
    );
  }
}
