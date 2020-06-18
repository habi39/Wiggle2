import 'package:Wiggle2/screens/feed/feed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wiggle2/games/flappybird/components/game.dart';
import 'package:Wiggle2/games/smashbros/main.dart';

import 'package:Wiggle2/games/tictactoe/tictactoehome.dart';
import 'package:Wiggle2/games/who/whoWiggle.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/services/database.dart';

class Gameslist extends StatefulWidget {
  @override
  _GameslistState createState() => _GameslistState();
}

class _GameslistState extends State<Gameslist> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wiggles = Provider.of<List<Wiggle>>(context) ?? [];
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              title: Text("G A M E S",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100)),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WhoWiggle(userData: userData, wiggles: wiggles),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: RaisedButton(
                            color: Colors.red,
                            child: Text('Tictactoe'),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Tictactoehome(userData, wiggles),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                  // child: RaisedButton(
                                  //   child: Text('Feed'),
                                  //   color: Colors.purple,
                                  //   onPressed: () {
                                  //     Navigator.of(context).pushAndRemoveUntil(
                                  //       FadeRoute(
                                  //         page: Feed(
                                  //             userData: userData,
                                  //             wiggles: wiggles),
                                  //       ),
                                  //       ModalRoute.withName('Feed'),
                                  //     );
                                  //   },
                                  // ),
                                  ),
                            ),
                            Expanded(
                              child: Container(
                                child: RaisedButton(
                                  child: Text('Flappy Bird Multiplayer',
                                      style: TextStyle(color: Colors.white)),
                                  color: Colors.black,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => BirdGame().widget,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: RaisedButton(
                                  child: Text('SantaSmash',
                                      style: TextStyle(color: Colors.white)),
                                  color: Colors.grey,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => HomePage(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
