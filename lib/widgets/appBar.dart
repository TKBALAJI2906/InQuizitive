import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customAppBar(GlobalKey<ScaffoldState> globalKey, {bool profileNeeded  = true, List<Widget> actions}) {
  return AppBar(
      title: Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 35.0, 18.0, 18.0),
              child: RichText(
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
            ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      brightness: Brightness.light,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: (profileNeeded) ? IconButton(
        color: Colors.blue,
        padding: const EdgeInsets.fromLTRB(18.0, 15.0, 18.0, 18.0),
        alignment: Alignment.center,
        iconSize: 40.0,
        icon: Icon(Icons.menu,),
        onPressed: (){
          globalKey.currentState.openDrawer();
        },
      ) : Container(),
    actions: actions,
  );
}
