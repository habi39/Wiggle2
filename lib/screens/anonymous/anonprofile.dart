import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/screens/anonymous/editanonprofile.dart';
import 'package:Wiggle2/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/shared/loading.dart';
import '../../models/user.dart';
import '../../shared/constants.dart';

class Myanonprofile extends StatefulWidget {
  @override
  _MyanonprofileState createState() => _MyanonprofileState();
}

class _MyanonprofileState extends State<Myanonprofile> {
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
                              FadeRoute(page: EditAnonProfile()),
                              ModalRoute.withName('EditAnonProfile'));
                        },
                        child: Icon(
                          LineAwesomeIcons.cog,
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
                                      child: Container(
                                        color: Colors.white,
                                        width: 180,
                                        height: 180,
                                        child: userData.anonDp != ""
                                            ? Image.network(
                                                userData.anonDp,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                'assets/images/profile1.png',
                                                fit: BoxFit.cover),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: kSpacingUnit.w * 2),
                            Text(userData.nickname, style: kTitleTextStyle),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          LineAwesomeIcons.star_1,
                                          color: Color(0xFFFFC107),
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: kSpacingUnit.w,
                                        ),
                                        Text(userData.fame.toString(),
                                            style: kTitleTextStyle.copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700))
                                      ],
                                    ),
                                  ],
                                )),
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
                              userData.anonBio == ''
                                  ? 'Add your information by clicking on the icon on the top left'
                                  : userData.anonBio,
                              //' hiiiiiiGreyscale, also known as, is a dreaded and usually fatal dis',
                              //"Greyscale, also known as, is a dreaded and usually fatal disease that can leave flesh stiff and dead, and the skin cracked and flaking, and stone-like to the touch. Those that manage to survive a bout with the illness will be immune from ever contracting it again, but the flesh damaged by the ravages of the disease will never heal, and they will be scarred for life. Princess Shireen Baratheon caught greyscale as an infant and survived, but the ordeal left half of her face disfigured by the disease.[2]",
                              style: userData.anonBio == ''? kCaptionTextStyle.copyWith(
                                fontSize: 10, color: Colors.grey
                              ):kCaptionTextStyle.copyWith(
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
                              userData.anonInterest == ''
                                  ? 'Add your information by clicking on the icon on the top left'
                                  : userData.anonBio,
                              //' hiiiiiiGreyscale, also known as, is a dreaded and usually fatal dis',
                              //"Greyscale, also known as, is a dreaded and usually fatal disease that can leave flesh stiff and dead, and the skin cracked and flaking, and stone-like to the touch. Those that manage to survive a bout with the illness will be immune from ever contracting it again, but the flesh damaged by the ravages of the disease will never heal, and they will be scarred for life. Princess Shireen Baratheon caught greyscale as an infant and survived, but the ordeal left half of her face disfigured by the disease.[2]",
                              style: userData.anonBio == ''? kCaptionTextStyle.copyWith(
                                fontSize: 10, color: Colors.grey
                              ):kCaptionTextStyle.copyWith(
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
