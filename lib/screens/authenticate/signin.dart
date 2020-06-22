import 'package:flutter/material.dart';
import 'package:Wiggle2/services/auth.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Wiggle2/screens/authenticate/helper.dart';
import 'package:Wiggle2/shared/fadeanimation.dart';
import 'package:Wiggle2/models/widget.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  QuerySnapshot snapshotUserInfo;

  signIn() {
    if (_formKey.currentState.validate()) {
      //save email to sharedPreference
      Helper.saveUserEmailSharedPreference(email);
      //saving userEmail to database
      DatabaseService().getUserByUserEmail(email).then((val) {
        snapshotUserInfo = val;
        Helper.saveUserNameSharedPreference(
            snapshotUserInfo.documents[0].data["name"]);
      });
      //loading
      setState(() {
        loading = true;
      });

      //authenticate with email and password
      dynamic result =
          _auth.signInWithEmailAndPassword(email, password).then((val) {
        //save userDetails to sharedPreference
        if (val == null) {
          setState(() {
            error = 'Could not log in with these crudentials';
            loading = false;
          });
        } else {
          Helper.saveUserLoggedInSharedPreference(true);
        }
      });
    }
  }

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              // backgroundColor: Color.fromRGBO(3, 9, 23, 1),
              body: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 50,
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              FadeAnimation(
                                1.2,
                                Text(
                                  "Wiggle",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.alternate_email,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 3),
                                  Expanded(
                                    child: TextFormField(
                                        validator: (val) => val.isEmpty
                                            ? 'Enter an email'
                                            : null,
                                        //decoration: textInputDecoration.copyWith(
                                        //hintText: 'Email Address'),
                                        onChanged: (val) {
                                          setState(() => email = val);
                                        },
                                        style: simpleTextStyle(),
                                        decoration:
                                            textFieldInputDecoration(' Email')),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 3),
                                  Expanded(
                                    child: TextFormField(
                                        validator: (val) => val.length < 6
                                            ? 'Enter a password with more than 6 characters'
                                            : null,
                                        //decoration:
                                        //textInputDecoration.copyWith(hintText: 'Password'),
                                        obscureText: true,
                                        onChanged: (val) {
                                          setState(() => password = val);
                                        },
                                        style: simpleTextStyle(),
                                        decoration: textFieldInputDecoration(
                                            ' Password')),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        GestureDetector(
                          //CHANGED TO ASYNC
                          onTap: () async {
                            await signIn();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Color(0xFFFFC107)),
                            child: Text(
                              'Sign In',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                        SizedBox(height: 8),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account? ",
                                style: simpleTextStyle()),
                            GestureDetector(
                              onTap: () {
                                widget.toggleView();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text("Register now",
                                    style: TextStyle(
                                        color: Colors.white,
                                        decoration: TextDecoration.underline)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
