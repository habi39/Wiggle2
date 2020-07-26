import 'package:Wiggle2/screens/wrapper/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'compatibilityIntroPage.dart';
import 'compatibilityStatus.dart';
import 'package:Wiggle2/shared/constants.dart';

class CompatibilityStart extends StatefulWidget {
  final friendAnon;
  final Wiggle wiggle;
  final List<Wiggle> wiggles;
  final UserData userData;
  CompatibilityStart(
      {this.friendAnon, this.userData, this.wiggles, this.wiggle});

  @override
  _CompatibilityStartState createState() => _CompatibilityStartState();
}

class _CompatibilityStartState extends State<CompatibilityStart> {
  DatabaseService databaseserver = new DatabaseService();
  String toggle;
  bool requested = false;

  saveReceivercloudforrequest(userData) async {
    QuerySnapshot query = await DatabaseService(uid: widget.wiggle.id)
        .getReceivertoken(widget.wiggle.email);
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(LineAwesomeIcons.home),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  FadeRoute(page: Wrapper()), ModalRoute.withName('Wrapper'));
            }),
        title: Text("C O M P A T I B I L I T Y",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 55,
            child: SizedBox(
              child:
                  Image.asset('assets/images/compatible.png', fit: BoxFit.fill),
            ),
          ),
          SizedBox(height: 50),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      )),
                  child: FlatButton(
                    child: Text('Results'),
                    onPressed: () {
                      sendrequest(widget.userData);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CompatibilityStatus(
                            friendAnon: widget.friendAnon,
                            wiggle: widget.wiggle,
                            userData: widget.userData,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      )),
                  child: FlatButton(
                    child: Text('Play'),
                    onPressed: () {
                      sendrequest(widget.userData);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CompatibilityIntroPage(
                            widget.friendAnon,
                            widget.wiggle,
                            widget.userData,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
