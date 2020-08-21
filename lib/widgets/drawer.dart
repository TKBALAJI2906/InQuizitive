import 'package:flutter/material.dart';
import 'package:inquizitive/home.dart';
import 'package:inquizitive/profile.dart';
import 'package:inquizitive/services/auth.dart';
import 'package:inquizitive/views/signin.dart';
import 'package:inquizitive/helper/functions.dart';

Widget customDrawer (BuildContext context){

  return Drawer(
    child: Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Column(
                        children: <Widget>[
                          Spacer(),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.account_circle,
                              size: 40.0,
                            ),
                          ),
                          SizedBox(height: 10.0,),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: ListView(
            children: <Widget>[

              ListTile(
                title: Text("Home"),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => HomeScreen()
                  ));
                },
              ),

              ListTile(
                title: Text("Profile"),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ProfilePage()
                  ));
                },
              ),

              ListTile(
                  title: Text("Sign out"),
                  onTap: () async {
                    AuthService _authService = new AuthService();
                    await _authService.signOut().then((value) => {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => SignIn()
                      ))
                    });
                    HelperFunctions.saveUserLoggedInDetails(isLoggedIn: false, name: null, mail: null);
                  }
              ),


            ],
          ),
        )
      ],
    ),
  );
}