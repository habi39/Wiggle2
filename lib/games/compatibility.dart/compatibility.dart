import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Wiggle2/games/compatibility.dart/compatibilityStatus.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/models/user.dart';

import '../../services/database.dart';
import 'compatibilityCard.dart';

class Compatibility extends StatefulWidget {
  bool friendAnon;
  List<String> questions;
  Wiggle wiggle;
  UserData userData;

  Compatibility({
    this.friendAnon,
    this.questions,
    this.wiggle,
    this.userData,
  });

  @override
  _CompatibilityState createState() => _CompatibilityState();
}

class _CompatibilityState extends State<Compatibility>
    with TickerProviderStateMixin {
  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  int index = 0;

  int i = 0;
  CompatibilityCard currentCompatibilityCard;
  List<int> usedNumbers = [0];
  List<String> questions = [];
  List<String> myAnswers = [];
  Stream<QuerySnapshot> compatibilityResults;
  AnimationController controller;

  List<CompatibilityCard> cards = [
    CompatibilityCard('question', 'answer1', 'answer2'),
    CompatibilityCard(
        'Are you homosexual or homophobic', 'Homosexual', 'Homophobic'),
    CompatibilityCard('Who would you wiggle?', 'Wiggle', 'Wiggle'),
    CompatibilityCard(
        'What do you look for in your SO?', 'Looks', 'Personality'),
    // CompatibilityCard('What do you look for in your SO', 'Boobs', 'Butt'),
    CompatibilityCard('Day?', 'Sunny', 'Rainy'),
    CompatibilityCard('Do you prefer the apple or pear?', 'Apple', 'Pear'),
    CompatibilityCard('Trump or Obama?', 'Trump', 'Obama'),
    CompatibilityCard('Favorite Parent', 'Mummy', 'Daddy'),
    // CompatibilityCard('ds?', 'as', 'sd'),
  ];
  List<int> indexes = [];

  initialize() {
    widget.questions.forEach((element1) {
      cards.forEach((element2) {
        if (element1 == element2.question) {
          indexes.add(cards.indexOf(element2));
        }
      });
    });
    indexes.add(0);
    generateRandomCard();
    print(indexes);
    controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );
    initialize();
    super.initState();
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  generateRandomCard() {
    if (widget.questions.isEmpty) {
      while (usedNumbers.contains(index)) {
        index = Random().nextInt(cards.length);
      }
      usedNumbers.add(index);
    } else {
      index = indexes[i];
      i += 1;
    }

    print(myAnswers);
    print(questions);
    setState(() {
      currentCompatibilityCard = cards[index];
    });

    if (questions.length > 4) {
      print('done');
      print(myAnswers);
      print(questions);

      DatabaseService().createCompatibilityRoom(
          compatibilityRoomID: getCompatibilityRoomID(
              widget.userData.email, widget.wiggle.email),
          player1: widget.userData.name,
          player2: widget.wiggle.name);
      DatabaseService().uploadCompatibiltyAnswers(
        wiggle: widget.wiggle,
        userData: widget.userData,
        compatibilityRoomID:
            getCompatibilityRoomID(widget.userData.email, widget.wiggle.email),
        myAnswers: myAnswers,
      );
      DatabaseService().uploadCompatibiltyQuestions(
        wiggle: widget.wiggle,
        userData: widget.userData,
        compatibilityRoomID:
            getCompatibilityRoomID(widget.userData.email, widget.wiggle.email),
        questions: questions,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CompatibilityStatus(
              friendAnon: widget.friendAnon,
              userData: widget.userData,
              wiggle: widget.wiggle),
        ),
      );
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Q U I Z",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),
        ),
      ),
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.amber,
                    height:
                        controller.value * MediaQuery.of(context).size.height,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Stack(
                              children: <Widget>[
                                Align(
                                  alignment: FractionalOffset.center,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      AutoSizeText(
                                        currentCompatibilityCard.question,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        timerString,
                                        style: TextStyle(
                                            fontSize: 112.0,
                                            color: Colors.white),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                questions.add(
                                                    currentCompatibilityCard
                                                        .question);
                                                myAnswers.add(
                                                    currentCompatibilityCard
                                                        .answer1);

                                                generateRandomCard();
                                              });
                                            },
                                            child: Container(
                                              height: 70,
                                              width: 130,
                                              color: Colors.purple[300],
                                              alignment: Alignment.center,
                                              child: AutoSizeText(
                                                currentCompatibilityCard
                                                    .answer1,
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                questions.add(
                                                    currentCompatibilityCard
                                                        .question);
                                                myAnswers.add(
                                                    currentCompatibilityCard
                                                        .answer2);
                                                generateRandomCard();
                                              });
                                            },
                                            child: Container(
                                              height: 70,
                                              width: 130,
                                              color: Colors.blueAccent,
                                              alignment: Alignment.center,
                                              child: AutoSizeText(
                                                currentCompatibilityCard
                                                    .answer2,
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // AnimatedBuilder(
                      //     animation: widget.controller,
                      //     builder: (context, child) {
                      //       return FloatingActionButton.extended(
                      //         onPressed: () {
                      //           if (widget.controller.isAnimating)
                      //             widget.controller.stop();
                      //           else {
                      //             widget.controller.reverse(
                      //                 from: widget.controller.value == 0.0
                      //                     ? 1.0
                      //                     : widget.controller.value);
                      //           }
                      //         },
                      //         icon: Icon(widget.controller.isAnimating
                      //             ? Icons.pause
                      //             : Icons.play_arrow),
                      //         label: Text(widget.controller.isAnimating
                      //             ? "Pause"
                      //             : "Play"),
                      //       );
                      //     }),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}

// class CustomTimerPainter extends CustomPainter {
//   CustomTimerPainter({
//     this.animation,
//     this.backgroundColor,
//     this.color,
//   }) : super(repaint: animation);

//   final Animation<double> animation;
//   final Color backgroundColor, color;
//   final double pi = 3.1415926535897932;

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = backgroundColor
//       ..strokeWidth = 10.0
//       ..strokeCap = StrokeCap.butt
//       ..style = PaintingStyle.stroke;

//     canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
//     paint.color = color;
//     double progress = (1.0 - animation.value) * 2 * pi;
//     canvas.drawArc(Offset.zero & size, pi * 1.5, -progress, false, paint);
//   }

//   @override
//   bool shouldRepaint(CustomTimerPainter old) {
//     return animation.value != old.animation.value ||
//         color != old.color ||
//         backgroundColor != old.backgroundColor;
//   }
// }
