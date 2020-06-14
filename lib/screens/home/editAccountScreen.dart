import 'package:flutter/material.dart';
import 'package:Wiggle2/services/auth.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/models/widget.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/shared/loading.dart';
import 'package:provider/provider.dart';

class EditAccount extends StatefulWidget {
  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String oldpassword = '';
  String newpassword = '';
  String confirmpassword = '';
  AuthService _auth = AuthService();
  bool loading = false;

  bool checkCurrentPasswordValid = true;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return loading
        ? Loading()
        : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blueGrey,
                title: Text("Change Password",
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ),
              body: StreamBuilder<UserData>(
                  stream: DatabaseService(uid: user.uid).userData,
                  builder: (context, snapshot) {
                    UserData userData = snapshot.data;
                    return GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Scaffold(
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
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.lock,
                                              color: Colors.cyan,
                                            ),
                                            SizedBox(width: 3),
                                            Expanded(
                                              child: TextFormField(
                                                  obscureText: true,
                                                  validator: (val) {
                                                    return checkCurrentPasswordValid
                                                        ? null
                                                        : 'Password is incorrect';
                                                  },
                                                  onChanged: (val) {
                                                    setState(() =>
                                                        oldpassword = val);
                                                  },
                                                  style: TextStyle(
                                                      color: Colors.cyan),
                                                  decoration:
                                                      textFieldInputDecoration(
                                                          ' Old Password')),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.lock,
                                              color: Colors.cyan,
                                            ),
                                            SizedBox(width: 3),
                                            Expanded(
                                              child: TextFormField(
                                                obscureText: true,
                                                validator: (val) {
                                                  return val.isEmpty ||
                                                          val.length <= 6
                                                      ? 'Please provide a valid password'
                                                      : null;
                                                },
                                                onChanged: (val) {
                                                  setState(
                                                      () => newpassword = val);
                                                },
                                                style: TextStyle(
                                                    color: Colors.cyan),
                                                decoration:
                                                    textFieldInputDecoration(
                                                        ' New Password'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.lock,
                                              color: Colors.cyan,
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                obscureText: true,
                                                validator: (val) {
                                                  return newpassword == val
                                                      ? null
                                                      : 'Password does not match!';
                                                },
                                                onChanged: (val) {
                                                  setState(() =>
                                                      confirmpassword = val);
                                                },
                                                style: TextStyle(
                                                    color: Colors.cyan),
                                                decoration:
                                                    textFieldInputDecoration(
                                                        ' Confirm Password'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 18),
                                        GestureDetector(
                                          onTap: () async {
                                            checkCurrentPasswordValid =
                                                await _auth.validatePassword(
                                                    oldpassword);

                                            if (_formKey.currentState
                                                .validate()) {
                                              setState(() {
                                                loading = false;
                                              });
                                              _auth.updatePassword(newpassword);

                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                color: Colors.blueGrey),
                                            child: Text('Confirm new password',
                                                style: simpleTextStyle()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          );
  }
}
