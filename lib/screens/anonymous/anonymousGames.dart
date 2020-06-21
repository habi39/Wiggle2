import 'package:Wiggle2/screens/forum/forum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wiggle2/games/smashbros/main.dart';
import 'package:Wiggle2/games/who/whoWiggle.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/screens/home/wiggle_list.dart';
import 'package:Wiggle2/services/database.dart';

class AnonymousGames extends StatefulWidget {
  @override
  _AnonymousGamesState createState() => _AnonymousGamesState();
}

class _AnonymousGamesState extends State<AnonymousGames> {
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
              title: Text("A N O N Y M O U S   G A M E S",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w100)),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: RaisedButton(
                                  child: Text('SantaSmash',
                                      style: TextStyle(color: Colors.white)),
                                  color: Colors.blue,
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: RaisedButton(
                                  child: Text('Forum',
                                      style: TextStyle(color: Colors.white)),
                                  color: Colors.red,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Forum(),
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
                ),
              ],
            ),
          );
        });
  }
}
