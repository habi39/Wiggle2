import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Wiggle2/games/smashbros/smash_engine/screen_util.dart';
import 'package:Wiggle2/games/smashbros/main.dart';
import 'package:Wiggle2/games/smashbros/menus/menu.dart';

class EndScreen extends StatelessWidget {
  static const int VICTORY = 0;
  static const int DEFEAT = 1;
  static const int CONNECTION_LOST = 2;

  final int status;
  EndScreen({@required this.status});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, screenOrientation: "landscape");
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: Container(
            height: ScreenUtil.screenHeight,
            width: ScreenUtil.screenWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/menus/endback.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: endScreenSelector(status, context)),
      ),
    );
  }

  Widget endScreenSelector(int status, context) {
    if (status == VICTORY)
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            FadeRoute(page: MenuPage()),
          );
        },
        child: Container(
          height: ScreenUtil.screenHeight,
          width: ScreenUtil.screenWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/menus/endback.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Align(
            alignment: Alignment(0, -0.1),
            child: Container(
              height: ScreenUtil.unitHeight * 30,
              width: ScreenUtil.unitWidth * 50,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/menus/victory.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      );
    else if (status == DEFEAT)
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            FadeRoute(page: MenuPage()),
          );
        },
        child: Container(
          height: ScreenUtil.screenHeight,
          width: ScreenUtil.screenWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/menus/endback.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Align(
            alignment: Alignment(0, -0.1),
            child: Container(
              height: ScreenUtil.unitHeight * 30,
              width: ScreenUtil.unitWidth * 50,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/menus/defeat.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      );
    else
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            FadeRoute(page: MenuPage()),
          );
        },
        child: Container(
          height: ScreenUtil.screenHeight,
          width: ScreenUtil.screenWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/menus/endback.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Align(
            alignment: Alignment(0, -0.1),
            child: Container(
              height: ScreenUtil.unitHeight * 30,
              width: ScreenUtil.unitWidth * 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/menus/connection_lost.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      );
  }
}

class ReturnButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.unitHeight * 15,
      width: ScreenUtil.unitWidth * 10,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/menus/return.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            FadeRoute(page: MenuPage()),
          ); // switch to game page
        },
        child: null,
      ),
    );
  }
}
