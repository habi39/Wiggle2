import 'package:random_string/random_string.dart';
import 'package:Wiggle2/games/compatibility.dart/compatibility.dart';
import 'package:Wiggle2/games/compatibility.dart/compatibilityIntroPage.dart';
import 'package:Wiggle2/games/compatibility.dart/compatibilityStatus.dart';
import 'package:Wiggle2/games/tictactoe/game2.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../games/trivia/trivia.dart';

class WiggleTile extends StatefulWidget {
  final Wiggle wiggle;
  final List<Wiggle> wiggles;
  final UserData userData;
  WiggleTile({this.userData, this.wiggles, this.wiggle});
  @override
  _WiggleTileState createState() => _WiggleTileState();
}

class _WiggleTileState extends State<WiggleTile> {
  DatabaseService databaseserver = new DatabaseService();
  String toggle;
  bool requested = false;

  saveReceivercloudforrequest(userData) async {
    QuerySnapshot query =
        await DatabaseService(uid: widget.wiggle.id).getReceivertoken(widget.wiggle.email);
    String val = query.documents[0].data['token'].toString();
    databaseserver.cloudReference.document().setData({
      'type': 'compatibility',
      'ownerID': widget.wiggle.email,
      'ownerName': widget.wiggle.name,
      'timestamp': DateTime.now(),
      'userDp': userData.dp,
      'userID': userData.name,
      'token': val,
    });
  }

  sendrequest(UserData userdata) {
    setState(() {
      requested = true;
      toggle = 'join';
    });
    saveReceivercloudforrequest(widget.userData);
    String y = randomNumeric(100);
    databaseserver.feedReference
        .document(widget.wiggle.email)
        .collection('feed')
        .document(y)
        .setData({
      'type': 'compatibility',
      'ownerID': widget.wiggle.email,
      'ownerName': widget.wiggle.name,
      'timestamp': DateTime.now(),
      'userDp': widget.userData.dp,
      'userID': widget.userData.name,
      'status': 'sent',
      'senderEmail': widget.userData.email,
      'notifID': y
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5, right: 20),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30)),
                child: ClipOval(
                  child: SizedBox(
                    width: 180,
                    height: 180,
                    child: Image.network(
                          widget.wiggle.dp,
                          fit: BoxFit.fill,
                        ) ??
                        Image.asset('assets/images/profile1.png',
                            fit: BoxFit.fill),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                widget.wiggle.name,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              RaisedButton(
                child: Text('View'),
                onPressed: () {
                  sendrequest(widget.userData);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CompatibilityStatus(
                        wiggle: widget.wiggle,
                        userData: widget.userData,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 2),
              // RaisedButton(
              //   //send invite
              //   child: Text('Play'),
              //   onPressed: () {
              //     sendrequest(widget.userData);
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) => CompatibilityIntroPage(

              //           widget.wiggle,
              //           widget.userData,
              //         ),
              //       ),
              //     );
              //   },
              // ),
            ],
          )
        ],
      ),
    );
  }
}
