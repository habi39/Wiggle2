import 'package:Wiggle2/screens/home/addpicture.dart';
import 'package:Wiggle2/screens/wrapper/wrapper.dart';
import 'package:Wiggle2/shared/loading.dart';
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
import 'package:provider/provider.dart';

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
      padding: EdgeInsets.only(top: 0.5),
      child: FlatButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onPressed: () => sentrequest
            ? acceptedrequest
                ? controlUnfollowUser(userData)
                : retractrequest(userData)
            : sendrequest(userData),
        child: Container(
          width: MediaQuery.of(context).size.width / 2.5,
          height: 26.0,
          child: Text(title,
              style: kCaptionTextStyle.copyWith(
                  fontWeight: FontWeight.w200, fontSize: 12)),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xFF373737),
            borderRadius: BorderRadius.circular(10.0),
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
    QuerySnapshot query = await DatabaseService(uid: widget.wiggle.id)
        .getReceivertoken(widget.wiggle.email);
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
    QuerySnapshot query = await DatabaseService(uid: widget.wiggle.id)
        .getReceivertoken(widget.wiggle.email);
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
      padding: EdgeInsets.only(top: 0.5),
      child: FlatButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onPressed: performFunction,
        child: Container(
          width: MediaQuery.of(context).size.width / 2.5,
          height: 26.0,
          child: Text(title,
              style: kCaptionTextStyle.copyWith(
                  fontWeight: FontWeight.w200, fontSize: 12)),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xFF373737),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  editUserPassword() {
    Navigator.of(context).pushAndRemoveUntil(
        FadeRoute(page: EditAccount()), ModalRoute.withName('EditAccount'));
  }

  editUserProfile() {
    Navigator.of(context).pushAndRemoveUntil(
        FadeRoute(page: EditProfileScreen()),
        ModalRoute.withName('EditProfileScreen'));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context) ?? User();
    final wiggles = Provider.of<List<Wiggle>>(context) ?? [];
    ScreenUtil.init(context, height: 869, width: 414, allowFontScaling: true);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;
          if (userData != null) {
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
                elevation: 0,
              ),
              body: Stack(children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      child: Container(),
                    ),
                  ],
                ),
                SingleChildScrollView(
                    child: Container(
                        decoration: BoxDecoration(
                          //color: Color(0xFF505050),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height),
                        child: Column(children: <Widget>[
                          Container(
                              child: Column(children: <Widget>[
                            Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 55,
                                            child: ClipOval(
                                              child: new SizedBox(
                                                width: 180,
                                                height: 180,
                                                child: Image.network(
                                                      widget.wiggle.dp,
                                                      fit: BoxFit.fill,
                                                    ) ??
                                                    Image.asset(
                                                        'assets/images/profile1.png',
                                                        fit: BoxFit.fill),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Text(widget.wiggle.name,
                                              style: kTitleTextStyle.copyWith(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey[300])),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: MediaQuery.of(context).size.width/1.17,
                                  padding: EdgeInsets.only(
                                      top: 3, bottom: 3,),
                                  decoration: BoxDecoration(
                                      color: Color(0xFF373737),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      )),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    //crossAxisAlignment: CrossAxisAlignment.baseline,
                                    children: <Widget>[
                                      FlatButton(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          padding: EdgeInsets.only(
                                              left: 21, right: 21),
                                          child: createColumns(
                                              'Followers', countTotalFollowers),
                                          onPressed: (widget.userData.email ==
                                                      widget.wiggle.email ||
                                                  following)
                                              ? () => Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          FadeRoute(
                                              page: FollowersList(
                                                  wiggles: wiggles,
                                                  userData: userData)),
                                          ModalRoute.withName('FollowersList'),
                                        )
                                              : () => print('tried pressing')),
                                      FlatButton(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          padding: EdgeInsets.only(
                                              left: 21, right: 21),
                                          child: createColumns('Following',
                                              countTotalFollowings),
                                          onPressed: (widget.userData.email ==
                                                      widget.wiggle.email ||
                                                  following)
                                              ? () => Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          FadeRoute(
                                              page: FollowingList(
                                                  wiggles: wiggles,
                                                  userData: userData)),
                                          ModalRoute.withName('FollowingList'),
                                        )
                                              : () => print('tried pressing')),
                                      FlatButton(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        padding: EdgeInsets.only(
                                            left: 21, right: 21),
                                        child: createColumns('Fame', widget.wiggle.fame),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          createButton(userData),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                              ],
                            ),
                            (widget.userData.email == widget.wiggle.email ||
                                    following)
                                ? Container(
                                    padding: EdgeInsets.all(15),
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('A B O U T  M E',
                                            style: kTitleTextStyle.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300,
                                                color: Color(0xFFFFC107))),
                                        SizedBox(
                                          height: 5,
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
                                        Text('C O M M U N I T Y',
                                            style: kTitleTextStyle.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300,
                                                color: Color(0xFFFFC107))),
                                        SizedBox(
                                          height: 5,
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
                                        Text('S O C I A L   M E D I A ',
                                            style: kTitleTextStyle.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300,
                                                color: Color(0xFFFFC107))),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(widget.wiggle.media,
                                            style: kCaptionTextStyle.copyWith(
                                              fontSize: 15,
                                            )),
                                        SizedBox(
                                          height: kSpacingUnit.w,
                                        ),
                                        Text('C O U R S E',
                                            style: kTitleTextStyle.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300,
                                                color: Color(0xFFFFC107))),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(widget.wiggle.course,
                                            style: kCaptionTextStyle.copyWith(
                                              fontSize: 15,
                                            )),
                                        SizedBox(
                                          height: kSpacingUnit.w,
                                        ),
                                        Text('P L A Y L I S T',
                                            style: kTitleTextStyle.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300,
                                                color: Color(0xFFFFC107))),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(widget.wiggle.playlist,
                                            style: kCaptionTextStyle.copyWith(
                                              fontSize: 15,
                                            )),
                                        SizedBox(
                                          height: kSpacingUnit.w,
                                        ),
                                        Text('L I V I N G   I N',
                                            style: kTitleTextStyle.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300,
                                                color: Color(0xFFFFC107))),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                           widget.wiggle.accoms,
                                            style: kCaptionTextStyle.copyWith(
                                              fontSize: 15,
                                            )),
                                        SizedBox(
                                          height: kSpacingUnit.w,
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                        'FOLLOW ' +
                                            widget.wiggle.name +
                                            ' TO  VIEW THEIR PROFILE',
                                        style: kTitleTextStyle.copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                            color: Color(0xFFFFC107))),
                                  ),
                            (widget.userData.email == widget.wiggle.email ||
                                    following)
                                ? StreamBuilder(
                                    stream:
                                        DatabaseService(uid: widget.wiggle.id)
                                            .getphotos(),
                                    builder: (context, snapshot) {
                                      return snapshot.hasData
                                          ? Container(
                                              height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.30 -
                                                  50,
                                              child: ListView.builder(
                                                  physics:
                                                      ClampingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: snapshot
                                                      .data.documents.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Container(
                                                        width: 150,
                                                        margin: EdgeInsets.only(
                                                            right: 20),
                                                        height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.30 -
                                                            50,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20.0)),
                                                          child: Image.network(
                                                                snapshot
                                                                    .data
                                                                    .documents[
                                                                        index]
                                                                    .data['photo'],
                                                                fit:
                                                                    BoxFit.fill,
                                                              ) ??
                                                              Image.asset(
                                                                  'assets/images/profile1.png',
                                                                  fit: BoxFit
                                                                      .fill),
                                                        ));
                                                  }))
                                          : Loading();
                                    })
                                : Container()
                          ]))
                        ])))
              ]),
            );
          } else {
            return Loading();
          }
        });
  }
}

Column createColumns(String title, int count) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        count.toString(),
        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
      ),
      Container(
        margin: EdgeInsets.only(top: 5.0),
        child: Text(
          title,
          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w200),
        ),
      )
    ],
  );
}
