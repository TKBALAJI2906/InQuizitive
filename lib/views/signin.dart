import 'dart:ui';
import 'package:inquizitive/helper/functions.dart';
import 'package:inquizitive/home.dart';
import 'package:inquizitive/services/auth.dart';
import 'package:inquizitive/views/forgotPassword.dart';
import 'package:inquizitive/views/signup.dart';
import 'package:flutter/material.dart';
import 'package:inquizitive/widgets/BaseButton.dart';
import 'package:inquizitive/widgets/appBar.dart';
import 'package:inquizitive/widgets/drawer.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  AuthService _authService = new AuthService();

  bool _isLoading = false;

  signIn() async {
    if(_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      await _authService.signInEmailAndPass(_email, _password).then((user) async {
        if (user != null) {
          setState(() {
            _isLoading = false;
          });

                Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => HomeScreen()
            ));


        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _key = GlobalKey();

    return Scaffold(
      appBar: customAppBar(_key, profileNeeded: false),
      body: _isLoading ? Container(
        child: Center(
            child: CircularProgressIndicator()
        ),
      ): Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: <Widget>[
                Spacer(),
                TextFormField(
                  validator: (val){return  val.isEmpty ? "Enter Email ID" : null;},
                  decoration: InputDecoration(
                    hintText: "Email",
                  ),
                  onChanged: (val){
                    _email = val;
                  },
                ),
                SizedBox(height: 6),
                TextFormField(
                  obscureText: true,
                  validator: (val){return  val.isEmpty ? "Enter password" : null;},
                  decoration: InputDecoration(
                    hintText: "Password",
                  ),
                  onChanged: (val){
                    _password = val;
                  },
                ),
                SizedBox(height: 14,),
                GestureDetector(
                  onTap: (){
                    signIn();
                  },
                  child: baseColorButton(context,"Sign In"),
                ),
                SizedBox(height: 18,),
                GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => ForgotPassword()
                      ));
                    },
                    child: Text("Forgot Password", style: TextStyle(fontSize: 15.5),)
                ),
                SizedBox(height: 18,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don't have an account? ", style: TextStyle(fontSize: 15.5),),
                    GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) => SignUp()
                          ));
                        },
                        child: Text("Sign Up", style: TextStyle(fontSize: 15.5,decoration: TextDecoration.underline),))
                  ],
                ),
                SizedBox(height: 80,)
              ],
            ),
          )
      ),
    );
  }
}

