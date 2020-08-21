import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width* 0.6,
          height: MediaQuery.of(context).size.height*0.1,
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(Radius.circular(40)),
              boxShadow: [
                BoxShadow(
                    color:Colors.grey[500],
                    offset: Offset(5.0,5.0),
                    blurRadius: 15.0,
                    spreadRadius: 1.0
                ),
                BoxShadow(
                    color:Colors.white,
                    offset: Offset(-5.0,-5.0),
                    blurRadius: 15.0,
                    spreadRadius: 1.0
                )
              ]
          ),
        ),
      ),
    );
  }
}
