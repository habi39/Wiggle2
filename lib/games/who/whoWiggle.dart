import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../models/wiggle.dart';
import '../../services/database.dart';
import '../../services/database.dart';
import 'leaderBoard.dart';

class WhoWiggle extends StatefulWidget {
  UserData userData;
  List<Wiggle> wiggles;

  WhoWiggle({this.userData, this.wiggles});

  @override
  _WhoState createState() => _WhoState();
}

class _WhoState extends State<WhoWiggle> {
  Wiggle wiggle1;
  Wiggle wiggle2;
  int index1;
  int index2;
  int score1;
  int score2;
  String myGender;
  List<DocumentSnapshot> whoNames;

  randomize() async {
    // index = new Random().nextInt(widget.wiggles.length);
    QuerySnapshot query = await DatabaseService().getWho(myGender);
    whoNames = query.documents;
    index1 = new Random().nextInt(query.documents.length);

    String email1 = query.documents[index1].data['email'];
    score1 = query.documents[index1].data['score'];
    for (int i = 0; i < query.documents.length; i++) {
      if (widget.wiggles[i].email == email1) {
        wiggle1 = widget.wiggles[i];
      }
    }

    index2 = new Random().nextInt(query.documents.length);
    while (index1 == index2) {
      index2 = new Random().nextInt(query.documents.length);
    }
    String email2 = query.documents[index2].data['email'];
    score2 = query.documents[index2].data['score'];
    for (int i = 0; i < query.documents.length; i++) {
      if (widget.wiggles[i].email == email2) {
        wiggle2 = widget.wiggles[i];
      }
    }
    print(wiggle1.email);
    print(wiggle2.email);
  }

  @override
  void initState() {
    myGender = widget.userData.gender;
    randomize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Who would you wiggle?",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 300,
                      width: 175,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          width: MediaQuery.of(context).size.width * 0.92,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            image: DecorationImage(
                              image: NetworkImage(wiggle1.dp) ??
                                  AssetImage('assets/images/profile1.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      randomize();
                      DatabaseService().uploadWhoData(
                          email: wiggle1.email,
                          name: wiggle1.name,
                          dp: wiggle1.dp,
                          gender: wiggle1.gender,
                          score: score1 + 1);
                      DatabaseService().uploadWhoData(
                          email: wiggle2.email,
                          name: wiggle2.name,
                          dp: wiggle2.dp,
                          gender: wiggle2.gender,
                          score: score2 - 1);
                    });
                  },
                ),
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 300,
                      width: 175,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          width: MediaQuery.of(context).size.width * 0.92,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            image: DecorationImage(
                              image: NetworkImage(wiggle2.dp) ??
                                  AssetImage('assets/images/profile1.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      randomize();
                      DatabaseService().uploadWhoData(
                          email: wiggle2.email,
                          name: wiggle2.name,
                          dp: wiggle2.dp,
                          gender: wiggle2.gender,
                          score: score2 + 1);
                      DatabaseService().uploadWhoData(
                          email: wiggle1.email,
                          name: wiggle1.name,
                          dp: wiggle1.dp,
                          gender: wiggle1.gender,
                          score: score1 - 1);
                    });
                  },
                )
              ],
            ),
          ),
          SizedBox(height: 30),
          RaisedButton(
            child: Text(
              'LeaderBoard',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      LeaderBoard(wiggles: widget.wiggles, whoNames: whoNames),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
