import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Wiggle2/games/smashbros/smash_engine/screen_util.dart';
import 'package:Wiggle2/games/smashbros/main.dart';
import 'package:Wiggle2/games/smashbros/menus/menu.dart';

class Credits extends StatelessWidget {
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
              image: AssetImage('assets/images/menus/creditsfont.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment(0, -0.70),
                child: Stack(children: [
                  Text(
                    "Special Thank You To :",
                    style: TextStyle(
                      fontSize: 40,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6
                        ..color = Colors.blue[900],
                    ),
                  ),
                  Text(
                    "Special Thank You To :",
                    style: TextStyle(
                      fontSize: 40.0,
                      color: Colors.grey[300],
                    ),
                  ),
                ]),
              ),
              Align(
                alignment: Alignment(0, 0),
                child: ScrollCredits(),
              ),
              Align(
                alignment: Alignment(0, 0.65),
                child: ReturnButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScrollCredits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.unitHeight * 40,
      width: ScreenUtil.unitWidth * 60,
      child: SingleChildScrollView(
        child: Text(
          "DEVELOPER :\n \n"
          "Agnello Vasco\n"
          "Chiodo Adrien\n"
          "Testouri Mehdi\n\n"
          "ASSET DRAWER :\n\n"
          "Vnitti\n"
          "BigBuckBunny\n"
          "Max Thorne\n"
          "Ansinuz\n"
          "Srip\n"
          "Freepik\n"
          "TheWiseHedgehog\n"
          "Dusan Pavkovic WARlord\n"
          "Elthen",
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
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
          image: AssetImage('assets/images/menus/returncredit.png'),
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
