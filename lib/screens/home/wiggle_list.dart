import 'package:flutter/material.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/screens/home/wiggle_tile.dart';

class WiggleList extends StatefulWidget {
  UserData userData;
  List<Wiggle> wiggles;
  WiggleList(this.userData, this.wiggles);

  @override
  _WiggleListState createState() => _WiggleListState();
}

class _WiggleListState extends State<WiggleList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          "Choose your opponent",
        ),
        elevation: 0.0,
      ),
      body: ListView.builder(
        itemCount: widget.wiggles.length,
        itemBuilder: (context, index) {
          return WiggleTile(
            userData: widget.userData,
            wiggles: widget.wiggles,
            wiggle: widget.wiggles[index],
          );
        },
      ),
    );
  }
}
