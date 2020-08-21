import 'package:flutter/material.dart';
import 'package:inquizitive/helper/functions.dart';
import 'package:inquizitive/home.dart';
import 'package:inquizitive/services/auth.dart';
import 'package:inquizitive/views/signin.dart';
import 'package:inquizitive/widgets/BaseButton.dart';
import 'package:inquizitive/widgets/appBar.dart';
import 'package:inquizitive/widgets/drawer.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String _name,_email, _password;
  AuthService _authService = new AuthService();
  bool _isLoading = false;


  signUp() async {
    if(_formKey.currentState.validate()){
      setState(() {
        _isLoading = true;
      });

      await _authService.signUpEmailAndPass(_email, _password, _name ).then((value) {
        if(value != null){
          HelperFunctions.saveUserLoggedInDetails(isLoggedIn: true, mail: _email, name: _name);
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
    return  Scaffold(
      appBar:customAppBar(_key, profileNeeded: false),
      body: _isLoading ? Container(
        child: Center(
          child: Center(
              child: CircularProgressIndicator()
          ),
        ),
      ): Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: <Widget>[
                Spacer(),
                TextFormField(
                  validator: (val){
                    return  val.isEmpty ? "Enter your name" : val.contains('.') ? "Username must not contain dots. Use spaces instead" : null;
                  },
                  decoration: InputDecoration(
                    hintText: "Name",
                  ),
                  onChanged: (val){
                    _name = val;
                  },
                ),
                SizedBox(height: 6),
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
                    signUp();
                  },
                  child: baseColorButton(context,"Sign Up"),
                ),
                SizedBox(height: 18,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account? ", style: TextStyle(fontSize: 15.5),),
                    GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) => SignIn()
                          ));
                        },
                        child: Text("Sign In", style: TextStyle(fontSize: 15.5,decoration: TextDecoration.underline),)
                    )
                  ],
                ),
                SizedBox(height: 69,)
              ],
            ),
          )
      ),
    );
  }
}