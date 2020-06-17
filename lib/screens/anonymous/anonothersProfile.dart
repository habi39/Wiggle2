import 'package:Wiggle2/screens/home/home.dart';
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
  _OthersProfileState createState() => _OthersProfileState();
}

class _OthersProfileState extends State<AnonOthersProfile> {
  final AuthService _auth = AuthService();
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
            return userData.email == widget.wiggle.email
                ? Scaffold(
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
                                Navigator.pop(context);
                              },
                              child: Icon(
                                LineAwesomeIcons.arrow_left,
                                size: ScreenUtil().setSp(kSpacingUnit.w * 2.5),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: kSpacingUnit.w * 10,
                                    width: kSpacingUnit.w * 10,
                                    margin: EdgeInsets.only(
                                        top: kSpacingUnit.w * 3),
                                    child: Stack(
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: kSpacingUnit.w * 5,
                                          child: ClipOval(
                                            child: new SizedBox(
                                              width: 180,
                                              height: 180,
                                              child: Image.network(
                                                    userData.anonDp,
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
                                  Text(userData.nickname,
                                      style: kTitleTextStyle),
                                  SizedBox(height: kSpacingUnit.w * 0.5),
                                  Text('Anonymous', style: kCaptionTextStyle),
                                  SizedBox(height: kSpacingUnit.w * 2.5),
                                  Container(
                                    height: kSpacingUnit.w * 5.5,
                                    // margin: EdgeInsets.symmetric(
                                    //   horizontal: kSpacingUnit.w,
                                    // ).copyWith(
                                    //   bottom: kSpacingUnit.w * 2,
                                    // ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          kSpacingUnit.w * 3),
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                    child: FlatButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditAnonProfile()));
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            SizedBox(
                                                width: kSpacingUnit.w * 0.5),
                                            Icon(LineAwesomeIcons.cog,
                                                size: kSpacingUnit.w * 2.5),
                                            SizedBox(width: kSpacingUnit.w * 1),
                                            Text(
                                              'Edit Anonymous Profile',
                                              style: kTitleTextStyle.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        )),
                                  )
                                ],
                              ),
                            ),
                            FlatButton(
                              onPressed: () async {
                                await _auth.signOut();
                              },
                              child: Icon(
                                LineAwesomeIcons.alternate_sign_out,
                                size: ScreenUtil().setSp(kSpacingUnit.w * 2.5),
                              ),
                            ),
                            SizedBox(height: kSpacingUnit.w * 3),
                          ])
                    ]),
                    DraggableScrollableSheet(
                        minChildSize: 0.1,
                        initialChildSize: 0.50,
                        maxChildSize: 0.65,
                        builder: (context, scrollController) {
                          return SingleChildScrollView(
                              controller: scrollController,
                              child: Container(
                                  color: Color(0xFF373739),
                                  constraints: BoxConstraints(
                                      minHeight:
                                          MediaQuery.of(context).size.height),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: kSpacingUnit.w,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 32, right: 32, top: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 10,
                                              ),
                                              SizedBox(
                                                height: 70,
                                                width: 70,
                                                child: ClipOval(
                                                  child: Image.network(
                                                        userData.anonDp,
                                                        fit: BoxFit.fill,
                                                      ) ??
                                                      Image.asset(
                                                          'assets/images/profile1.png',
                                                          fit: BoxFit.fill),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(userData.nickname,
                                                        style: kTitleTextStyle
                                                            .copyWith(
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        )),
                                                    Text(userData.nickname,
                                                        style: kCaptionTextStyle
                                                            .copyWith(
                                                                fontSize: 15)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: kSpacingUnit.w,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(15),
                                          color: Color(0xEE454545),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Icon(
                                                        LineAwesomeIcons.heart,
                                                        color: Colors.red,
                                                        size: 30,
                                                      ),
                                                      SizedBox(
                                                        width: kSpacingUnit.w,
                                                      ),
                                                      Text('1000',
                                                          style: kTitleTextStyle
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700))
                                                    ],
                                                  ),
                                                ],
                                              )
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
                                              )),
                                          SizedBox(
                                            height: kSpacingUnit.w,
                                          ),
                                          Text(userData.anonBio,
                                              style: kCaptionTextStyle.copyWith(
                                                fontSize: 15,
                                              )),
                                          SizedBox(
                                            height: kSpacingUnit.w,
                                          ),
                                          Text('Interesting Facts',
                                              style: kTitleTextStyle.copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                              )),
                                          SizedBox(
                                            height: kSpacingUnit.w,
                                          ),
                                          Text(userData.anonInterest,
                                              style: kCaptionTextStyle.copyWith(
                                                fontSize: 15,
                                              ))
                                        ]))
                                      ])));
                        })
                  ]))
                : Scaffold(
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
                            FadeRoute(
                              page: Home()
                            ),
                            ModalRoute.withName('Home'));
                      
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
                                    margin: EdgeInsets.only(
                                        top: kSpacingUnit.w * 3),
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
                                  SizedBox(height: kSpacingUnit.w * 2.5),
                                  Container(
                                    height: kSpacingUnit.w * 5.5,
                                    // margin: EdgeInsets.symmetric(
                                    //   horizontal: kSpacingUnit.w,
                                    // ).copyWith(
                                    //   bottom: kSpacingUnit.w * 2,
                                    // ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          kSpacingUnit.w * 3),
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                    child: FlatButton(
                                        onPressed: () {},
                                        child: Row(
                                          children: <Widget>[
                                            SizedBox(
                                                width: kSpacingUnit.w * 0.5),
                                            Icon(LineAwesomeIcons.cog,
                                                size: kSpacingUnit.w * 2.5),
                                            SizedBox(width: kSpacingUnit.w * 1),
                                            Text(
                                              'Like',
                                              style: kTitleTextStyle.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        )),
                                  )
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
                          ])
                    ]),
                    DraggableScrollableSheet(
                        minChildSize: 0.1,
                        initialChildSize: 0.50,
                        maxChildSize: 0.65,
                        builder: (context, scrollController) {
                          return SingleChildScrollView(
                              controller: scrollController,
                              child: Container(
                                  color: Color(0xFF373739),
                                  constraints: BoxConstraints(
                                      minHeight:
                                          MediaQuery.of(context).size.height),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: kSpacingUnit.w,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 32, right: 32, top: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 10,
                                              ),
                                              SizedBox(
                                                height: 70,
                                                width: 70,
                                                child: ClipOval(
                                                  child: Image.network(
                                                        widget.wiggle.anonDp,
                                                        fit: BoxFit.fill,
                                                      ) ??
                                                      Image.asset(
                                                          'assets/images/profile1.png',
                                                          fit: BoxFit.fill),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(widget.wiggle.nickname,
                                                        style: kTitleTextStyle
                                                            .copyWith(
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        )),
                                                    Text(widget.wiggle.nickname,
                                                        style: kCaptionTextStyle
                                                            .copyWith(
                                                                fontSize: 15)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: kSpacingUnit.w,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(15),
                                          color: Color(0xEE454545),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Icon(
                                                        LineAwesomeIcons.heart,
                                                        color: Colors.red,
                                                        size: 30,
                                                      ),
                                                      SizedBox(
                                                        width: kSpacingUnit.w,
                                                      ),
                                                      Text('1000',
                                                          style: kTitleTextStyle
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700))
                                                    ],
                                                  ),
                                                ],
                                              )
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
                                              )),
                                          SizedBox(
                                            height: kSpacingUnit.w,
                                          ),
                                          Text(widget.wiggle.anonBio,
                                              //' hiiiiiiGreyscale, also known as, is a dreaded and usually fatal dis',
                                              //"Greyscale, also known as, is a dreaded and usually fatal disease that can leave flesh stiff and dead, and the skin cracked and flaking, and stone-like to the touch. Those that manage to survive a bout with the illness will be immune from ever contracting it again, but the flesh damaged by the ravages of the disease will never heal, and they will be scarred for life. Princess Shireen Baratheon caught greyscale as an infant and survived, but the ordeal left half of her face disfigured by the disease.[2]",
                                              style: kCaptionTextStyle.copyWith(
                                                fontSize: 15,
                                              )),
                                          SizedBox(
                                            height: kSpacingUnit.w,
                                          ),
                                          Text('Interesting Facts',
                                              style: kTitleTextStyle.copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                              )),
                                          SizedBox(
                                            height: kSpacingUnit.w,
                                          ),
                                          Text(widget.wiggle.anonInterest,
                                              style: kCaptionTextStyle.copyWith(
                                                fontSize: 15,
                                              ))
                                        ]))
                                      ])));
                        })
                  ]));
          } else {
            return Loading();
          }
        });
  }
}
