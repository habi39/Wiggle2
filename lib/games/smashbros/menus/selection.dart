import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Wiggle2/games/smashbros/smash_engine/screen_util.dart';
import 'package:Wiggle2/games/smashbros/main.dart';
import 'package:Wiggle2/games/smashbros/menus/menu.dart';
import 'package:Wiggle2/games/smashbros/menus/host.dart';

class SelectionChara extends StatelessWidget {
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
              image: AssetImage('assets/images/menus/selectback.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(children: [
            Align(
              alignment: Alignment(-1, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    FadeRoute(page: SelectionArena(playerId: 0)),
                  );
                },
                child: Container(
                  width: ScreenUtil.screenWidth / 2,
                  height: ScreenUtil.screenHeight,
                  child: Stack(children: [
                    Align(
                      alignment: Alignment(0, 1),
                      child: IdleRSanta(),
                    ),
                    Align(
                        alignment: Alignment(0, -0.87),
                        child: Container(
                          width: ScreenUtil.unitWidth * 22,
                          height: ScreenUtil.unitHeight * 13,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/menus/rstitle.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        )),
                  ]),
                ),
              ),
            ),
            Align(
              alignment: Alignment(1, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    FadeRoute(page: SelectionArena(playerId: 1)),
                  );
                },
                child: Container(
                  width: ScreenUtil.screenWidth / 2,
                  height: ScreenUtil.screenHeight,
                  child: Stack(children: [
                    Align(
                      alignment: Alignment(0, 1),
                      child: IdleGSanta(),
                    ),
                    Align(
                        alignment: Alignment(0, -0.87),
                        child: Container(
                          width: ScreenUtil.unitWidth * 22,
                          height: ScreenUtil.unitHeight * 13,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/menus/gstitle.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        )),
                  ]),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0),
              child: Container(
                width: ScreenUtil.unitWidth * 15,
                height: ScreenUtil.screenHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/menus/ligne.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(-0.01, -0.9),
              child: Container(
                width: ScreenUtil.unitWidth * 20,
                height: ScreenUtil.unitHeight * 15,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/menus/vs.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(-0.01, 1),
              child: ReturnButton(),
            ),
          ]),
        ),
      ),
    );
  }
}

class SelectionArena extends StatelessWidget {
  final int playerId; // 0=red Santa 1=green Santa

  SelectionArena({@required this.playerId});
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
              image: AssetImage('assets/images/menus/selectback.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(children: [
            Align(
              alignment: Alignment(-1, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    FadeRoute(
                        page: Host(
                      mapId: 1,
                      playerId: playerId,
                    )),
                  );
                },
                child: Container(
                  width: ScreenUtil.screenWidth / 2,
                  height: 2 / 3 * ScreenUtil.screenHeight,
                  child: Stack(children: [
                    Align(
                      alignment: Alignment(0, 0.5),
                      child: Container(
                        width: ScreenUtil.unitWidth * 30,
                        height: ScreenUtil.unitHeight * 40,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/menus/snowlandim.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment(0, -0.8),
                        child: Container(
                          width: ScreenUtil.unitWidth * 22,
                          height: ScreenUtil.unitHeight * 13,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/menus/snowland.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        )),
                  ]),
                ),
              ),
            ),
            Align(
              alignment: Alignment(1, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    FadeRoute(
                        page: Host(
                      mapId: 2,
                      playerId: playerId,
                    )),
                  );
                },
                child: Container(
                  width: ScreenUtil.screenWidth / 2,
                  height: 2 / 3 * ScreenUtil.screenHeight,
                  child: Stack(children: [
                    Align(
                      alignment: Alignment(0, 0.5),
                      child: Container(
                        width: ScreenUtil.unitWidth * 30,
                        height: ScreenUtil.unitHeight * 40,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/menus/sunnylandim.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment(0, -0.8),
                        child: Container(
                          width: ScreenUtil.unitWidth * 22,
                          height: ScreenUtil.unitHeight * 15,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/menus/sunnyland.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        )),
                  ]),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0),
              child: Container(
                width: ScreenUtil.unitWidth * 15,
                height: ScreenUtil.screenHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/menus/ligne.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(-0.01, 1),
              child: ReturnButtonToChara(),
            ),
          ]),
        ),
      ),
    );
  }
}

class IdleRSanta extends StatefulWidget {
  @override
  _IdleRSantaState createState() => _IdleRSantaState();
}

class _IdleRSantaState extends State<IdleRSanta> with TickerProviderStateMixin {
  AnimationController _idleFrame;
  @override
  void initState() {
    _idleFrame = AnimationController(
      value: 0,
      lowerBound: 0,
      upperBound: 5,
      duration: Duration(microseconds: 500000),
      vsync: this,
    );
    _idleFrame.repeat();
    super.initState();
  }

  Widget frameNeeded(AnimationController frameNbr) {
    if (frameNbr.value >= 0 && frameNbr.value < 1) {
      return Image.asset('assets/images/fighters/red_santaclaus/idle_r_1.png');
    } else if (frameNbr.value >= 1 && frameNbr.value < 2) {
      return Image.asset('assets/images/fighters/red_santaclaus/idle_r_2.png');
    } else if (frameNbr.value >= 2 && frameNbr.value < 3) {
      return Image.asset('assets/images/fighters/red_santaclaus/idle_r_3.png');
    } else if (frameNbr.value >= 3 && frameNbr.value < 4) {
      return Image.asset('assets/images/fighters/red_santaclaus/idle_r_4.png');
    } else {
      return Image.asset('assets/images/fighters/red_santaclaus/idle_r_5.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.unitHeight * 70,
      width: ScreenUtil.unitWidth * 40,
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

class IdleGSanta extends StatefulWidget {
  @override
  _IdleGSantaState createState() => _IdleGSantaState();
}

class _IdleGSantaState extends State<IdleGSanta> with TickerProviderStateMixin {
  AnimationController _idleFrame;
  @override
  void initState() {
    _idleFrame = AnimationController(
      value: 0,
      lowerBound: 0,
      upperBound: 5,
      duration: Duration(microseconds: 500000),
      vsync: this,
    );
    _idleFrame.repeat();
    super.initState();
  }

  Widget frameNeeded(AnimationController frameNbr) {
    if (frameNbr.value >= 0 && frameNbr.value < 1) {
      return Image.asset(
          'assets/images/fighters/green_santaclaus/idle_l_1.png');
    } else if (frameNbr.value >= 1 && frameNbr.value < 2) {
      return Image.asset(
          'assets/images/fighters/green_santaclaus/idle_l_2.png');
    } else if (frameNbr.value >= 2 && frameNbr.value < 3) {
      return Image.asset(
          'assets/images/fighters/green_santaclaus/idle_l_3.png');
    } else if (frameNbr.value >= 3 && frameNbr.value < 4) {
      return Image.asset(
          'assets/images/fighters/green_santaclaus/idle_l_4.png');
    } else {
      return Image.asset(
          'assets/images/fighters/green_santaclaus/idle_l_5.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.unitHeight * 70,
      width: ScreenUtil.unitWidth * 40,
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
            FadeRoute(page: SecondMenuPage()),
          ); // switch to game page
        },
        child: null,
      ),
    );
  }
}

class ReturnButtonToChara extends StatelessWidget {
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
            FadeRoute(page: SelectionChara()),
          ); // switch to game page
        },
        child: null,
      ),
    );
  }
}
