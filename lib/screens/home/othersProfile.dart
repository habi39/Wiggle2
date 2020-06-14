import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/screens/home/editAccountScreen.dart';
import 'package:Wiggle2/screens/home/editProfileScreen.dart';
import 'followersList.dart';
import 'followingList.dart';
import '../../shared/constants.dart';
import '../../models/user.dart';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OthersProfile extends StatefulWidget {
  final Wiggle wiggle;
  final UserData userData;
  final List<Wiggle> wiggles;

  OthersProfile({this.wiggles, this.wiggle, this.userData});

  @override
  _OthersProfileState createState() => _OthersProfileState();
}

class _OthersProfileState extends State<OthersProfile> {
  int countTotalFollowers = 0;
  int countTotalFollowings = 0;
  bool following = false;
  String toggleFollow;
  DatabaseService databaseserver = new DatabaseService();
  bool acceptedrequest = false;
  bool sentrequest = false;

  void initState() {
    getAllFollowers();
    getAllFollowings();
    checkIfSentRequest();
    checkIfAlreadyFollowing();
  }

  getAllFollowings() async {
    QuerySnapshot querySnapshot = await databaseserver.followingReference
        .document(widget.wiggle.email)
        .collection('userFollowing')
        .getDocuments();
    if (this.mounted) {
      setState(() {
        countTotalFollowings = querySnapshot.documents.length;
      });
    }
  }

  checkIfSentRequest() async {
    await databaseserver.feedReference
        .document(widget.wiggle.email)
        .collection('feed')
        .document(widget.userData.email)
        .get()
        .then((value) => {
              print(value.exists),
              if (value.exists)
                {
                  sentrequest = value.exists,
                  databaseserver.followersReference
                      .document(widget.wiggle.email)
                      .collection('userFollowers')
                      .document(widget.userData.email)
                      .get()
                      .then((val) {
                    if (!(val.exists) && value.data['status'] == 'accepted') {
                      if (this.mounted) {
                        setState(() {
                          following = true;
                          sentrequest = true;
                          acceptedrequest = true;
                          toggleFollow = "Unfollow";

                          getAllFollowers();
                          getAllFollowings();
                          checkIfAlreadyFollowing();
                        });
                        controlFollowUser(widget.userData);
                      }
                    }
                  })
                }
            });
  }

  checkIfAlreadyFollowing() async {
    await databaseserver.followersReference
        .document(widget.wiggle.email)
        .collection('userFollowers')
        .document(widget.userData.email)
        .get()
        .then((value) => {
              if (this.mounted)
                {
                  setState(() {
                    if (value.exists) {
                      following = value.exists;
                      sentrequest = value.exists;
                      acceptedrequest = value.exists;
                    }
                  })
                }
            });
  }

  getAllFollowers() async {
    QuerySnapshot querySnapshot = await databaseserver.followersReference
        .document(widget.wiggle.email)
        .collection('userFollowers')
        .getDocuments();
    if (this.mounted) {
      setState(() {
        countTotalFollowers = querySnapshot.documents.length;
      });
    }
  }

  createButton(UserData userData) {
    bool ownProfile = userData.email == widget.wiggle.email;

    sentrequest
        ? acceptedrequest
            ? (toggleFollow = 'Unfollow')
            : (toggleFollow = 'Requested')
        : (toggleFollow = 'Follow');

    if (ownProfile) {
      return Container(
        child: Row(
          children: <Widget>[
            createButtonTitleAndFunction(
                title: 'Edit Profile', performFunction: editUserProfile),
            createButtonTitleAndFunction(
                title: 'Change Password', performFunction: editUserPassword),
          ],
        ),
      );
    } else {
      return createButtonTitle(title: toggleFollow, userData: userData);
    }
  }

  createButtonTitle(
      {String title, Function performFunction, UserData userData}) {
    return Container(
      padding: EdgeInsets.only(top: 1.0),
      child: FlatButton(
        onPressed: () => sentrequest
            ? acceptedrequest
                ? controlUnfollowUser(userData)
                : retractrequest(userData)
            : sendrequest(userData),
        child: Container(
          width: 150.0,
          height: 26.0,
          child: Text(
            title,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
      ),
    );
  }

  //unfollow user
  controlUnfollowUser(UserData userData) {
    databaseserver.followersReference
        .document(widget.wiggle.email)
        .collection('userFollowers')
        .document(userData.email)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
        if (this.mounted) {
          setState(() {
            following = false;
            sentrequest = false;
            acceptedrequest = false;
            toggleFollow = "Follow";

            getAllFollowers();
            getAllFollowings();
            checkIfAlreadyFollowing();
          });
        }
      }
    });

    databaseserver.followingReference
        .document(userData.email)
        .collection('userFollowing')
        .document(widget.wiggle.email)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    databaseserver.feedReference
        .document(widget.wiggle.email)
        .collection('feed')
        .document(userData.email)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    databaseserver.cloudReference.document(userData.email).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  saveReceivercloudforfollow(UserData userData) async {
    QuerySnapshot query =
        await DatabaseService().getReceivertoken(widget.wiggle.email);
    String val = query.documents[0].data['token'].toString();
    databaseserver.cloudReference.document().setData({
      'type': 'follow',
      'ownerID': widget.wiggle.email,
      'ownerName': widget.wiggle.name,
      'timestamp': DateTime.now(),
      'userDp': userData.dp,
      'userID': userData.name,
      'token': val,
    });
  }

  saveReceivercloudforrequest(UserData userData) async {
    QuerySnapshot query =
        await DatabaseService().getReceivertoken(widget.wiggle.email);
    String val = query.documents[0].data['token'].toString();
    databaseserver.cloudReference.document().setData({
      'type': 'request',
      'ownerID': widget.wiggle.email,
      'ownerName': widget.wiggle.name,
      'timestamp': DateTime.now(),
      'userDp': userData.dp,
      'userID': userData.name,
      'token': val,
    });
  }

  sendrequest(UserData userData) async {
    print('request');
    if (this.mounted) {
      setState(() {
        sentrequest = true;
      });
    }

    saveReceivercloudforrequest(userData);
    databaseserver.feedReference
        .document(widget.wiggle.email)
        .collection('feed')
        .document(userData.email)
        .setData({
      'type': 'request',
      'ownerID': widget.wiggle.email,
      'ownerName': widget.wiggle.name,
      'timestamp': DateTime.now(),
      'userDp': userData.dp,
      'userID': userData.name,
      'status': 'sent',
      'senderEmail': userData.email
    });
    Stream<QuerySnapshot> query = await databaseserver.getRequestStatus(
        widget.wiggle.email,
        widget.wiggle.name,
        userData.dp,
        userData.name,
        userData.email);

    query.forEach((event) {
      if (event.documents[0].data['status'] == 'accepted') {
        controlFollowUser(userData);
        saveReceivercloudforfollow(userData);
        print('followed');

        if (this.mounted) {
          setState(() {
            following = true;
            sentrequest = true;
            acceptedrequest = true;
            toggleFollow = "Unfollow";

            getAllFollowers();
            getAllFollowings();
            checkIfAlreadyFollowing();
          });
        }
      }
    });
  }

  retractrequest(userData) async {
    print('retracted');
    if (this.mounted) {
      setState(() {
        following = false;
        sentrequest = false;
        acceptedrequest = false;
        toggleFollow = "Follow";
      });
    }
    databaseserver.feedReference
        .document(widget.wiggle.email)
        .collection('feed')
        .document(userData.email)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  //follow user
  controlFollowUser(UserData userData) {
    print('hi');
    databaseserver.followersReference
        .document(widget.wiggle.email)
        .collection('userFollowers')
        .document(userData.email)
        .setData({
      'name': userData.name,
      'dp': userData.dp,
      'email': userData.email
    });

    databaseserver.followingReference
        .document(userData.email)
        .collection('userFollowing')
        .document(widget.wiggle.email)
        .setData({
      'name': widget.wiggle.name,
      'dp': widget.wiggle.dp,
      'email': widget.wiggle.email
    });
    databaseserver.feedReference
        .document(widget.wiggle.email)
        .collection('feed')
        .document(userData.email)
        .setData({
      'type': 'request',
      'ownerID': widget.wiggle.email,
      'ownerName': widget.wiggle.name,
      'timestamp': DateTime.now(),
      'userDp': userData.dp,
      'userID': userData.name,
      'status': 'followed',
      'senderEmail': userData.email
    });
    databaseserver.feedReference
        .document(widget.wiggle.email)
        .collection('feed')
        .document()
        .setData({
      'type': 'follow',
      'ownerID': widget.wiggle.email,
      'ownerName': widget.wiggle.name,
      'timestamp': DateTime.now(),
      'userDp': userData.dp,
      'userID': userData.name,
      'status': 'followed',
      'senderEmail': userData.email
    });
  }

  Container createButtonTitleAndFunction(
      {String title, Function performFunction, UserData userData}) {
    return Container(
      padding: EdgeInsets.only(top: 1.0),
      child: FlatButton(
        onPressed: performFunction,
        child: Container(
          width: 150.0,
          height: 26.0,
          child: Text(
            title,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
      ),
    );
  }

  editUserPassword() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditAccount()));
  }

  editUserProfile() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: 869, width: 414, allowFontScaling: true);
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 9, 23, 1),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0.0,
      ),
      body: Stack(
        children: <Widget>[
          Column(children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blueGrey, Color.fromRGBO(3, 9, 23, 1)],
                ),
              ),
              child: Container(
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50,
                      child: ClipOval(
                        child: new SizedBox(
                          width: 180,
                          height: 180,
                          child: Image.network(
                                widget.wiggle.dp,
                                fit: BoxFit.fill,
                              ) ??
                              Image.asset('assets/images/profile1.png',
                                  fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.wiggle.name,
                      style: kTitleTextStyle.copyWith(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[300]),
                    ),
                    SizedBox(height: 20),
                    Container(
                        child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              createButton(widget.userData),
                            ],
                          ),
                        )
                      ],
                    )),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ]),
          (widget.userData.email == widget.wiggle.email || following)
              ? DraggableScrollableSheet(
                  minChildSize: 0.1,
                  initialChildSize: 0.65,
                  maxChildSize: 0.75,
                  builder: (context, scrollController) {
                    return SingleChildScrollView(
                        controller: scrollController,
                        child: Container(
                            color: Color.fromRGBO(3, 9, 23, 4),
                            constraints: BoxConstraints(
                                minHeight: MediaQuery.of(context).size.height),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    color: Colors.black45,
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 8),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  FlatButton(
                                                      child: createColumns(
                                                          'Followers',
                                                          countTotalFollowers),
                                                      onPressed: (widget
                                                                      .userData
                                                                      .email ==
                                                                  widget.wiggle
                                                                      .email ||
                                                              following)
                                                          ? () => Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => FollowersList(
                                                                      wiggles: widget
                                                                          .wiggles,
                                                                      otherWiggle: widget.wiggle)))
                                                          : () => print('tried pressing')),
                                                  FlatButton(
                                                      child: createColumns(
                                                          'Following',
                                                          countTotalFollowings),
                                                      onPressed: (widget
                                                                      .userData
                                                                      .email ==
                                                                  widget.wiggle
                                                                      .email ||
                                                              following)
                                                          ? () => Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => FollowingList(
                                                                      wiggles: widget
                                                                          .wiggles,
                                                                      otherWiggle: widget.wiggle)))
                                                          : () => print('tried pressing')),
                                                  // createColumns('Gamescore', 0),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                      child: Column(children: <Widget>[
                                    Text('About Me',
                                        style: kTitleTextStyle.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey[300])),
                                    SizedBox(
                                      height: kSpacingUnit.w,
                                    ),
                                    Text(widget.wiggle.bio,
                                        //' hiiiiiiGreyscale, also known as, is a dreaded and usually fatal dis',
                                        //"Greyscale, also known as, is a dreaded and usually fatal disease that can leave flesh stiff and dead, and the skin cracked and flaking, and stone-like to the touch. Those that manage to survive a bout with the illness will be immune from ever contracting it again, but the flesh damaged by the ravages of the disease will never heal, and they will be scarred for life. Princess Shireen Baratheon caught greyscale as an infant and survived, but the ordeal left half of her face disfigured by the disease.[2]",
                                        style: kCaptionTextStyle.copyWith(
                                          fontSize: 15,
                                        )),
                                    SizedBox(
                                      height: kSpacingUnit.w,
                                    ),
                                    Text('My Community',
                                        style: kTitleTextStyle.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey[300])),
                                    SizedBox(
                                      height: kSpacingUnit.w,
                                    ),
                                    Text(
                                        "Kent Ridge Hall, " +
                                            widget.wiggle.block +
                                            " block",
                                        style: kCaptionTextStyle.copyWith(
                                          fontSize: 15,
                                        )),
                                    SizedBox(
                                      height: kSpacingUnit.w,
                                    ),
                                    Text('My Social Media Profile',
                                        style: kTitleTextStyle.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey[300])),
                                    Text("Instagram: @THETINYBIN ",
                                        style: kCaptionTextStyle.copyWith(
                                          fontSize: 15,
                                        )),
                                    SizedBox(
                                      height: kSpacingUnit.w,
                                    ),
                                    Text('My Course',
                                        style: kTitleTextStyle.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey[300])),
                                    Text("Computer Science ",
                                        style: kCaptionTextStyle.copyWith(
                                          fontSize: 15,
                                        )),
                                    SizedBox(
                                      height: kSpacingUnit.w,
                                    ),
                                    Text('My Spotify Playlist',
                                        style: kTitleTextStyle.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey[300])),
                                    Text("Mac Ayres, Daniel Caesar",
                                        style: kCaptionTextStyle.copyWith(
                                          fontSize: 15,
                                        )),
                                    SizedBox(
                                      height: kSpacingUnit.w,
                                    ),
                                    Text('Living In',
                                        style: kTitleTextStyle.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey[300])),
                                    Text(
                                        "Kent Ridge Hall, " +
                                            widget.wiggle.block +
                                            " block",
                                        style: kCaptionTextStyle.copyWith(
                                          fontSize: 15,
                                        )),
                                    SizedBox(
                                      height: kSpacingUnit.w,
                                    ),
                                  ]))
                                ])));
                  })
              : DraggableScrollableSheet(
                  minChildSize: 0.1,
                  initialChildSize: 0.65,
                  maxChildSize: 0.75,
                  builder: (context, scrollController) {
                    return SingleChildScrollView(
                        controller: scrollController,
                        child: Container(
                            color: Color.fromRGBO(3, 9, 23, 4),
                            constraints: BoxConstraints(
                                minHeight: MediaQuery.of(context).size.height),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(15),
                                    color: Colors.black45,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        FlatButton(
                                            child: createColumns('Followers',
                                                countTotalFollowers),
                                            onPressed: (widget.userData.email ==
                                                        widget.wiggle.email ||
                                                    following)
                                                ? () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FollowersList(
                                                                wiggles: widget
                                                                    .wiggles,
                                                                otherWiggle:
                                                                    widget
                                                                        .wiggle)))
                                                : () =>
                                                    print('tried pressing')),
                                        FlatButton(
                                            child: createColumns('Following',
                                                countTotalFollowings),
                                            onPressed: (widget.userData.email ==
                                                        widget.wiggle.email ||
                                                    following)
                                                ? () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FollowingList(
                                                                wiggles: widget
                                                                    .wiggles,
                                                                otherWiggle:
                                                                    widget
                                                                        .wiggle)))
                                                : () =>
                                                    print('tried pressing')),
                                        // createColumns('Gamescore', 0),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                      child: Column(children: <Widget>[
                                    Text(
                                        'Follow ' +
                                            widget.wiggle.name +
                                            ' to know more!',
                                        style: kTitleTextStyle.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey)),
                                  ]))
                                ])));
                  })
        ],
      ),
    );
  }
}

Column createColumns(String title, int count) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        count.toString(),
        style: TextStyle(
            fontSize: 20.0,
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold),
      ),
      Container(
        margin: EdgeInsets.only(top: 5.0),
        child: Text(
          title,
          style: TextStyle(
              fontSize: 20.0,
              color: Colors.blueGrey,
              fontWeight: FontWeight.w400),
        ),
      )
    ],
  );
}
