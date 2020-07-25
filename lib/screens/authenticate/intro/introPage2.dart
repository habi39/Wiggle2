import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Wiggle2/screens/home/home.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

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
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            child: Container(
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
                    "Meet a Friend",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 0.92,
                      decoration: widget.chosenWiggle.anonDp == ''
                          ? BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                image: AssetImage('assets/images/profile1.png'),
                              ),
                            )
                          : BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(widget.chosenWiggle.anonDp),
                              ),
                            ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            bottom: MediaQuery.of(context).size.height * 0.1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                              
                                bottomLeft: Radius.circular(25),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFFFF).withOpacity(0.8),
                                ),
                                child: Container(
                                  margin: EdgeInsets.all(22),
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Text(
                                            "${widget.chosenWiggle.nickname}, ${widget.chosenWiggle.gender}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Spacer(),
                                          Icon(LineAwesomeIcons.star_1,color: Color(0xFFFFC107),),
                                          Text('Fame: ' + widget.chosenWiggle.fame.toString(),style:TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),)
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Course: ${widget.chosenWiggle.course}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),SizedBox(
                                        height: 10,
                                      ),
                                      
                                      Text(
                                        "Bio: ${widget.chosenWiggle.anonBio}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
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
              
                          splashColor: Colors.transparent,
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
    );
  }
}
