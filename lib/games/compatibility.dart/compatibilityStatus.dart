import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Wiggle2/shared/loading.dart';

import '../../models/user.dart';
import '../../models/wiggle.dart';
import '../../services/database.dart';

class CompatibilityStatus extends StatefulWidget {
  bool friendAnon;
  Wiggle wiggle;
  UserData userData;

  CompatibilityStatus({this.friendAnon, this.wiggle, this.userData});
  @override
  _CompatibilityStatusState createState() => _CompatibilityStatusState();
}

class _CompatibilityStatusState extends State<CompatibilityStatus> {
  List<String> answer1 = [];
  List<String> answer2 = [];

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

  Stream<QuerySnapshot> myCompatibilityResults;
  Stream<QuerySnapshot> friendCompatibilityResults;
  Stream<QuerySnapshot> compatibilityQuestions;
  List<String> friendAnswer;
  int count = 0;

  Widget compatibilityResultsList() {
    return StreamBuilder(
        stream: compatibilityQuestions,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return snapshot.data.documents.isNotEmpty &&
                    snapshot.data.documents[0].data['questions'].isNotEmpty
                ? StreamBuilder(
                    stream: myCompatibilityResults,
                    builder: (context, snapshot1) {
                      if (snapshot1.data != null) {
                        return snapshot1.data.documents.isNotEmpty &&
                                snapshot1
                                    .data
                                    .documents[0]
                                    .data['${widget.userData.name} answers']
                                    .isNotEmpty
                            ? StreamBuilder(
                                stream: friendCompatibilityResults,
                                builder: (context, snapshot2) {
                                  if (snapshot2.data != null) {
                                    return snapshot2
                                                .data.documents.isNotEmpty &&
                                            snapshot2
                                                .data
                                                .documents[0]
                                                .data[
                                                    '${widget.wiggle.name} answers']
                                                .isNotEmpty
                                        ? ListView.builder(
                                            itemCount: 5,
                                            itemBuilder: (context, index) {
                                              return CompatibilityTile(
                                                friendAnswer: snapshot2.data
                                                                .documents[0].data[
                                                            '${widget.wiggle.name} answers']
                                                        [index] ??
                                                    'not filled',
                                                myAnswer: snapshot1.data
                                                                .documents[0].data[
                                                            '${widget.userData.name} answers']
                                                        [index] ??
                                                    'not filled',
                                                question: snapshot
                                                    .data
                                                    .documents[0]
                                                    .data['questions'][index],
                                              );
                                            })
                                        : Container(
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(30),
                                                child: AutoSizeText(
                                                  widget.friendAnon
                                                      ? "${widget.wiggle.nickname} has not done the quiz"
                                                      : "${widget.wiggle.name} has not done the quiz",
                                                  style: TextStyle(
                                                      fontSize: 40,
                                                      fontWeight:
                                                          FontWeight.w100),
                                                ),
                                              ),
                                            ),
                                          );
                                  } else {
                                    return Loading();
                                  }
                                })
                            : Container(
                                child: Center(
                                  child: Text(
                                    "You have not done the quiz",
                                    style: TextStyle(
                                        fontSize: 40, color: Colors.white),
                                  ),
                                ),
                              );
                      } else {
                        return Loading();
                      }
                    })
                : Container(
                    child: Center(
                      child: Text(
                        "No quiz found",
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ),
                  );
          } else {
            return Loading();
          }
        });
  }

  @override
  void initState() {
    help();
    initialize();
    super.initState();
  }

  initialize() {
    DatabaseService()
        .getMyCompatibilityResults(
      widget.wiggle,
      widget.userData,
      getCompatibilityRoomID(widget.userData.email, widget.wiggle.email),
    )
        .then((val) {
      setState(() {
        myCompatibilityResults = val;
      });
    });
    DatabaseService()
        .getFriendCompatibilityResults(
      widget.wiggle,
      widget.userData,
      getCompatibilityRoomID(widget.userData.email, widget.wiggle.email),
    )
        .then((val) {
      setState(() {
        friendCompatibilityResults = val;
      });
    });
    DatabaseService()
        .getCompatibilityQuestions(
      widget.wiggle,
      widget.userData,
      getCompatibilityRoomID(widget.userData.email, widget.wiggle.email),
    )
        .then((val) {
      setState(() {
        compatibilityQuestions = val;
      });
    });
  }

  Future<int> documentThings() async {
    QuerySnapshot docMyAnswers = await DatabaseService()
        .getDocMyCompatibilityAnswers(widget.wiggle, widget.userData,
            getCompatibilityRoomID(widget.wiggle.email, widget.userData.email));

    QuerySnapshot docFriendAnswers = await DatabaseService()
        .getDocFriendCompatibilityAnswers(widget.wiggle, widget.userData,
            getCompatibilityRoomID(widget.wiggle.email, widget.userData.email));

    for (int i = 0; i < 5; i++) {
      if (answer1.length < 5) {
        answer1.add(docMyAnswers
            .documents[0].data["${widget.userData.name} answers"][i]
            .toString());
        answer2.add(docFriendAnswers
            .documents[0].data["${widget.wiggle.name} answers"][i]
            .toString());

        if (docMyAnswers.documents[0].data["${widget.userData.name} answers"][i]
                .toString() ==
            docFriendAnswers
                .documents[0].data["${widget.wiggle.name} answers"][i]
                .toString()) {
          count++;
        }
      }
    }
    return count;
  }

  int score = 0;
  help() async {
    return await documentThings().then((val) {
      setState(() {
        score = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.blueGrey,
        title: Text(
          "R E S U L T S",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Score: $score',
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),
              ),
            ),
          ),
          compatibilityResultsList(),
          Align(
              alignment: Alignment(0, 0.85),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/menus/return.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      score = 0;
                    });
                    DatabaseService().uploadCompatibiltyAnswers(
                      wiggle: widget.wiggle,
                      userData: widget.userData,
                      compatibilityRoomID: getCompatibilityRoomID(
                          widget.userData.email, widget.wiggle.email),
                      myAnswers: [],
                    );
                    DatabaseService().uploadCompatibiltyQuestions(
                      wiggle: widget.wiggle,
                      userData: widget.userData,
                      compatibilityRoomID: getCompatibilityRoomID(
                          widget.userData.email, widget.wiggle.email),
                      questions: [],
                    );
                    DatabaseService().uploadFriendCompatibiltyAnswers(
                      wiggle: widget.wiggle,
                      userData: widget.userData,
                      compatibilityRoomID: getCompatibilityRoomID(
                          widget.userData.email, widget.wiggle.email),
                      myAnswers: [],
                    );

                    print('pressed');
                  },
                  child: Text(
                    'Reset',
                    style: TextStyle(fontWeight: FontWeight.w100),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

class CompatibilityTile extends StatelessWidget {
  final String question;
  final String myAnswer;
  final String friendAnswer;

  CompatibilityTile({this.question, this.myAnswer, this.friendAnswer});

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
      child: Column(
        children: <Widget>[
          Text(
            question,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  myAnswer,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                Text(
                  friendAnswer,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
