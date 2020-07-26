import 'package:Wiggle2/screens/feed/feed.dart';
import 'package:Wiggle2/screens/forum/forum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:Wiggle2/games/smashbros/smash_engine/screen_util.dart';
import 'package:Wiggle2/screens/anonymous/anonprofile.dart';
import 'package:Wiggle2/screens/anonymous/anonymousChatScreen.dart';
import 'package:Wiggle2/screens/home/notificationsPage.dart';
import 'package:Wiggle2/screens/home/profile.dart';
import 'package:Wiggle2/screens/home/chatScreen.dart';
import '../../models/user.dart';
import 'package:provider/provider.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:flutter/cupertino.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static bool anonymous = false;

  int _currentIndex = 1;

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final tabs = [
    Feed(),
    ChatScreen(),
    NotificationPage(),
    Myprofile(),
  ];
  final anonymoustabs = [
    Forum(),
    AnonymousChatScreen(),
    NotificationPage(),
    Myanonprofile(),
  ];

  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  showSnackBar(Map<String, dynamic> message) {
    final snackBar = SnackBar( 
      behavior: SnackBarBehavior.fixed,
      content: Text(message['notification']['body']),
      action: SnackBarAction(
        textColor: Colors.black,
        label: 'Wiggle!',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationPage(),
          ),
        ),
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.amber,
    );
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }

  _saveDeviceToken(String uid) async {
    String fcmToken = await _fcm.getToken();
    DatabaseService(uid: uid).uploadtoken(fcmToken);
  }

  @override
  void initState() {
    super.initState();

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        showSnackBar(message);
        print('onMessage: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatScreen()));
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
    );
    _fcm.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    _saveDeviceToken(user.uid);
    ScreenUtil.setScreenOrientation('portrait');
    //this StreamProvider provides the list of user for WiggleList();
    return anonymous
        ? Scaffold(
            key: _scaffoldkey,
            body: anonymoustabs[_currentIndex],
            //floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
            floatingActionButton: FloatingActionButton(
              splashColor: Colors.transparent,
              child: Icon(Icons.portrait),
              onPressed: () {
                DatabaseService(uid: user.uid).updateAnonymous(false);
                setState(() {
                  anonymous = false;
                });
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              color: Color(0xFF373737),
              shape: CircularNotchedRectangle(),
              notchMargin: 10,
              child: Container(
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MaterialButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          // minWidth: 40,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 0;
                            });
                          },
                          child: Icon(
                            Icons.menu,
                            color: _currentIndex == 0
                                ? Colors.amber
                                : Colors.white,
                          ),
                        ),
                        MaterialButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 1;
                            });
                          },
                          child: Icon(
                            Icons.chat,
                            color: _currentIndex == 1
                                ? Colors.amber
                                : Colors.white,
                          ),
                        )
                      ],
                    ),
                    // Right Tab bar icons
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MaterialButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 2;
                            });
                          },
                          child: Icon(
                            Icons.new_releases,
                            color: _currentIndex == 2
                                ? Colors.amber
                                : Colors.white,
                          ),
                        ),
                        MaterialButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          // minWidth: 40,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 3;
                            });
                          },
                          child: CircleAvatar(
                            radius: 19,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/ghosty2.png',
                                fit: BoxFit.fill,
                                color: _currentIndex == 3
                                    ? Colors.amber
                                    : Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            key: _scaffoldkey,
            body: tabs[_currentIndex],
            floatingActionButton: FloatingActionButton(
              splashColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.asset('assets/images/ghosty2.png',
                    fit: BoxFit.fill, color: Colors.amber),
              ),
              onPressed: () {
                DatabaseService(uid: user.uid).updateAnonymous(true);
                setState(() {
                  anonymous = true;
                });
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              color: Colors.white38,
              shape: CircularNotchedRectangle(),
              notchMargin: 10,
              child: Container(
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MaterialButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          // minWidth: 40,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 0;
                            });
                          },
                          child: Icon(
                            Icons.menu,
                            color: _currentIndex == 0
                                ? Colors.amber
                                : Colors.white,
                          ),
                        ),
                        MaterialButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 1;
                            });
                          },
                          child: Icon(
                            Icons.chat,
                            color: _currentIndex == 1
                                ? Colors.amber
                                : Colors.white,
                          ),
                        )
                      ],
                    ),
                    // Right Tab bar icons
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MaterialButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 2;
                            });
                          },
                          child: Icon(
                            Icons.new_releases,
                            color: _currentIndex == 2
                                ? Colors.amber
                                : Colors.white,
                          ),
                        ),
                        MaterialButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          // minWidth: 40,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 3;
                            });
                          },
                          child: Icon(
                            Icons.portrait,
                            color: _currentIndex == 3
                                ? Colors.amber
                                : Colors.white,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
