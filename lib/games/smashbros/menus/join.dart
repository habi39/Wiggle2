import 'package:flutter/material.dart';
import 'package:Wiggle2/games/smashbros/game/game_assets.dart';
import 'package:Wiggle2/games/smashbros/smash_engine/screen_util.dart';
import 'package:Wiggle2/games/smashbros/main.dart';
import 'package:Wiggle2/games/smashbros/game.dart';
import 'package:Wiggle2/games/smashbros/menus/menu.dart';
import 'package:Wiggle2/games/smashbros/game/multiplayer/multiplayer.dart';
import 'dart:async';

class Join extends StatelessWidget {
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
              alignment: Alignment(0, 0),
              child: Container(
                height: ScreenUtil.unitHeight * 50,
                width: ScreenUtil.unitWidth * 50,
                child: DynamicBlueList(),
              ),
            ),
            Align(
              alignment: Alignment(0, -0.8),
              child: Text(
                "Select the hoster",
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
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    FadeRoute(page: EasterEgg()),
                  );
                },
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
            ),
            Align(
              alignment: Alignment(-0.2, 0.9),
              child: ReturnButton(),
            ),
            Align(
              alignment: Alignment(0.2, 0.9),
              child: RefreshButton(),
            ),
          ]),
        ),
      ),
    );
  }
}

class PreJoin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, screenOrientation: "landscape");
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              FadeRoute(page: Join()),
            );
          },
          child: Container(
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
                  "Warning !\n Don't forget to activate your bluetooth and to pair your device with your opponent before joining a host game",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              Align(
                alignment: Alignment(0.2, 0.6),
                child: Container(
                  height: ScreenUtil.unitHeight * 20,
                  width: ScreenUtil.unitWidth * 15,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/menus/prebluetooth.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(-0.2, 0.6),
                child: Container(
                  height: ScreenUtil.unitHeight * 20,
                  width: ScreenUtil.unitWidth * 15,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/menus/warning.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class EasterEgg extends StatelessWidget {
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
              image: AssetImage('assets/images/menus/eastereggback.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(children: [
            Align(
              alignment: Alignment(0, -0.8),
              child: Text(
                "Well played ! You found the EasterEgg page !",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.15),
              child: ScrollText(),
            ),
            Align(
              alignment: Alignment(0, 0.95),
              child: Container(
                height: ScreenUtil.unitHeight * 20,
                width: ScreenUtil.unitWidth * 15,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/menus/santaeaster.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      FadeRoute(page: Join()),
                    ); // switch to game page
                  },
                  child: null,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class DynamicBlueList extends StatefulWidget {
  @override
  DynamicBlueListState createState() => DynamicBlueListState();
}

class DynamicBlueListState extends State<DynamicBlueList> {
  List<String> blueList = List();
  Multiplayer multiplayer = Multiplayer();

  Future<List<String>> getServerList() async {
    return await multiplayer.getServers();
  }

  @override
  void initState() {
    super.initState();
    getServerList().then((servers) {
      blueList = servers;
      setState(() {});
    });
  }

  connectionDialog(BuildContext context, String name) {
    Widget yesButton = FlatButton(
        child: Text("Yes"),
        onPressed: () async {
          Navigator.of(context).pop();
          bool connected = await multiplayer.join(name);
          if (connected) {
            await multiplayer.start();
            Navigator.of(context).pop();

            // choose the other player
            int playerId;
            if (multiplayer.firstPlayerId == 0)
              playerId = 1;
            else
              playerId = 0;

            Navigator.push(
              context,
              FadeRoute(
                  page: Game(
                mapId: multiplayer.mapId,
                playerId: playerId,
                side: GameAssetsFactory.RIGHT_SIDE,
                multiplayer: true,
                drawHitboxes: false,
              )),
            );
          } else {
            failedDialog(context);
          }
        });

    Widget noButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Connection Info"),
      content: Text("Connection to " + name + " ?"),
      actions: [
        yesButton,
        noButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
      barrierDismissible: false,
    );
  }

  // user defined function
  failedDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Connection Info"),
      content: Text("Connection Failed !"),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(
            blueList[index],
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            connectionDialog(context,
                blueList[index].substring(0, blueList[index].length - 1));
            setState(() {});
          },
        );
      },
      itemCount: blueList.length,
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
            FadeRoute(page: SecondMenuPage()),
          ); // switch to game page
        },
        child: null,
      ),
    );
  }
}

class RefreshButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.unitHeight * 13,
      width: ScreenUtil.unitWidth * 10,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/menus/refresh.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            FadeRoute(page: Join()),
          );
        },
        child: null,
      ),
    );
  }
}

class ScrollText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.unitHeight * 40,
      width: ScreenUtil.unitWidth * 60,
      child: SingleChildScrollView(
        child: Text(
          "To reward you , here is some interesting facts :\n\n"
          "Did you know that the modern Santa Claus was design by Coca-Cola ? "
          "Indeed the modern image of Santa Claus as the jolly man in the red suit was seared into American pop culture in 1931 by the artist Haddon Sundblom "
          "for a Coca-Cola campaign.\n\n"
          "Did you know that one of the developer of this app is half German and half Tunisian which is a pretty rare mix of origin\n\n"
          "Did you know that during the developement of this game one of the developer used a computer that has less power than "
          "your toaster\n\n"
          "Did you know that one of the developer can talk Japanese ? \n はい！ 初めまして ！ お名前はアドリエンです。\nアニメと犬が大好きです。"
          "ジョジョの奇妙な冒険は僕の好きなアニメです。宜しくお願いします！",
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
