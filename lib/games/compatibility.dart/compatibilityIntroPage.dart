import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Wiggle2/games/compatibility.dart/compatibility.dart';
import 'package:Wiggle2/services/database.dart';

import '../../models/user.dart';
import '../../models/wiggle.dart';

class CompatibilityIntroPage extends StatefulWidget {
  bool friendAnon;
  Wiggle wiggle;
  UserData userData;

  CompatibilityIntroPage(this.friendAnon, this.wiggle, this.userData);
  @override
  _CompatibilityIntroPageState createState() => _CompatibilityIntroPageState();
}

class _CompatibilityIntroPageState extends State<CompatibilityIntroPage> {
  List<String> questions = [];

  getCompatibilityRoomID(String a, String b) {
    codeUnit(String a) {
      int count = 0;
      for (int i = 0; i < a.length; i++) {
        count += a.codeUnitAt(i);
      }
      return count;
    }

    if (a.length < b.length) {
      return "$a\_$b";
    } else if (a.length > b.length) {
      return "$b\_$a";
    } else {
      print(codeUnit(a) + codeUnit(b));
      return (codeUnit(a) + codeUnit(b)).toString();
    }
  }

  initalize() async {
    QuerySnapshot query = await DatabaseService().getDocCompatibilityQuestions(
        widget.wiggle,
        widget.userData,
        getCompatibilityRoomID(widget.wiggle.email, widget.userData.email));
    print(query.documents.isEmpty);
    if (query.documents.isNotEmpty) {
      for (int i = 0; i < 5; i++) {
        questions.add(query.documents[0].data['questions'][i].toString());
      }
    }
    print(questions);
  }

  @override
  void initState() {
    initalize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Compatibility Intro Game",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 200,
            width: 300,
            child: Column(
              children: <Widget>[
                AutoSizeText(
                  '10 seconds 5 questions',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 3),
                AutoSizeText(
                  'Questions will be sent to your chosen partner and we will await his/her score. A compatibility score will then be calculated.',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Container(
            alignment: Alignment.center,
            child: RaisedButton(
              color: Colors.amber,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Compatibility(
                      friendAnon: widget.friendAnon,
                      questions: questions,
                      wiggle: widget.wiggle,
                      userData: widget.userData,
                    ),
                  ),
                );
              },
              child: Text(
                'Begin',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
