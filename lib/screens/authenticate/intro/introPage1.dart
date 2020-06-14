import 'dart:math';

import 'package:flutter/material.dart';
import 'package:Wiggle2/services/database.dart';
import '../../../models/user.dart';
import '../../../models/wiggle.dart';
import 'introPage2.dart';

class IntroPage1 extends StatefulWidget {
  UserData userData;
  List<Wiggle> wiggles;

  IntroPage1({this.userData, this.wiggles});
  @override
  _IntroPage1State createState() => _IntroPage1State();
}

class _IntroPage1State extends State<IntroPage1> {
  int index;
  Wiggle chosenWiggle;
  @override
  void initState() {
    index = Random().nextInt(widget.wiggles.length);

    chosenWiggle = widget.wiggles[index];
    while (chosenWiggle.name == widget.userData.name) {
      index = Random().nextInt(widget.wiggles.length);
      chosenWiggle = widget.wiggles[index];
    }
    print(chosenWiggle.name);
    super.initState();
  }

  getChatRoomID(String a, String b) {
    print(a);
    print(b);
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.95,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1,
                  left: 30,
                  right: 30),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Who will you meet today?",
                    style: TextStyle(
                        fontFamily: "Proxima-Nova-Extrabold",
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  FlatButton(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: 500,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          'Click to find out!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      DatabaseService().uploadBondData(
                        userData: widget.userData,
                        myAnon: true,
                        wiggle: chosenWiggle,
                        friendAnon: true,
                        chatRoomID: getChatRoomID(
                            widget.userData.nickname, chosenWiggle.nickname),
                      );
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => IntroPage2(
                            chosenWiggle: chosenWiggle,
                            userData: widget.userData,
                            wiggles: widget.wiggles,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
