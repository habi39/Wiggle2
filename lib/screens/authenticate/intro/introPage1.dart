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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.95,
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1,
                left: 30,
                right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "We found you a friend!",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                FlatButton(
                  highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      height: 500,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        'Click to find out!',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
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
    );
  }
}
