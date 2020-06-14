import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Wiggle2/games/smashbros/smash_engine/screen_util.dart';
import 'package:Wiggle2/games/smashbros/menus/menu.dart';
import 'package:Wiggle2/screens/home/home.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.setScreenOrientation("landscape");
    //ScreenUtil.hideStatusBar();
    ScreenUtil.init(context, screenOrientation: "landscape");
    return MaterialApp(
      theme: ThemeData(fontFamily: 'pixelart'),
      home: Scaffold(
        body: WillPopScope(
          onWillPop: () => Future.value(false),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, FadeRoute(page: MenuPage())
                  /*FadeRoute(
                    page: Game(
                      playerId: 0,
                      mapId: 1,
                      side: GameAssetsFactory.LEFT_SIDE,
                      multiplayer: false,
                    )
                  )*/
                  );
            },
            child: Container(
              height: ScreenUtil.screenHeight,
              width: ScreenUtil.screenWidth,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/menus/homepage.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(-0.97, -0.98),
                    child: Text("V_1.0",
                        style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                  Align(
                    alignment: Alignment(0, -0.89),
                    child: Title(),
                  ),
                  Align(
                    alignment: Alignment(-0.17, 0),
                    child: KickRSanta(),
                  ),
                  Align(
                    alignment: Alignment(0.17, 0),
                    child: KickGSanta(),
                  ),
                  Align(
                    alignment: Alignment(0, 0.7),
                    child: MyBlinkingButton(),
                  ),
                  Align(
                      alignment: Alignment(0.4, 0.7),
                      child: Container(
                        height: ScreenUtil.unitHeight * 8,
                        width: ScreenUtil.unitWidth * 5,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/menus/return.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              FadeRoute(page: Home()),
                              ModalRoute.withName('Home'),
                            );
                          },
                          child: null,
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.unitHeight * 18,
      width: ScreenUtil.unitWidth * 60,
      child: FittedBox(
        child: Image.asset('assets/images/menus/santa_clash.png'),
        fit: BoxFit.fill,
      ),
    );
  }
}

class MyBlinkingButton extends StatefulWidget {
  @override
  _MyBlinkingButtonState createState() => _MyBlinkingButtonState();
}

class _MyBlinkingButtonState extends State<MyBlinkingButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  @override
  void initState() {
    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        height: ScreenUtil.unitHeight * 10,
        width: ScreenUtil.unitWidth * 30,
        child: Image.asset('assets/images/menus/touch-screen.png'),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class KickRSanta extends StatefulWidget {
  @override
  _KickRSantaState createState() => _KickRSantaState();
}

class _KickRSantaState extends State<KickRSanta> with TickerProviderStateMixin {
  AnimationController _idleFrame;
  @override
  void initState() {
    _idleFrame = AnimationController(
      value: 0,
      lowerBound: 0,
      upperBound: 23,
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _idleFrame.repeat();
    super.initState();
  }

  Widget frameNeeded(AnimationController frameNbr) {
    if (frameNbr.value >= 0 && frameNbr.value < 1) {
      return Image.asset(
          'assets/images/fighters/red_santaclaus/smash_attack_r_1.png');
    } else if (frameNbr.value >= 1 && frameNbr.value < 2) {
      return Image.asset(
          'assets/images/fighters/red_santaclaus/smash_attack_r_2.png');
    } else if (frameNbr.value >= 2 && frameNbr.value < 3) {
      return Image.asset(
          'assets/images/fighters/red_santaclaus/smash_attack_r_3.png');
    } else if (frameNbr.value >= 3 && frameNbr.value < 4) {
      return Image.asset(
          'assets/images/fighters/red_santaclaus/smash_attack_r_4.png');
    } else if (frameNbr.value >= 4 && frameNbr.value < 5) {
      return Image.asset(
          'assets/images/fighters/red_santaclaus/smash_attack_r_5.png');
    } else if (frameNbr.value >= 5 && frameNbr.value < 6) {
      return Image.asset(
          'assets/images/fighters/red_santaclaus/smash_attack_r_6.png');
    } else if (frameNbr.value >= 6 && frameNbr.value < 7) {
      return Image.asset(
          'assets/images/fighters/red_santaclaus/smash_attack_r_7.png');
    } else if (frameNbr.value >= 7 && frameNbr.value < 8) {
      return Image.asset(
          'assets/images/fighters/red_santaclaus/smash_attack_r_8.png');
    } else if (frameNbr.value >= 8 && frameNbr.value < 9) {
      return Image.asset(
          'assets/images/fighters/red_santaclaus/smash_attack_r_9.png');
    } else if (frameNbr.value >= 17 && frameNbr.value < 18) {
      return Image.asset('assets/images/fighters/red_santaclaus/stun_r_1.png');
    } else if (frameNbr.value >= 18 && frameNbr.value < 19) {
      return Image.asset('assets/images/fighters/red_santaclaus/stun_r_2.png');
    } else if (frameNbr.value >= 19 && frameNbr.value < 20) {
      return Image.asset('assets/images/fighters/red_santaclaus/stun_r_3.png');
    } else if (frameNbr.value >= 20 && frameNbr.value < 21) {
      return Image.asset('assets/images/fighters/red_santaclaus/stun_r_4.png');
    } else {
      return Image.asset('assets/images/fighters/red_santaclaus/idle_r_1.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.unitHeight * 50,
      width: ScreenUtil.unitWidth * 20,
      child: FittedBox(
        child: AnimatedBuilder(
          animation: _idleFrame,
          builder: (context, child) {
            return frameNeeded(_idleFrame);
          },
          child:
              Image.asset('assets/images/fighters/red_santaclaus/idle_r_1.png'),
        ),
        fit: BoxFit.fill,
      ),
    );
  }

  @override
  void dispose() {
    _idleFrame.dispose();
    super.dispose();
  }
}

class KickGSanta extends StatefulWidget {
  @override
  _KickGSantaState createState() => _KickGSantaState();
}

class _KickGSantaState extends State<KickGSanta> with TickerProviderStateMixin {
  AnimationController _idleFrame;
  @override
  void initState() {
    _idleFrame = AnimationController(
      value: 0,
      lowerBound: 0,
      upperBound: 23,
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _idleFrame.repeat();
    super.initState();
  }

  Widget frameNeeded(AnimationController frameNbr) {
    if (frameNbr.value >= 5 && frameNbr.value < 6) {
      return Image.asset(
          'assets/images/fighters/green_santaclaus/stun_l_1.png');
    } else if (frameNbr.value >= 6 && frameNbr.value < 7) {
      return Image.asset(
          'assets/images/fighters/green_santaclaus/stun_l_2.png');
    } else if (frameNbr.value >= 7 && frameNbr.value < 8) {
      return Image.asset(
          'assets/images/fighters/green_santaclaus/stun_l_3.png');
    } else if (frameNbr.value >= 8 && frameNbr.value < 9) {
      return Image.asset(
          'assets/images/fighters/green_santaclaus/stun_l_4.png');
    } else if (frameNbr.value >= 12 && frameNbr.value < 13) {
      return Image.asset(
          'assets/images/fighters/green_santaclaus/smash_attack_l_1.png');
    } else if (frameNbr.value >= 13 && frameNbr.value < 14) {
      return Image.asset(
          'assets/images/fighters/green_santaclaus/smash_attack_l_2.png');
    } else if (frameNbr.value >= 14 && frameNbr.value < 15) {
      return Image.asset(
          'assets/images/fighters/green_santaclaus/smash_attack_l_3.png');
    } else if (frameNbr.value >= 15 && frameNbr.value < 16) {
      return Image.asset(
          'assets/images/fighters/green_santaclaus/smash_attack_l_4.png');
    } else if (frameNbr.value >= 16 && frameNbr.value < 17) {
      return Image.asset(
          'assets/images/fighters/green_santaclaus/smash_attack_l_5.png');
    } else if (frameNbr.value >= 17 && frameNbr.value < 18) {
      return Image.asset(
          'assets/images/fighters/green_santaclaus/smash_attack_l_6.png');
    } else if (frameNbr.value >= 18 && frameNbr.value < 19) {
      return Image.asset(
          'assets/images/fighters/green_santaclaus/smash_attack_l_7.png');
    } else if (frameNbr.value >= 19 && frameNbr.value < 20) {
      return Image.asset(
          'assets/images/fighters/green_santaclaus/smash_attack_l_8.png');
    } else if (frameNbr.value >= 20 && frameNbr.value < 21) {
      return Image.asset(
          'assets/images/fighters/green_santaclaus/smash_attack_l_9.png');
    } else {
      return Image.asset(
          'assets/images/fighters/green_santaclaus/idle_l_1.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.unitHeight * 50,
      width: ScreenUtil.unitWidth * 20,
      child: FittedBox(
        child: AnimatedBuilder(
          animation: _idleFrame,
          builder: (context, child) {
            return frameNeeded(_idleFrame);
          },
          child: Image.asset(
              'assets/images/fighters/green_santaclaus/idle_l_1.png'),
        ),
        fit: BoxFit.fill,
      ),
    );
  }

  @override
  void dispose() {
    _idleFrame.dispose();
    super.dispose();
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
