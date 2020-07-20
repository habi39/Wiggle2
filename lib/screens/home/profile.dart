import 'package:Wiggle2/screens/home/addpicture.dart';
import 'package:Wiggle2/screens/home/home.dart';
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
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

class Myprofile extends StatefulWidget {
  @override
  _MyprofileState createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  int countTotalFollowers = 0;
  int countTotalFollowings = 0;
  var personalEmail;
  Stream photoStream;

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
                elevation: 0,
                actions: <Widget>[
                  IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
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
                                  width:
                                      MediaQuery.of(context).size.width / 1.17,
                                  padding: EdgeInsets.only(top: 3, bottom: 3),
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
                                        onPressed: () => Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          FadeRoute(
                                              page: FollowersList(
                                                  wiggles: wiggles,
                                                  userData: userData)),
                                          ModalRoute.withName('FollowersList'),
                                        ),
                                      ),
                                      FlatButton(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        padding: EdgeInsets.only(
                                            left: 21, right: 21),
                                        child: createColumns(
                                            'Following', countTotalFollowings),
                                        onPressed: () => Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          FadeRoute(
                                              page: FollowingList(
                                                  wiggles: wiggles,
                                                  userData: userData)),
                                          ModalRoute.withName('FollowingList'),
                                        ),
                                      ),
                                      FlatButton(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        padding: EdgeInsets.only(
                                            left: 21, right: 21),
                                        child: createColumns(
                                            'Fame', userData.fame),
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
                                  Text('A B O U T  M E',
                                      style: kTitleTextStyle.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
                                          color: Color(0xFFFFC107))),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      userData.bio == ''
                                          ? 'Add your information by clicking on the icon on Edit Profile'
                                          : userData.bio,
                                      style: userData.bio == ''
                                          ? kCaptionTextStyle.copyWith(
                                              fontSize: 10, color: Colors.grey)
                                          : kCaptionTextStyle.copyWith(
                                              fontSize: 15,
                                            )),
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
                                  Text(userData.media== ''
                                          ? 'Add your information by clicking on the icon on Edit Profile'
                                          :userData.media,
                                      style: userData.media== ''
                                          ? kCaptionTextStyle.copyWith(
                                              fontSize: 10, color: Colors.grey)
                                          :kCaptionTextStyle.copyWith(
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
                                  Text(userData.course== ''
                                          ? 'Add your information by clicking on the icon on Edit Profile'
                                          :userData.course,
                                      style: userData.course== ''
                                          ?kCaptionTextStyle.copyWith(
                                              fontSize: 10, color: Colors.grey)
                                          :kCaptionTextStyle.copyWith(
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
                                  Text(userData.playlist== ''
                                          ? 'Add your information by clicking on the icon on Edit Profile'
                                          :userData.playlist,
                                      style: userData.playlist== ''
                                          ?kCaptionTextStyle.copyWith(
                                              fontSize: 10, color: Colors.grey)
                                          :kCaptionTextStyle.copyWith(
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
                                  Text(userData.accoms== ''
                                          ? 'Add your information by clicking on the icon on Edit Profile'
                                          :userData.accoms,
                                      style:userData.accoms== ''
                                          ?kCaptionTextStyle.copyWith(
                                              fontSize: 10, color: Colors.grey)
                                          : kCaptionTextStyle.copyWith(
                                        fontSize: 15,
                                      )),
                                  SizedBox(
                                    height: kSpacingUnit.w,
                                  ),
                                ],
                              ),
                            ),
                            StreamBuilder(
                                stream:
                                    DatabaseService(uid: user.uid).getphotos(),
                                builder: (context, snapshot) {
                                  return snapshot.hasData
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Container(
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
                                                        .data.documents.length +
                                                    1,
                                                itemBuilder: (context, index) {
                                                  if (index ==
                                                      snapshot.data.documents
                                                          .length) {
                                                    return Column(
                                                      children: <Widget>[
                                                        Text(
                                                            'Add a picture to your profile'),
                                                        IconButton(
                                                          icon: Icon(
                                                              LineAwesomeIcons
                                                                  .plus_circle),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pushAndRemoveUntil(
                                                              FadeRoute(
                                                                  page:
                                                                      Addpicture()),
                                                              ModalRoute.withName(
                                                                  'Addpicture'),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                  return FocusedMenuHolder(
                                                    menuWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.36,
                                                    onPressed: () {},
                                                    menuItems: <
                                                        FocusedMenuItem>[
                                                      FocusedMenuItem(
                                                          title: Text(
                                                            "Delete Photo",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12),
                                                          ),
                                                          trailingIcon: Icon(
                                                              Icons.delete),
                                                          onPressed: () {
                                                            DatabaseService()
                                                                .wiggleCollection
                                                                .document(
                                                                    user.uid)
                                                                .collection(
                                                                    'photos')
                                                                .getDocuments()
                                                                .then((doc) {
                                                              if (doc
                                                                  .documents[
                                                                      index]
                                                                  .exists) {
                                                                doc
                                                                    .documents[
                                                                        index]
                                                                    .reference
                                                                    .delete();
                                                              }
                                                            });
                                                          },
                                                          backgroundColor:
                                                              Colors.redAccent)
                                                    ],
                                                    child: Container(
                                                      width: 150,
                                                      margin: EdgeInsets.only(
                                                          right: 15),
                                                      height:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .height *
                                                                  0.30 -
                                                              50,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20.0)),
                                                        child: Image.network(
                                                              snapshot
                                                                  .data
                                                                  .documents[
                                                                      index]
                                                                  .data['photo'],
                                                              fit: BoxFit.fill,
                                                            ) ??
                                                            Image.asset(
                                                                'assets/images/profile1.png',
                                                                fit: BoxFit
                                                                    .fill),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        )
                                      : Loading();
                                }),
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
