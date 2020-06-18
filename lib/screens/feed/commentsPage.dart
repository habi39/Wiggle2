import 'package:Wiggle2/games/smashbros/main.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/screens/wrapper/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'feed.dart';

class CommentsPage extends StatefulWidget {
  final String description;
  final Wiggle wiggle;

  CommentsPage({this.description, this.wiggle});
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("C O M M E N T S",
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100)),
        leading: IconButton(
          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
            icon: Icon(LineAwesomeIcons.home),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  FadeRoute(page: Wrapper()), ModalRoute.withName('Wrapper'));
            }),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15, top: 15),
        child: Container(
          child: Text(
            '${widget.description}',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
    // RefreshIndicator(
    //     child: createTimeLine(), onRefresh: () => retrieveTimeline()));
  }
}
