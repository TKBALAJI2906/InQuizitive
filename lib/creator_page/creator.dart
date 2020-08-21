import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inquizitive/creator_page/showGamePin.dart';
import 'package:inquizitive/helper/functions.dart';
import 'package:inquizitive/services/database.dart';
import 'package:inquizitive/widgets/BaseButton.dart';
import 'package:inquizitive/widgets/drawer.dart';
import 'package:random_string/random_string.dart';
import 'package:inquizitive/widgets/appBar.dart';
import 'package:flutter/services.dart';

bool _isnewTF = false;
/*
define the number of questions of each of the following category : long answer, multiple choice, short answer, true/false
 */
int _mcqQnNo = 0;
int _shortQnNo = 0;
int _longQnNo = 0;
int _trueFalseQnNo = 0;
int _totalQnCount = 0;
Map<int, dynamic> superiorMap = {};
/*
this is a list of widgets
 */
List<dynamic> dynamicList = [];
/*
this is a list of lists containing MCQ options
 */
List<List<TextEditingController>> _mcqOptionController = [];
/*
 this is a list of text field controllers for questions
 */
List<TextEditingController> _questionsController = List<TextEditingController>.generate(10, (index) => TextEditingController());
/*
this is a list of text field controller for MCQ answers
 */
List<TextEditingController> _mcqAnswerController = [];
/*
this is a list of text field controllers for short answers
 */
List<TextEditingController> _shortAnswerController = [];
/*
this is a list of text field controllers for long answers
 */
List<TextEditingController> _longAnswerController = [];
/*
this is a list of answers for true or false type questions
 */
List<String> _trueOrFalseAnswers = [];
/*
This class gives instances for the mapping of question type, question number, type specific question number and the respective widget
 */
class CombineQnTypeAndQnNo {
  String _qnType;
  int _typeSpecificQnNo;
  int _qnNo;

  CombineQnTypeAndQnNo(int qnCount, String newValue) {
    this._qnType = newValue;
    this._typeSpecificQnNo = qnCount;
    this._qnNo = _totalQnCount;
  }
}


/*
This map has a key as the hashcode of widget and value as the question type
 */
Map _questionTypeMap = {};

class CreateScreen extends StatefulWidget {

  final String _title, _desc, _iURL;
  CreateScreen(this._title, this._desc, this._iURL);

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> with AutomaticKeepAliveClientMixin<CreateScreen>{

  DatabaseServices databaseServices = new DatabaseServices();

  bool isLoading = false;

  String quizID;


  /*
  this will add the widget to the list
   */
  addDynamic(){
    setState(() {
      _totalQnCount++;
      Widget dynamicWidget = new DynamicWidget();
      _questionTypeMap[dynamicWidget.hashCode];
      dynamicList.add(dynamicWidget);
      Timer(
          Duration(milliseconds: 300),
              () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));
    });

  }

  /*
  This function is to upload the questions with answers {and options}
   */
    bool checkQnAData() {

    bool _isEmpty = false;

    for(int i = 0; i < _totalQnCount ; i++){
      if(_questionsController[i] != null){
        print(i.toString());
        if(_questionsController[i].text.isNotEmpty){
          print("_questionsController[i].text");
        } else {
          print("error in question controller");
          _isEmpty = true;
        }
        print(_questionsController[i].text);
      }
    }

    for(int i = 0; i < _shortAnswerController.length ; i++){
      if(_shortAnswerController[i] != null){
        print(i.toString());
        print(_shortAnswerController[i].hashCode);
        if(_shortAnswerController[i].text.isNotEmpty){
          print("_shortAnswerController[i].text");
        } else {
          print("error in short answer controller");
          _isEmpty = true;
        }
        print(_shortAnswerController[i].text);
      }
    }

    for(int i = 0; i < _longAnswerController.length ; i++){
      if(_longAnswerController[i] != null){
        print(i.toString());
        if(_longAnswerController[i].text.isNotEmpty){
          print("_longAnswerController[i].text");
        } else {
          print("error in long answer controller");
          _isEmpty = true;
        }
        print(_longAnswerController[i].text);
      }
    }

    for(int i = 0; i < _mcqOptionController.length ; i++){
      if(_mcqOptionController[i] != null)
      for(int j = 0; j < _mcqOptionController[i].length ; j++){
        print(i.toString());
        if((_mcqOptionController[i][j]).text.isNotEmpty){
          print("(_mcqOptionController[i][j]).text+" "+i.toString()+" "+j.toString()");
        } else {
          print("error in multiple choice controller");
          _isEmpty = true;
        }
        print((_mcqOptionController[i][j]).text+" "+i.toString()+" "+j.toString());
      }
    }

    if(_isEmpty)
    {
      return _isEmpty;
    }
    print("-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

    print("-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

    uploadQuiz();


    /*
    Converting data to JSON
    */

  }

  uploadQuiz() async {

//      final GlobalKey <NavigatorState> navigatorkey = new GlobalKey<NavigatorState>();



    setState(() {
      isLoading = true;
    });

    quizID = (randomAlphaNumeric(5).hashCode.toString() + DateTime.now().hashCode.toString()).hashCode.toString();

    String _uid;
    final _auth = FirebaseAuth.instance;
    await _auth.currentUser().then((user) => _uid = user.uid);

    Map<String, String> questionMap = toJson(_uid);



    await databaseServices.addQuizQuestions(questionMap, quizID).then((value){
      print(questionMap);
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => GamePin(quizID)
      ));
      setState(() {
        isLoading = false;
      });
    }).catchError((e) => print(e.toString())).whenComplete(() =>   clearContents());

  }

  Map<String, String> toJson(String _uid){

      Map<String, String> finalMap = {
        "Title" : widget._title,
        "Desc" : widget._desc,
        "iURL" : widget._iURL,
        "_HoStId_" : _uid
      };

      int _localMcqQnNo = 0;
      int _localShortQnNo = 0;
      int _localLongQnNo = 0;
      int _localTrueFalseQnNo = 0;
      int _localQnCount = 0;

      _questionTypeMap.forEach((key, value) {
        print(_localQnCount);
        List<String> _localList= [];
          switch(value._qnType){
            case "Short Answer" :
              if(_questionsController[_localQnCount] != null && _shortAnswerController[_localShortQnNo] != null)
              {
                _localList.add(value._qnType);
                 _localList.add(_questionsController[_localQnCount].text);
                 _localList.add(_shortAnswerController[_localShortQnNo].text);
                 finalMap[_localQnCount.toString()] = _localList.toString();
               }
              _localShortQnNo++;
              break;
            case "Long Answer":
              if(_questionsController[_localQnCount] != null && _longAnswerController[_localShortQnNo] != null)
              {
                _localList.add(value._qnType);
                _localList.add(_questionsController[_localQnCount].text);
                _localList.add(_longAnswerController[_localLongQnNo].text);
                finalMap[_localQnCount.toString()] = _localList.toString();
              }
              _localLongQnNo++;
              break;
            case "Multiple Choice":
              if(_questionsController[_localQnCount] != null && _mcqAnswerController[_localShortQnNo] != null &&
                  (!(_mcqOptionController[_localMcqQnNo].any((element) => element == null)))
                )
              {
                _localList.add(value._qnType);
                _localList.add(_questionsController[_localQnCount].text);
                _localList.add(_mcqAnswerController[_localMcqQnNo].text);
                _mcqOptionController[_localMcqQnNo].forEach((element) {
                    _localList.add(element.text);
                });
                finalMap[_localQnCount.toString()] = _localList.toString();
              }
              _localMcqQnNo++;
              break;
            case "True/False":
              if(_questionsController[_localQnCount] != null && _trueOrFalseAnswers[_localTrueFalseQnNo] != null)
              {
                _localList.add(value._qnType);
                _localList.add(_questionsController[_localQnCount].text);
                _localList.add(_trueOrFalseAnswers[_localTrueFalseQnNo].substring(0,1));
                finalMap[_localQnCount.toString()] = _localList.toString();
              }
              _localTrueFalseQnNo++;
              break;
          }
          _localQnCount++;
      });
      print("*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-");
      finalMap.forEach((key, value) {
        print(key);
        print(value);
      });
      return finalMap;
  }

  GlobalKey<ScaffoldState> _key = GlobalKey();
  bool get wantKeepAlive => true;
  ScrollController _scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: backPressed,
      child: Scaffold(
        key: _key,
        appBar: customAppBar(_key),
        drawer: customDrawer(context),
        body: isLoading ? Container(
          child: Center(child: CircularProgressIndicator()),
        ) : (_totalQnCount == 0) ? Container(
          child: Center(
            child: Text("Click + to add questions", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),),
          )
        ): new Container(
          padding: EdgeInsets.all(5.0),
          child: new Column(
            children: <Widget>[
              new Flexible(child: new ListView.builder(
                controller: _scrollController,
                itemCount: dynamicList.length,
                itemBuilder: (_, index) {
                  return (dynamicList[index] != null) ? ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics (),
                    children: [
                      dynamicList[index],
                      Align(
                        alignment: AlignmentDirectional.bottomEnd,
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: (){
                            setState(() {
                                if (_questionTypeMap[dynamicList[index].hashCode] != null) {
                                  int indexToBeDeleted = _questionTypeMap[dynamicList[index].hashCode]._typeSpecificQnNo;
                                  switch (_questionTypeMap[dynamicList[index].hashCode]._qnType) {
                                    case "Short Answer" :
                                      _shortAnswerController[indexToBeDeleted - 1] = null;
                                      _shortQnNo--;
                                      break;
                                    case "Long Answer":
                                      _longAnswerController[indexToBeDeleted - 1] = null;
                                      _longQnNo--;
                                      break;
                                    case "Multiple Choice":
                                      _mcqAnswerController[indexToBeDeleted - 1] = null;
                                      _mcqOptionController[indexToBeDeleted - 1] = null;
                                      _mcqQnNo--;
                                      break;
                                    case "True/False":
                                      _trueOrFalseAnswers[indexToBeDeleted - 1] = null;
                                      _trueFalseQnNo--;
                                      break;
                                  }
                                  _questionsController[_questionTypeMap[dynamicList[index].hashCode]._qnNo - 1] = null;
                                  _questionTypeMap.remove(dynamicList[index].hashCode);
                                }
                                dynamicList[index] = null;
                                _totalQnCount--;
                            });
                          },
                        ),
                      ),
                      Divider(
                        color: Colors.blueGrey,
                        thickness: 2,
                      )
                    ],
                  ) : Container();
                },
                physics: ClampingScrollPhysics (),

              )),

              new Container(
                child: new RaisedButton(
                  onPressed: ()  async {
                    try {
                      await InternetAddress.lookup('google.com').then((result) async {
                        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                          print('connected');
                          if(checkQnAData() ?? false){
                            showDialog(
                              context: context,
                              builder: (context) => new AlertDialog(
                                title: new Text('Alert'),
                                content: Text(
                                  'Please fill all the fields'),
                                actions: <Widget>[
                                  new FlatButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true).pop(false);
                                    },
                                    child: new Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      });
                    } on SocketException catch (_) {

                      showDialog(
                          context: context,
                          builder: (context) => new AlertDialog(
                              title: Text("Oh Shuck!"),
                              content: SizedBox(
                                height: 100,
                                child: Column(
                                    children :[
                                      SizedBox(
                                        child: Image.asset('assets/images/no_internet.png',width: 70, height: 70,),
                                      ),
                                      Text("No or Slow Internet Connectivity")
                                    ]
                                ),
                              ),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true).pop(false);
                                    },
                                    child: new Text('OK'),
                                )
                              ],
                            ),
                      );
                    }
                  },
                  child: baseColorButton(context, "Upload Questions",isUpload: true),
                  color: Colors.transparent,
                  elevation: 0.0,
                  ),
                ),
               // isFirebaseConnectionFailed ? Banner(message: "Upload Failed! Check for Internet Connectivity", location: BannerLocation.bottomEnd) : null
            ],
          ),
        ),

        floatingActionButton: isLoading ? Container() : FloatingActionButton(
          onPressed: addDynamic,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Future<bool> backPressed() {
    return showDialog(
        context: context,
      builder: (context) => AlertDialog(
        title: Text("Do you really want to exit?"),
        content: Text("This will discard your work"),
        actions: <Widget>[
          FlatButton(
              child: Text("Yes"),
              onPressed: () {clearContents();  Navigator.pop(context, true);}
          ),
          FlatButton(
              child: Text("No"),
              onPressed: () => Navigator.pop(context, false),
          )
        ],
      )
    );
  }

  void clearContents() {
       dynamicList.clear();
       _mcqOptionController.clear();
       _questionsController.clear();
       _mcqAnswerController.clear();
       _questionTypeMap.clear();
       _questionsController = List<TextEditingController>.generate(10, (index) => TextEditingController());
       _mcqQnNo = 0;
       _shortQnNo = 0;
       _longQnNo = 0;
       _trueFalseQnNo = 0;
       _totalQnCount = 0;

  }

}



class DynamicWidget extends StatefulWidget {
  @override
  _DynamicWidgetState createState() => _DynamicWidgetState();
}

class _DynamicWidgetState extends State<DynamicWidget> with AutomaticKeepAliveClientMixin<DynamicWidget>{
  String dropdownValue;
  bool isChange = false;
  List<dynamic> mcqOptions =  [];
  var includeQns = Container(
      child: Column(
        children: <Widget>[
          TextField(
            controller: _questionsController[dynamicList.length-1],
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Type Question here...'
            ),
          ),
        ],
      )
  );

  List<TextEditingController> _thisMcqAllOptionController = [];
  TextEditingController _thisMcqAnswerController = new TextEditingController();
  bool isVisible = false;

  bool highlightTrue = false, highlightFalse = false;

  int tfIndex = null;

  bool get wantKeepAlive => true;

  String tappedString ;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width*0.4,
              child: Text("Select your question type "),
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.4,
              child: DropdownButton<String>(
                items: <String>[
                  'Short Answer',
                  'Multiple Choice',
                  'True/False',
                  'Long Answer'
                ].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );

                }).toList(),
                onTap: (){
                  this.tappedString = this.dropdownValue;
                  print(this.tappedString);
                },
                onChanged: (String newValue) {
                  if( this.tappedString != null && this.tappedString != newValue ) {
                    int indexToBeDeleted = _questionTypeMap[this.widget.hashCode]._typeSpecificQnNo;
                    print(indexToBeDeleted);
                    switch (_questionTypeMap[this.widget.hashCode]._qnType) {
                      case "Short Answer" :
                        print(_shortAnswerController[indexToBeDeleted - 1].hashCode);
//                        print(_shortAnswerController[indexToBeDeleted - 1].text);
                        _shortAnswerController[indexToBeDeleted - 1] = null;
                        _shortQnNo--;
                        break;
                      case "Long Answer":
                        _longAnswerController[indexToBeDeleted - 1] = null;
                        _longQnNo--;
                        break;
                      case "Multiple Choice":
                        _mcqAnswerController[indexToBeDeleted - 1] = null;
                        _mcqOptionController[indexToBeDeleted - 1] = null;
                        _mcqQnNo--;
                        break;
                      case "True/False":
                        _trueOrFalseAnswers[indexToBeDeleted - 1] = null;
                        _trueFalseQnNo--;
                        break;
                    }
                  }
                  this.tappedString = null;
                  setState(() {
                    isChange = true;
                    this.dropdownValue = newValue;
                    int temp;
                    switch(newValue){
                      case "Short Answer" :
                        temp = ++_shortQnNo;
                        break;
                      case "Long Answer":
                        temp = ++_longQnNo;
                        break;
                      case "Multiple Choice":
                        temp = ++_mcqQnNo;
                        break;
                      case "True/False":
                        _isnewTF = true;
                        temp = ++_trueFalseQnNo;
                        break;
                    }
                    if(!(_questionTypeMap.containsKey(super.widget))){
                      _questionTypeMap[super.widget.hashCode] = new CombineQnTypeAndQnNo(temp,newValue);
                    } else{
                      _questionTypeMap.update(super.widget.hashCode, (value) => new CombineQnTypeAndQnNo(_questionTypeMap[super.widget.hashCode]._typeSpecificQnNo, newValue));
                    }
                    _questionTypeMap.forEach((key, value) => print(key.toString()+" "+value._typeSpecificQnNo.toString() +" "+value._qnType+" "+value._qnNo.toString()));
                    print("-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
                  });
                },
                hint: Text("Question type"),
                value:dropdownValue,
              ),
            )
          ],
        ),
        Container(
          child: isChange ? includeQns : Container(height: 0),
        ),
        (dropdownValue != null) ?
        question(dropdownValue) : Container(),
      ],
    );
  }

  Widget question(String type)  {
    Widget returnContainer;

    switch (type) {
      case "Short Answer" :

        TextEditingController _answerController = new TextEditingController();
        returnContainer = Container(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _answerController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Your answer'
                  ),
                  maxLength: 50,
                ),
              ],
            )
        );
        _shortAnswerController.add(_answerController);
        break;

      case "Long Answer":
        TextEditingController _answerController = new TextEditingController();
        returnContainer = Container(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _answerController,
                  decoration: InputDecoration(
                      hintText: 'Your answer'
                  ),
                ),
              ],
            )
        );
        _longAnswerController.add(_answerController);
        break;

      case "True/False":
        print(_trueFalseQnNo.toString()+" "+tfIndex.toString()+" "+_trueOrFalseAnswers.length.toString());
        tfIndex = (tfIndex == null) ? 0 : tfIndex;
        print(_trueFalseQnNo.toString()+" "+tfIndex.toString());
        returnContainer = Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Answer Key"),
              Spacer(),
              FlatButton(
                highlightColor: highlightTrue ? Colors.blue : null,
                  color: Colors.greenAccent,
                  child: Text("TRUE"),
                  onPressed: () {
                    setState(() {
                      (_isnewTF) ?
                            _trueOrFalseAnswers.add("1"+this.widget.hashCode.toString()) :
                               _trueOrFalseAnswers[_trueOrFalseAnswers.indexOf("0"+this.widget.hashCode.toString())] = "1"+this.widget.hashCode.toString();
                      highlightTrue = true;
                      highlightFalse = false;
                      (_isnewTF) ? (_isnewTF = false) : null;
                    });
                  },
              ),
              Spacer(),
              FlatButton(
                  highlightColor: highlightTrue ? Colors.blue : null,
                  color: Colors.redAccent,
                  child: Text("FALSE"),
                  onPressed: () {
                    setState(() {
                      (_isnewTF) ?
                        _trueOrFalseAnswers.add("0"+this.widget.hashCode.toString()) :
                          _trueOrFalseAnswers[_trueOrFalseAnswers.indexOf("1"+this.widget.hashCode.toString())] = "0"+this.widget.hashCode.toString();
                      highlightTrue = false;
                      highlightFalse = true;
                      (_isnewTF) ? (_isnewTF = false) : null;
                    });
                  }
              )
            ],
          ),
        );
        for(int i =0 ; i < _trueOrFalseAnswers.length; i++){
          print(_trueOrFalseAnswers[i]);
        }
        print("*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-");
        break;

      case "Multiple Choice":
          setState(() {
            returnContainer =new Container(
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics (),
                children: <Widget>[
                  new ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics (),
                      itemCount: this.mcqOptions.length,
                      itemBuilder: (_, index) {
                        return (this.mcqOptions.isNotEmpty && this.mcqOptions[index] != null) ? this.mcqOptions[index] : Container();
                      }
                  ),
                  // McqOptions(),
                  Divider(height: 3.0, color: Colors.grey,),
                  Visibility(
                      child :TextField(
                        controller: _thisMcqAnswerController,
                        decoration: InputDecoration(
                          hintText: "Enter option number of answer",
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    visible: isVisible,
                  ),
                  Container(
                    child : RaisedButton(
                        shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        color: Colors.lightBlueAccent,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                           Padding(
                             padding: const EdgeInsets.all(4.0),
                             child: Icon(
                               Icons.add_circle_outline,
                               color: Colors.white,
                            ),
                           ),
                           Padding(
                             padding: const EdgeInsets.all(2.0),
                             child: Text(
                               "Add option",
                               style: TextStyle(
                                 color: Colors.pink,
                                 fontWeight: FontWeight.bold,
                               ),
                            ),
                          ),
                       ],
                     ),
                      onPressed: () {
                        TextEditingController _thisMcqOptionController = new TextEditingController() ;
                        addMcqOptions(this.mcqOptions.length, _thisMcqOptionController,_thisMcqAllOptionController);
                        _thisMcqAllOptionController.add(_thisMcqOptionController);
                        setState(() {
                          isVisible = true;
                        });
                      }
                    ),
                  ),
                ],
              )
          );
          if(_thisMcqAllOptionController.length == 0) {
            _mcqOptionController.add(_thisMcqAllOptionController);
//            print("---------adding a question----------");
            _mcqAnswerController.add(_thisMcqAnswerController);
//            print("---------adding option-----------");
           }
          });
        break;
    }
    return returnContainer;
  }

  addMcqOptions(int length, TextEditingController controller, List<TextEditingController> controllers) {

    setState(() {
      //no of qns can be incremented
      mcqOptions.add(new McqOptions(length: length,optionsController : controller, listOfOptionsControllers: controllers));
    });
  }

  void deleteMcqOptions(List<TextEditingController> iController,TextEditingController jController){
      int i = _mcqOptionController.indexOf(iController);
      int j = iController.indexOf(jController);
      print(_mcqOptionController[i][j].text);
      //_mcqOptionController[i][j] = null;
      iController.remove(jController);
      print(_mcqOptionController[i][j]);
  }

}

class McqOptions extends StatefulWidget {

  num length;
  TextEditingController optionsController;
  List<TextEditingController> listOfOptionsControllers;
  McqOptions({Key key, @required this.length,@required this.optionsController, @required this.listOfOptionsControllers}) : super(key: key);

  @override
  _McqOptionsState createState() => _McqOptionsState();
}

class _McqOptionsState extends State<McqOptions> {

  void deleteMcqOptionField(){
    setState(() {
      _DynamicWidgetState obj = new _DynamicWidgetState();
      obj.deleteMcqOptions(widget.listOfOptionsControllers, widget.optionsController);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: widget.optionsController,
        decoration: InputDecoration(
            hintText: 'Option ${widget.length+1}',
        ),

      ),
    );
  }

}

