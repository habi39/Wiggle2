import 'package:Wiggle2/screens/home/home.dart';
import 'package:Wiggle2/screens/wrapper/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/screens/anonymous/editanonprofile.dart';
import 'package:provider/provider.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/services/auth.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/shared/loading.dart';
import '../../models/user.dart';
import '../../shared/constants.dart';

class AnonOthersProfile extends StatefulWidget {
  final Wiggle wiggle;

  AnonOthersProfile({this.wiggle});

  @override
  _AnonOthersProfileState createState() => _AnonOthersProfileState();
}

class _AnonOthersProfileState extends State<AnonOthersProfile> {
  final AuthService _auth = AuthService();

  int fame;
  bool liked = false;
  bool disliked = false;
  @override
  void initState() {
    // TODO: implement initState
    getfame();

    getlikers();
    getdislikers();
    super.initState();
  }

  getfame() {
    DatabaseService(uid: widget.wiggle.id)
        .wiggleCollection
        .document(widget.wiggle.id)
        .collection('likes')
        .getDocuments()
        .then((like) {
      DatabaseService(uid: widget.wiggle.id)
          .wiggleCollection
          .document(widget.wiggle.id)
          .collection('dislikes')
          .getDocuments()
          .then((dislike) {
        setState(() {
          fame = like.documents.length - dislike.documents.length;
        });
      });
    });
  }

  getlikers() {
    DatabaseService(uid: widget.wiggle.id)
        .wiggleCollection
        .document(widget.wiggle.id)
        .collection('likes')
        .document(Constants.myEmail)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          liked = true;
        });
      }
    });
  }

  getdislikers() {
    DatabaseService(uid: widget.wiggle.id)
        .wiggleCollection
        .document(widget.wiggle.id)
        .collection('dislikes')
        .document(Constants.myEmail)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          disliked = true;
        });
      }
    });
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
                body: Stack(children: <Widget>[
              Column(children: <Widget>[
                SizedBox(height: kSpacingUnit.w * 5),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: kSpacingUnit.w * 3),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              FadeRoute(page: Wrapper()),
                              ModalRoute.withName('Wrapper'));
                        },
                        child: Icon(
                          LineAwesomeIcons.home,
                          size: ScreenUtil().setSp(kSpacingUnit.w * 2.5),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: kSpacingUnit.w * 10,
                              width: kSpacingUnit.w * 10,
                              margin: EdgeInsets.only(top: kSpacingUnit.w * 3),
                              child: Stack(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: kSpacingUnit.w * 5,
                                    child: ClipOval(
                                      child: new SizedBox(
                                        width: 180,
                                        height: 180,
                                        child: Image.network(
                                              widget.wiggle.anonDp,
                                              fit: BoxFit.cover,
                                            ) ??
                                            Image.asset(
                                                'assets/images/profile1.png',
                                                fit: BoxFit.cover),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: kSpacingUnit.w * 2),
                            Text(widget.wiggle.nickname,
                                style: kTitleTextStyle),
                            SizedBox(height: kSpacingUnit.w * 0.5),
                            Text('Anonymous', style: kCaptionTextStyle),
                            SizedBox(height: kSpacingUnit.w * 0.5),
                            Container(
                              height: kSpacingUnit.w * 5.5,
                              margin: EdgeInsets.symmetric(
                                horizontal: kSpacingUnit.w,
                              ).copyWith(
                                bottom: kSpacingUnit.w * 2,
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(kSpacingUnit.w * 3),
                                color: Theme.of(context).backgroundColor,
                              ),
                                  
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                IconButton(
                                                  icon: Icon(
                                                      LineAwesomeIcons
                                                          .chevron_circle_down,
                                                      color: disliked
                                                          ? Colors.red
                                                          : Colors.white),
                                                  onPressed: liked
                                                      ? () {}
                                                      : disliked
                                                          ? () {
                                                              setState(() {
                                                                disliked =
                                                                    false;
                                                                DatabaseService(
                                                                        uid: widget
                                                                            .wiggle
                                                                            .id)
                                                                    .wiggleCollection
                                                                    .document(
                                                                        widget
                                                                            .wiggle
                                                                            .id)
                                                                    .collection(
                                                                        'dislikes')
                                                                    .document(
                                                                        userData
                                                                            .email)
                                                                    .get()
                                                                    .then(
                                                                        (value) {
                                                                  if (value
                                                                      .exists) {
                                                                    value
                                                                        .reference
                                                                        .delete();
                                                                  }
                                                                });
                                                                DatabaseService(
                                                                        uid: widget
                                                                            .wiggle
                                                                            .id)
                                                                    .increaseFame(
                                                                        fame,
                                                                        userData
                                                                            .email,
                                                                        false);
                                                                fame = fame + 1;
                                                              });
                                                            }
                                                          : () {
                                                              setState(() {
                                                                liked = false;
                                                                disliked = true;
                                                                DatabaseService(
                                                                        uid: widget
                                                                            .wiggle
                                                                            .id)
                                                                    .wiggleCollection
                                                                    .document(
                                                                        widget
                                                                            .wiggle
                                                                            .id)
                                                                    .collection(
                                                                        'likes')
                                                                    .document(
                                                                        userData
                                                                            .email)
                                                                    .get()
                                                                    .then(
                                                                        (value) {
                                                                  if (value
                                                                      .exists) {
                                                                    value
                                                                        .reference
                                                                        .delete();
                                                                  }
                                                                });
                                                                DatabaseService(
                                                                  uid: widget
                                                                      .wiggle
                                                                      .id,
                                                                ).decreaseFame(
                                                                    fame,
                                                                    userData
                                                                        .email,
                                                                    true);
                                                                fame -= 1;
                                                              });
                                                            },
                                                ),
                                                Icon(
                                                  LineAwesomeIcons.star_1,
                                                  color: Color(0xFFFFC107),
                                                  size: 20,
                                                ),
                                                SizedBox(
                                                  width: kSpacingUnit.w,
                                                ),
                                                Text(fame==null? 0.toString():'$fame',
                                                    style: kTitleTextStyle
                                                        .copyWith(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700)),
                                                IconButton(
                                                  icon: Icon(
                                                      LineAwesomeIcons
                                                          .chevron_circle_up,
                                                      color: liked
                                                          ? Colors.red
                                                          : Colors.white),
                                                  onPressed: disliked
                                                      ? () {}
                                                      : liked
                                                          ? () {
                                                              setState(() {
                                                                liked = false;
                                                                DatabaseService(
                                                                        uid: widget
                                                                            .wiggle
                                                                            .id)
                                                                    .wiggleCollection
                                                                    .document(
                                                                        widget
                                                                            .wiggle
                                                                            .id)
                                                                    .collection(
                                                                        'likes')
                                                                    .document(
                                                                        userData
                                                                            .email)
                                                                    .get()
                                                                    .then(
                                                                        (value) {
                                                                  if (value
                                                                      .exists) {
                                                                    value
                                                                        .reference
                                                                        .delete();
                                                                  }
                                                                });
                                                                DatabaseService(
                                                                  uid: widget
                                                                      .wiggle
                                                                      .id,
                                                                ).decreaseFame(
                                                                    fame,
                                                                    userData
                                                                        .email,
                                                                    false);
                                                                fame -= 1;
                                                              });
                                                            }
                                                          : () {
                                                              setState(() {
                                                                liked = true;
                                                                disliked =
                                                                    false;
                                                                DatabaseService(
                                                                        uid: widget
                                                                            .wiggle
                                                                            .id)
                                                                    .wiggleCollection
                                                                    .document(
                                                                        widget
                                                                            .wiggle
                                                                            .id)
                                                                    .collection(
                                                                        'dislikes')
                                                                    .document(
                                                                        userData
                                                                            .email)
                                                                    .get()
                                                                    .then(
                                                                        (value) {
                                                                  if (value
                                                                      .exists) {
                                                                    value
                                                                        .reference
                                                                        .delete();
                                                                  }
                                                                });
                                                                DatabaseService(
                                                                        uid: widget
                                                                            .wiggle
                                                                            .id)
                                                                    .increaseFame(
                                                                        fame,
                                                                        userData
                                                                            .email,
                                                                        true);
                                                                fame = fame + 1;
                                                              });
                                                            },
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  
                            // Container(
                            //   height: kSpacingUnit.w * 5.5,
                            //   // margin: EdgeInsets.symmetric(
                            //   //   horizontal: kSpacingUnit.w,
                            //   // ).copyWith(
                            //   //   bottom: kSpacingUnit.w * 2,
                            //   // ),
                            //   decoration: BoxDecoration(
                            //     borderRadius:
                            //         BorderRadius.circular(kSpacingUnit.w * 3),
                            //     color: Theme.of(context).backgroundColor,
                            //   ),
                            //   child: FlatButton(
                            //       onPressed: () {},
                            //       child: Row(
                            //         children: <Widget>[
                            //           SizedBox(width: kSpacingUnit.w * 0.5),
                            //           Icon(LineAwesomeIcons.cog,
                            //               size: kSpacingUnit.w * 2.5),
                            //           SizedBox(width: kSpacingUnit.w * 1),
                            //           Text(
                            //             'Like',
                            //             style: kTitleTextStyle.copyWith(
                            //                 fontSize: 14,
                            //                 fontWeight: FontWeight.w500),
                            //           )
                            //         ],
                            //       )),
                            // )
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () {},
                        child: Icon(
                          LineAwesomeIcons.alternate_sign_out,
                          size: ScreenUtil().setSp(kSpacingUnit.w * 2.5),
                        ),
                      ),
                      SizedBox(height: kSpacingUnit.w * 3),
                    ]),
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
                              widget.wiggle.anonBio,
                              //' hiiiiiiGreyscale, also known as, is a dreaded and usually fatal dis',
                              //"Greyscale, also known as, is a dreaded and usually fatal disease that can leave flesh stiff and dead, and the skin cracked and flaking, and stone-like to the touch. Those that manage to survive a bout with the illness will be immune from ever contracting it again, but the flesh damaged by the ravages of the disease will never heal, and they will be scarred for life. Princess Shireen Baratheon caught greyscale as an infant and survived, but the ordeal left half of her face disfigured by the disease.[2]",
                              style: kCaptionTextStyle.copyWith(
                                fontSize: 15,
                              )),
                          SizedBox(
                            height: 15,
                          ),
                          Text('I N T E R E S T I N G  F A C T S',
                              style: kTitleTextStyle.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFFFFC107))),
                                  SizedBox(
                            height: 5,
                          ),
                          Text(
                              widget.wiggle.anonInterest 
                                  ,
                              //' hiiiiiiGreyscale, also known as, is a dreaded and usually fatal dis',
                              //"Greyscale, also known as, is a dreaded and usually fatal disease that can leave flesh stiff and dead, and the skin cracked and flaking, and stone-like to the touch. Those that manage to survive a bout with the illness will be immune from ever contracting it again, but the flesh damaged by the ravages of the disease will never heal, and they will be scarred for life. Princess Shireen Baratheon caught greyscale as an infant and survived, but the ordeal left half of her face disfigured by the disease.[2]",
                              style: kCaptionTextStyle.copyWith(
                                fontSize: 15,
                              )),
                          SizedBox(
                            height: 15,
                          ),
                          // Text('D I S C U S S I O N S',
                          //     style: kTitleTextStyle.copyWith(
                          //         fontSize: 18,
                          //         fontWeight: FontWeight.w300,
                          //         color: Color(0xFFFFC107))),
                                  SizedBox(
                            height: 5,
                          ),
                        ]))
              ]),
              
            ]));
          } else {
            return Loading();
          }
        });
  }
}
