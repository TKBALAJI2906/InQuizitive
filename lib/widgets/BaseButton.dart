import 'package:flutter/material.dart';

Widget baseColorButton (BuildContext context, String label,{Color color =  Colors.blue, bool isUpload = false}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(
        color:color,
        borderRadius: BorderRadius.circular(30)
    ),
    alignment: Alignment.center,
    height: MediaQuery.of(context).size.height*0.075,
    width: isUpload ?  MediaQuery.of(context).size.width*0.5 : MediaQuery.of(context).size.width*0.9,
    child: Text(label, style: TextStyle(color: Colors.white, fontSize: 16),),
  );
}

