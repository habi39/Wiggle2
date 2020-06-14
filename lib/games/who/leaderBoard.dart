import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/wiggle.dart';

class LeaderBoard extends StatefulWidget {
  List<Wiggle> wiggles;
  List<DocumentSnapshot> whoNames;

  LeaderBoard({this.whoNames, this.wiggles});
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  DocumentSnapshot topDocumentWiggle;
  Wiggle topWiggle;
  @override
  Widget build(BuildContext context) {
    topDocumentWiggle = widget.whoNames[0];
    for (int i = 0; i < widget.wiggles.length; i++) {
      if (widget.wiggles[i].email == topDocumentWiggle.data['email']) {
        topWiggle = widget.wiggles[i];
      }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("LeaderBoard",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.95,
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.1, left: 30, right: 30),
        decoration: BoxDecoration(color: Colors.black),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Top Wiggle",
              style: TextStyle(
                  fontFamily: "Proxima-Nova-Extrabold",
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.92,
                decoration: BoxDecoration(
                  // color: Colors.black,
                  image: DecorationImage(
                    image: NetworkImage(topWiggle.dp) ??
                        AssetImage('assets/images/profile1.png'),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      bottom: MediaQuery.of(context).size.height * 0.1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            bottomLeft: Radius.circular(25)),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Color(0xFFFFFFF).withOpacity(0.8)),
                          child: Container(
                            margin: EdgeInsets.all(22),
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${topWiggle.name}, 22",
                                  style: TextStyle(
                                      fontFamily: "Proxima-Nova-Extrabold",
                                      fontSize: 22,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${topWiggle.block}",
                                  style: TextStyle(
                                      fontFamily: "ProximaNova-Regular",
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
