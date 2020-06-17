import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/screens/home/editAccountScreen.dart';
import 'package:Wiggle2/screens/home/followersList.dart';
import 'package:Wiggle2/services/auth.dart';
import 'package:Wiggle2/screens/home/editProfileScreen.dart';
import 'package:provider/provider.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/shared/loading.dart';
import '../../shared/constants.dart';
import '../../models/user.dart';
import 'followingList.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Myprofile extends StatefulWidget {
  @override
  _MyprofileState createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  int countTotalFollowers = 0;
  int countTotalFollowings = 0;
  var personalEmail;

  getAllFollowings() async {
    QuerySnapshot querySnapshot = await DatabaseService()
        .followingReference
        .document(personalEmail)
        .collection('userFollowing')
        .getDocuments();
    if (this.mounted) {
      setState(() {
        countTotalFollowings = querySnapshot.documents.length;
      });
    }
  }

  getAllFollowers() async {
    QuerySnapshot querySnapshot = await DatabaseService()
        .followersReference
        .document(personalEmail)
        .collection('userFollowers')
        .getDocuments();
    if (this.mounted) {
      setState(() {
        countTotalFollowers = querySnapshot.documents.length;
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

  createButton(UserData userData) {
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
  }

  Container createButtonTitleAndFunction(
      {String title, Function performFunction}) {
    return Container(
      padding: EdgeInsets.only(top: 0.5),
      child: FlatButton(
        onPressed: performFunction,
        child: Container(
          width: MediaQuery.of(context).size.width/2.5,
          height: 26.0,
          child: Text(title, style: kCaptionTextStyle),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xFF373737),
            borderRadius: BorderRadius.circular(4.0),
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

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context) ?? User();
    final wiggles = Provider.of<List<Wiggle>>(context) ?? [];
    ScreenUtil.init(context, height: 869, width: 414, allowFontScaling: true);
    getAllFollowers();
    getAllFollowings();

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;
          if (userData != null) {
            personalEmail = userData.email;
            return Scaffold(
              body: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: kSpacingUnit.w * 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: kSpacingUnit.w * 5),
                                  FlatButton(
                                    onPressed: () {},
                                    child: Icon(
                                      LineAwesomeIcons.sun,
                                      size: ScreenUtil()
                                          .setSp(kSpacingUnit.w * 2.5),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(height: kSpacingUnit.w * 3),
                                        CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 50,
                                          child: ClipOval(
                                            child: new SizedBox(
                                              width: 180,
                                              height: 180,
                                              child: Image.network(
                                                    userData.dp,
                                                    fit: BoxFit.fill,
                                                  ) ??
                                                  Image.asset(
                                                      'assets/images/profile1.png',
                                                      fit: BoxFit.fill),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(userData.name,
                                            style: kTitleTextStyle.copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w100,
                                                color: Colors.grey[300])),
                                      ],
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () async {
                                      await _auth.signOut();
                                    },
                                    child: Icon(
                                      LineAwesomeIcons.alternate_sign_out,
                                      size: ScreenUtil()
                                          .setSp(kSpacingUnit.w * 2.5),
                                    ),
                                  ),
                                ],
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
                        ),
                      ),
                    ],
                  ),
                  DraggableScrollableSheet(
                      minChildSize: 0.1,
                      initialChildSize: 0.65,
                      maxChildSize: 0.70,
                      builder: (context, scrollController) {
                        return SingleChildScrollView(
                            controller: scrollController,
                            child: Container(
                                color: Color(0xFF212121),
                                constraints: BoxConstraints(
                                    minHeight:
                                        MediaQuery.of(context).size.height),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                child: createColumns(
                                                    'Followers',
                                                    countTotalFollowers),
                                                onPressed: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FollowersList(
                                                                wiggles:
                                                                    wiggles,
                                                                userData:
                                                                    userData)))),
                                            FlatButton(
                                                child: createColumns(
                                                    'Following',
                                                    countTotalFollowings),
                                                onPressed: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FollowingList(
                                                                wiggles:
                                                                    wiggles,
                                                                userData:
                                                                    userData)))),
                                            // createColumns('Gamescore', 0),
                                          ],
                                        ),
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
                                        Text(userData.bio,
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
                                                userData.block +
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
                                                userData.block +
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
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
