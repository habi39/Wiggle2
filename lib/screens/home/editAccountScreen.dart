import 'package:flutter/material.dart';
import 'package:Wiggle2/services/auth.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/models/widget.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:Wiggle2/shared/constants.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:Wiggle2/screens/home/home.dart';
import 'package:Wiggle2/screens/wrapper/wrapper.dart';
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
                centerTitle: true,
                elevation: 0,
                leading: IconButton(
              icon: Icon(LineAwesomeIcons.home),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    FadeRoute(page: Wrapper()), ModalRoute.withName('Wrapper'));
              }),
    
                title: Text("C H A N G E     P A S S W O R D",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w100)),
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
                                              color: Colors.amber,
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
                                                      color: Colors.amber),
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
                                              color: Colors.amber,
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
                                                    color: Colors.amber),
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
                                              color: Colors.amber,
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
                                                    color: Colors.amber),
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

                                               Navigator.of(context).pushAndRemoveUntil(
                    FadeRoute(page: Wrapper()), ModalRoute.withName('Wrapper'));
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
                                                color: Color(0xFF373737)),
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
