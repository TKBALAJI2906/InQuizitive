import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{

  static String userLoggedInKey = "USERLOGGEDINKEY";
  static String emailId;
  static String displayName;

  static saveUserLoggedInDetails({@required bool isLoggedIn, @required String mail, @required String name}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(userLoggedInKey, isLoggedIn);
    prefs.setString(emailId, mail);
    prefs.setString(displayName, name);
  }

  static Future<bool> getUserLoggedInDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(userLoggedInKey);
  }

  static Future<String> getUserMailId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailId);
  }

  static Future<String> getUserDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(displayName);
  }


}