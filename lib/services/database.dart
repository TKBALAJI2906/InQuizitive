import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseServices{

  static String _uid;
  final _auth = FirebaseAuth.instance;

  Future<void> initializeUid() async {
    await _auth.currentUser().then((user) => _uid = user.uid).then((value) {
      print(_uid);
      print("done!!!");
    });
  }

  Future<void> addQuizQuestions(Map quizQuestionData, String quizID) async {
    if(_uid == null) {
      print("uid is null");
      initializeUid().then((value) async {
//        print(_uid);
//        print(quizID);
//        print(quizQuestionData);
        await Firestore.instance.collection(quizID).document(_uid).setData(quizQuestionData).then((value) => Firestore.instance.collection(quizID).document("results"));
      });
    }
  }

  Future<QuerySnapshot> getQuizData (String quizID) async {
    return await Firestore.instance.collection(quizID).getDocuments().catchError((error) {
      return null;
    });
  }

  Future<void> uploadResult(Map<String, String> result, String quizID, String hostId, List<String> quizDataList) async {

    //To be commented : from this//
//    await Firestore.instance.collection("result").document(hostId).collection(
//        quizID).document("result").get().then((value) async {
//      if (value.exists) {
//        await Firestore.instance.collection("result").document(hostId)
//            .collection(quizID).document("result").setData(result)
//            .then((value) async {
//          Map<String, String> data = {
//            quizID: "3"
//          };
//          await Firestore.instance.collection("result")
//              .document(hostId)
//              .setData(data);
//        });
//      } else {
//        await Firestore.instance.collection("result").document(hostId)
//            .collection(quizID).document("result")
//            .setData(result);
//      }
//    });
    //To be commented : till this//

    String uid;
    String score = result.values.toList().elementAt(0).split(',').elementAt(1);
    quizDataList.add(score);
    await FirebaseAuth.instance.currentUser().then((user) {
      uid = user.uid;
    }).then((value) async {
      Map<String, dynamic> map = {
        quizID : quizDataList
      };
      await Firestore.instance.collection("result").document(uid).updateData(map);
    });

    
    
    String displayname = result.keys.toList().elementAt(0);

    final dbRef = FirebaseDatabase.instance.reference().child("result").child(hostId);
    dbRef.child(quizID).push().set({
      displayname : score
    }).catchError((onError) => print(onError.toString()));
  }



}