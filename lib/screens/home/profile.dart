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
              appBar: AppBar(
                titleSpacing: 50,
                elevation: 0,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      LineAwesomeIcons.alternate_sign_out,
                    ),
                    onPressed: () async {
                      await _auth.signOut();
                    },
                  ),
                ],
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
                                                      userData.dp,
                                                      fit: BoxFit.fill,
                                                    ) ??
                                                    Image.asset(
                                                        'assets/images/profile1.png',
                                                        fit: BoxFit.fill),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Text(userData.name,
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
                                  padding: EdgeInsets.only(
                                      top: 3, bottom: 3, left: 30, right: 30),
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
                                          padding: EdgeInsets.only(
                                              left: 25, right: 25),
                                          child: createColumns(
                                              'Followers', countTotalFollowers),
                                          onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FollowersList(
                                                          wiggles: wiggles,
                                                          userData:
                                                              userData)))),
                                      FlatButton(
                                          padding: EdgeInsets.only(
                                              left: 25, right: 25),
                                          child: createColumns('Following',
                                              countTotalFollowings),
                                          onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FollowingList(
                                                          wiggles: wiggles,
                                                          userData:
                                                              userData)))),
                                      FlatButton(
                                        padding: EdgeInsets.only(
                                            left: 25, right: 25),
                                        child: createColumns('Gamescore', 0),
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
                            Container(
                              padding: EdgeInsets.all(15),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('A B O U T    M E',
                                      style: kTitleTextStyle.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
                                          color: Color(0xFFFFC107))),
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
                                          userData.block +
                                          " block",
                                      style: kCaptionTextStyle.copyWith(
                                        fontSize: 15,
                                      )),
                                  SizedBox(height: 15),
                                  Text('S O C I A L   M E D I A ',
                                      style: kTitleTextStyle.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
                                          color: Color(0xFFFFC107))),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("Instagram: @THETINYBIN ",
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
                                  Text("Computer Science ",
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
                                  Text("Mac Ayres, Daniel Caesar",
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
                                      "Kent Ridge Hall, " +
                                          userData.block +
                                          " block",
                                      style: kCaptionTextStyle.copyWith(
                                        fontSize: 15,
                                      )),
                                  SizedBox(
                                    height: kSpacingUnit.w,
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  alignment: Alignment.topCenter,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 150,
                                        margin: EdgeInsets.only(right: 20),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                    0.30 -
                                                50,
                                        decoration: BoxDecoration(
                                            color: Colors.orange.shade400,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Picture 1",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Caption",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 150,
                                        margin: EdgeInsets.only(right: 20),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                    0.30 -
                                                50,
                                        decoration: BoxDecoration(
                                            color: Colors.blue.shade400,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0))),
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "Picture 2",
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "caption",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 150,
                                        margin: EdgeInsets.only(right: 20),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                    0.30 -
                                                50,
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.lightBlueAccent.shade400,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Picture 3",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Caption",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
