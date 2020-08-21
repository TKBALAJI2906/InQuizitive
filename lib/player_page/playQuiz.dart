import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inquizitive/player_page/result_page.dart';
import 'package:inquizitive/widgets/BaseButton.dart';
import 'package:inquizitive/widgets/appBar.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';


class BundleOutQnAns {
  String field;
  List value;

  BundleOutQnAns(this.field,this.value);
}

class PlayQuiz extends StatefulWidget {

  final String gamePin;
  final DocumentSnapshot docs;
  final List<String> quizDetailsList;
  PlayQuiz({Key key,@required this.docs, @required this.gamePin, @required this.quizDetailsList}) : super(key : key);


  @override
  _PlayQuizState createState() => _PlayQuizState(docs);
}

class _PlayQuizState extends State<PlayQuiz> {

  GlobalKey<ScaffoldState> _key = GlobalKey();

  bool isSubmit;

  final DocumentSnapshot docs;

  _PlayQuizState(this.docs);

  Map dataMap;

  int qnNo = 0;
  
  List <BundleOutQnAns> dataList = List();

  List<String> submittedAnswerList = [];

  List<String> originalAnswerList = [];

  bool result = false;

  String hostId;

  @override
  void initState() {
    dataMap = docs.data;
//    print("dataMap");
//    print(dataMap);
    List descList = ["iURL", "Desc", "Title", "_HoStId_"];
    hostId = dataMap["_HoStId_"];
    dataMap.forEach((key, value) => (descList.contains(key)) ? print(key) :
        dataList.add(BundleOutQnAns(key, value.split(","))));
    dataList.sort((a,b) => int.parse(a.field).compareTo(int.parse(b.field)));
    dataList.forEach((element) {
      element.value[0] = element.value[0].substring(1);
      int last = element.value.length - 1, len =  element.value[last].toString().length - 1;
      element.value[last] = element.value[last].substring(0,len);
      len == 2 ? originalAnswerList.add(element.value[last].toString().trim()): originalAnswerList.add(element.value[2].toString().trim());
    });
//    print(originalAnswerList);
//    print("dataList");
//    print(dataList);
//    dataList.forEach((element) {
//      print("key"); print(element.field);
//      print("value"); print(element.value);
//    });
    isSubmit = (dataList.length == 1) ? true : false;
    super.initState();
//    print("qnNo");
//    print(qnNo);
  }

  TextEditingController _textEditingController = new TextEditingController();

  final CountdownController countDownController = CountdownController();

    @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
    );
    return WillPopScope(
      onWillPop: (){
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: RichText(
              text: TextSpan(
                  style: TextStyle(fontSize: 22),
                  children: <TextSpan>[
                    TextSpan(text: 'In', style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.black54
                    )),
                    TextSpan(text: 'Quizitive', style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue
                    ))
                  ]
              ),
            ),
            content: Text("Submit before exit!"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("OK"),
              )
            ],
          )
        );
      },
      child: Scaffold(
        appBar: customAppBar(_key, profileNeeded: false),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Row(
                children: <Widget>[
                   Expanded(
                     flex: 4,
                     child: Container(
                         padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
                         alignment: Alignment.topLeft,
                         child: Text(dataList[qnNo].value[1],style: GoogleFonts.quando(fontSize: 16.0 )),
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Countdown(
                          controller: countDownController,
                          seconds: 60,
                          build: (_, double time) => Text(
                            time.toInt().toString(),
                            style:  TextStyle(
                              fontSize: 22.0,
                              color: (time.toInt() > 5) ? Colors.black87 : Colors.red,
                              fontWeight: FontWeight.bold),
                          ),
                          interval: Duration(seconds: 1),
                          onFinished: (){
                            setState(() {
                              submittedAnswerList.add("");
                              if(qnNo != dataList.length - 1) {
                                qnNo++;
                                countDownController.restart();
                              } else {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => ResultPage(answerList: submittedAnswerList, dataList: originalAnswerList, gamePin: widget.gamePin, hostID: hostId, quizDetailsList: widget.quizDetailsList,)
                                ));
                              }
                            });
                            print(submittedAnswerList);
                            print(submittedAnswerList.length.toString());
                          },
                        ),
                      ),
                    )
                 ],
                ),
              ),
            Divider(height: 5.0, thickness: 5.0,),
            Expanded(
              flex: 9,
                child: (dataList[qnNo].value[0] == "Short Answer") ? Container(
                   margin: EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 15.0),
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: "Your Answer",
                      ),
                      maxLength: 50,
                    ),
                  )
                        : (dataList[qnNo].value[0] == "Long Answer") ?  Container(
                    margin: EdgeInsets.all(15.0),
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: "Your Answer",
                      ),
                    )
                  )
                          :(dataList[qnNo].value[0] == "Multiple Choice") ? Container(
                      margin: EdgeInsets.all(15.0),
                    width: MediaQuery.of(context).size.width*0.7,
                      alignment: Alignment.center,
                          child: Center(
                            child: new ListView.builder(
                              shrinkWrap: true,
                              itemCount : dataList[qnNo].value.length-3,
                              itemBuilder: (BuildContext context, int index) {
                                return new ListView(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  children: <Widget>[
                                    Card(
                                      elevation: 0.0,
                                      child: GestureDetector(
                                          onTap: (){
                                            submittedAnswerList.add((index+1).toString());
                                            setState(() {
                                              if( qnNo < dataList.length - 1){
                                                setState(() {
                                                  qnNo++;
                                                  countDownController.restart();
                                                });
                                                
                                              }
                                              if( qnNo == dataList.length - 1)
                                                setState(() {
                                                  isSubmit = true;
                                                });
                                              print(submittedAnswerList);
                                              print(submittedAnswerList.length.toString());
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 16),
                                            decoration: BoxDecoration(
                                                color: Colors.yellow[300],
                                                borderRadius: BorderRadius.circular(30)
                                            ),
                                            alignment: Alignment.center,
                                            height: MediaQuery.of(context).size.height*0.075,
                                            child: Text( dataList[qnNo].value[index+3], style: TextStyle(color: Colors.redAccent, fontSize: 16),),
                                          )
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          )
                  ) : Container(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          FlatButton(onPressed: (){
                            submittedAnswerList.add("1");
                            print("True");
                            setState(() {
                              if( qnNo < dataList.length - 1){
                                setState(() {
                                  qnNo++;
                                  countDownController.restart();
                                });
                              }
                              if( qnNo == dataList.length - 1)
                                setState(() {
                                  isSubmit = true;
                                });
                              print(submittedAnswerList);
                              print(submittedAnswerList.length.toString());
                            });
                          }, child: Text("True"),splashColor: Colors.green[800],color: Colors.green[400],),
                          FlatButton(onPressed: (){
                            submittedAnswerList.add("0");
                            print("False");
                            setState(() {
                              if( qnNo < dataList.length - 1){
                                setState(() {
                                  qnNo++;
                                  countDownController.restart();
                                });
                              }
                              if( qnNo == dataList.length - 1)
                                setState(() {
                                  isSubmit = true;
                                });
                              print(submittedAnswerList);
                              print(submittedAnswerList.length.toString());
                            });
                          }, child: Text("False"),splashColor: Colors.red[800],color: Colors.red[400])
                        ],
                      ),
                    ),
                  ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10.0),
                  child : GestureDetector(
                    onTap: () {
                      if(isSubmit){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => ResultPage(answerList: submittedAnswerList, dataList: originalAnswerList, gamePin: widget.gamePin, hostID: hostId, quizDetailsList: widget.quizDetailsList,)
                        ));
                      }
                      if(dataList[qnNo].value[0] == "Short Answer" || dataList[qnNo].value[0] == "Long Answer" ){
                        submittedAnswerList.add(_textEditingController.text);
                        _textEditingController.clear();
                      } else {
                        submittedAnswerList.add("");
                      }
                      setState(() {
                        if( qnNo < dataList.length - 1){
                          setState(() {
                            qnNo++;
                            print(qnNo);
                            countDownController.restart();
                          });
                        }
                        if( qnNo == dataList.length - 1)
                          setState(() {
                            print(qnNo);
                            isSubmit = true;
                          });
                        print(submittedAnswerList);
                        print(submittedAnswerList.length.toString());
                      });
                    },
                      child: baseColorButton(context, isSubmit ? "Submit" : "Next", color: isSubmit ? Colors.redAccent : Colors.blue)
                  ),
              ),
            ),
          ],
        ),
    ),
    );
  }

}

