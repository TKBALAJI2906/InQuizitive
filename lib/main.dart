import 'package:flutter/material.dart';
import 'package:inquizitive/helper/functions.dart';
import 'package:inquizitive/home.dart';
import 'package:inquizitive/views/signin.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isLoggedIn = false;
  @override
  void initState() {
    checkUserLoggedInStatus();
    super.initState();
  }

  checkUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInDetails().then((value) async {
      setState(() {
        isLoggedIn = value;
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inquizitive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: HomeScreen(),
      home: (isLoggedIn ?? false) ? HomeScreen() : SignIn(),


    );
  }
}