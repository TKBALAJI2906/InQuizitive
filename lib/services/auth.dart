import 'package:firebase_auth/firebase_auth.dart';
import 'package:inquizitive/helper/functions.dart';
import 'package:inquizitive/model/user.dart';

class AuthService{

  FirebaseAuth _auth = FirebaseAuth.instance;
  static String userID;
  static String name;

  User _userFromFirebaseUser(FirebaseUser user){
    userID = (user != null) ? user.uid : null;
    return user != null ? User(user.uid) :null;
  }

  Future signInEmailAndPass(String email, String password) async {
    try{
      AuthResult _authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser _user = _authResult.user;
      if(_user != null){
        HelperFunctions.saveUserLoggedInDetails(isLoggedIn: true, mail: email, name: _user.displayName);
      }
      return _userFromFirebaseUser(_user);
    } catch(e){
      print(e.toString());
    }
  }

  Future signUpEmailAndPass(String email, String password, String name) async{
    try{
      AuthResult _authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser _user = _authResult.user;
      var userUpdateInfo = new UserUpdateInfo();
      userUpdateInfo.displayName = name;
      await _user.updateProfile(userUpdateInfo);
      await _user.reload();
      return _userFromFirebaseUser(_user);
    } catch(e){
      print(e.toString());
    }
  }


  Future signOut() async{
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
    }
  }

//  Future getUser() async {
//    FirebaseUser _user = await _auth.currentUser();
//    return _userFromFirebaseUser(_user);
//  }

}