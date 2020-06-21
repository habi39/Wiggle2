import 'package:Wiggle2/screens/wrapper/wrapper.dart';
import 'package:Wiggle2/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class FollowersList extends StatefulWidget {
  final UserData userData;
  final Wiggle otherWiggle;
  final List<Wiggle> wiggles;

  FollowersList({this.otherWiggle, this.wiggles, this.userData});
  @override
  _FollowersListState createState() => _FollowersListState();
}

class _FollowersListState extends State<FollowersList> {
  int countTotalFollowers;
  QuerySnapshot allFollowers;

  getAllFollowers() async {
    QuerySnapshot querySnapshot = await DatabaseService()
        .followersReference
        .document(widget.userData != null
            ? widget.userData.email
            : widget.otherWiggle.email)
        .collection('userFollowers')
        .getDocuments();
    if (this.mounted) {
      setState(() {
        allFollowers = querySnapshot;
        countTotalFollowers = querySnapshot.documents.length;
      });
    }
  }

  Widget followersList({List<Wiggle> wiggles}) {
    Wiggle currentWiggle;
    return allFollowers != null
        ? ListView.builder(
            itemCount: countTotalFollowers,
            itemBuilder: (context, index) {
              String name =
                  allFollowers.documents[index].data['name'].toString();
              for (int i = 0; i < wiggles.length; i++) {
                if (wiggles[i].name == name) {
                  currentWiggle = wiggles[i];
                }
              }
              return followersTile(currentWiggle);
            })
        : Container();
  }

  Widget followersTile(Wiggle wiggle) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5, right: 20),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30)),
                child: ClipOval(
                  child: new SizedBox(
                    width: 180,
                    height: 180,
                    child: Image.network(
                          wiggle.dp,
                          fit: BoxFit.fill,
                        ) ??
                        Image.asset('assets/images/profile1.png',
                            fit: BoxFit.fill),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                wiggle.name,
                style: TextStyle(color: Colors.black),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getAllFollowers();
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: Icon(LineAwesomeIcons.home),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      FadeRoute(page: Wrapper()),
                      ModalRoute.withName('Wrapper'),
                    );
                  },
                ),
          title: Text(
            "F O L L O W E R S",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w100),
          ),
          elevation: 0.0,
        ),
        body: followersList(wiggles: widget.wiggles));
  }
}
