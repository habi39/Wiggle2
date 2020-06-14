import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Wiggle2/screens/home/home.dart';

import '../../../games/trivia/trivia.dart';
import '../../../models/user.dart';
import '../../../models/wiggle.dart';
import '../../home/chatScreen.dart';

class IntroPage2 extends StatefulWidget {
  UserData userData;
  List<Wiggle> wiggles;
  Wiggle chosenWiggle;

  IntroPage2({this.chosenWiggle, this.userData, this.wiggles});
  @override
  _IntroPage2State createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2> {
  @override
  Widget build(BuildContext context) {
    return widget.chosenWiggle.isAnonymous
        ? Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(color: Colors.white),
              child: Stack(
                children: [
                  GestureDetector(
                    child: Container(
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
                            "Meet a Friend",
                            style: TextStyle(
                                fontFamily: "Proxima-Nova-Extrabold",
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              width: MediaQuery.of(context).size.width * 0.92,
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: 0,
                                    bottom: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(25),
                                          bottomLeft: Radius.circular(25)),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            color: Color(0xFFFFFFF)
                                                .withOpacity(0.8)),
                                        child: Container(
                                          margin: EdgeInsets.all(22),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${widget.chosenWiggle.nickname}, unknown age",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Proxima-Nova-Extrabold",
                                                    fontSize: 22,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "This person is anonymous",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "ProximaNova-Regular",
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.03,
                    left: MediaQuery.of(context).size.width * 0.30,
                    child: FloatingActionButton(
                      heroTag: "cross",
                      onPressed: () {
                        Navigator.of(context).pop(
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                      backgroundColor: Colors.white,
                      elevation: 10,
                      child: Icon(
                        Icons.close,
                        color: Color(0xFFA29FBE),
                        size: 28,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.03,
                    right: MediaQuery.of(context).size.width * 0.30,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => Trivia(
                              widget.chosenWiggle,
                              widget.userData,
                              widget.wiggles,
                            ),
                          ),
                        );
                      },
                      heroTag: "heart",
                      backgroundColor: Colors.white,
                      elevation: 10,
                      child: Icon(
                        FontAwesomeIcons.solidHeart,
                        color: Color(0xFFFF636B),
                        size: 24,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(color: Colors.white),
              child: Stack(
                children: [
                  GestureDetector(
                    // onTap: () {
                    //   Navigator.push(context,
                    //       MaterialPageRoute(builder: (context) => Myprofile()));
                    // },
                    child: Container(
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
                            "Meet a Friend",
                            style: TextStyle(
                                fontFamily: "Proxima-Nova-Extrabold",
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              width: MediaQuery.of(context).size.width * 0.92,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/profile1.png'),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: 0,
                                    bottom: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(25),
                                          bottomLeft: Radius.circular(25)),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            color: Color(0xFFFFFFF)
                                                .withOpacity(0.8)),
                                        child: Container(
                                          margin: EdgeInsets.all(22),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${widget.chosenWiggle.nickname}",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Proxima-Nova-Extrabold",
                                                    fontSize: 22,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "${widget.chosenWiggle.block}, Computer Science",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "ProximaNova-Regular",
                                                    fontSize: 17,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.03,
                    left: MediaQuery.of(context).size.width * 0.30,
                    child: FloatingActionButton(
                      heroTag: "cross",
                      onPressed: () {
                        Navigator.of(context).pop(
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                      backgroundColor: Colors.white,
                      elevation: 10,
                      child: Icon(
                        Icons.close,
                        color: Color(0xFFA29FBE),
                        size: 28,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.03,
                    right: MediaQuery.of(context).size.width * 0.30,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => Trivia(
                              widget.chosenWiggle,
                              widget.userData,
                              widget.wiggles,
                            ),
                          ),
                        );
                      },
                      heroTag: "heart",
                      backgroundColor: Colors.white,
                      elevation: 10,
                      child: Icon(
                        FontAwesomeIcons.solidHeart,
                        color: Color(0xFFFF636B),
                        size: 24,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
