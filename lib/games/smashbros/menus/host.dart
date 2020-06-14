import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Wiggle2/games/smashbros/game/game_assets.dart';
import 'package:Wiggle2/games/smashbros/game/multiplayer/multiplayer.dart';
import 'package:Wiggle2/games/smashbros/smash_engine/screen_util.dart';
import 'package:Wiggle2/games/smashbros/main.dart';
import 'package:Wiggle2/games/smashbros/game.dart';
import 'package:Wiggle2/games/smashbros/menus/menu.dart';

class Host extends StatefulWidget {
  @override
  _HostState createState() => _HostState();
  final int playerId;
  final int mapId;
  Host({@required this.playerId, @required this.mapId});
}

class _HostState extends State<Host> with TickerProviderStateMixin {
  AnimationController _waitForConnection;
  Animation _animation;
  Multiplayer _multiplayer = Multiplayer();

  @override
  void initState() {
    super.initState();

    _multiplayer.host(); // ask the multiplayer to wait for a connection

    _waitForConnection = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_waitForConnection);
    _animation.addListener(() {
      setState(() {});
    });
    _animation.addStatusListener((animationStatus) async {
      if (animationStatus == AnimationStatus.completed) {
        _waitForConnection.reset();

        if (await _multiplayer.isConnected) {
          _multiplayer.mapId = widget.mapId;
          _multiplayer.firstPlayerId = widget.playerId;

          _multiplayer.start().then((onValue) {
            Navigator.push(
              context,
              FadeRoute(
                  page: Game(
                mapId: widget.mapId,
                playerId: widget.playerId,
                side: GameAssetsFactory.LEFT_SIDE,
                multiplayer: true,
                drawHitboxes: false,
              )),
            );
          });
        } else
          _waitForConnection.forward();
      }
    });

    _waitForConnection.forward();
  }

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
              image: AssetImage('assets/images/menus/joinback.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(children: [
            Align(
              alignment: Alignment(0, -0.6),
              child: Text(
                "Waiting for a player...",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            Align(
              alignment: Alignment(-0.8, 0.1),
              child: Container(
                height: ScreenUtil.unitHeight * 30,
                width: ScreenUtil.unitWidth * 20,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/menus/bluetooth.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.8, 0.1),
              child: Container(
                height: ScreenUtil.unitHeight * 30,
                width: ScreenUtil.unitWidth * 20,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/menus/bluetooth.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.9),
              child: ReturnButton(),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _waitForConnection.dispose();
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
