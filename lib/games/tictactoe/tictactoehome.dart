import 'package:flutter/material.dart';
import 'package:Wiggle2/games/tictactoe/tictactoe.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/screens/home/wiggle_list.dart';

class Tictactoehome extends StatefulWidget {
  UserData userData;
  List<Wiggle> wiggles;

  Tictactoehome(this.userData, this.wiggles);

  @override
  _TictactoehomeState createState() => _TictactoehomeState();
}

class _TictactoehomeState extends State<Tictactoehome> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('wiggle'),
        elevation: 0.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              child: RaisedButton(
                color: Colors.blue,
                child: Text('Play with Computer'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Tictactoe(widget.userData),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: RaisedButton(
                color: Colors.green,
                child: Text('Multiplayer'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => //Game2()
                          Tictactoe(widget.userData),
                      //WiggleList(widget.userData, widget.wiggles),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
