import 'package:Wiggle2/screens/feed/feed.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:Wiggle2/games/smashbros/smash_engine/screen_util.dart';
import 'package:Wiggle2/screens/anonymous/anonprofile.dart';
import 'package:Wiggle2/screens/anonymous/anonymousChatScreen.dart';
import 'package:Wiggle2/screens/anonymous/anonymousGames.dart';
import 'package:Wiggle2/screens/home/gameslist.dart';
import 'package:Wiggle2/screens/home/notificationsPage.dart';
import 'package:Wiggle2/screens/home/profile.dart';
import 'package:Wiggle2/screens/home/chatScreen.dart';
import 'package:Wiggle2/screens/authenticate/intro/introPage1.dart';
import 'package:Wiggle2/shared/constants.dart';
import 'package:Wiggle2/shared/loading.dart';
import '../../models/user.dart';
import '../../models/wiggle.dart';
import 'package:provider/provider.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:io';

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
    AnonymousGames(),
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
        label: message['notification']['body'],
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationPage(),
          ),
        ),
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.blue,
    );
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }

  _saveDeviceToken() async {
    String fcmToken = await _fcm.getToken();

    if (Platform.operatingSystem == 'android') {
      await Firestore.instance
          .collection('users')
          .document(Constants.myEmail)
          .collection('tokens')
          .document(Constants.myEmail)
          .setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem
      });
    } else if (Platform.operatingSystem == 'ios') {
      print('hehe ios' + fcmToken);
      //becuase tokens is only used for push notification, it cant be used for
      //ios, hence theres always error with this, can be seen when u close app without loggin out,
      //and then going back to the app again
    }
  }

  @override
  void initState() {
    super.initState();
    _saveDeviceToken();
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
    ScreenUtil.setScreenOrientation('portrait');
    //this StreamProvider provides the list of user for WiggleList();
    return anonymous
        ? Scaffold(
            key: _scaffoldkey,
            body: anonymoustabs[_currentIndex],
            //floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
            floatingActionButton: FloatingActionButton(
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
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MaterialButton(
                          // minWidth: 40,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 0;
                            });
                          },
                          child: Icon(
                            Icons.menu,
                            color:
                                _currentIndex == 0 ? Colors.white : Colors.grey,
                          ),
                        ),
                        MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 1;
                            });
                          },
                          child: Icon(
                            Icons.chat,
                            color:
                                _currentIndex == 1 ? Colors.white : Colors.grey,
                          ),
                        )
                      ],
                    ),
                    // Right Tab bar icons
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 2;
                            });
                          },
                          child: Icon(
                            Icons.new_releases,
                            color:
                                _currentIndex == 2 ? Colors.white : Colors.grey,
                          ),
                        ),
                        MaterialButton(
                          // minWidth: 40,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 3;
                            });
                          },
                          child: Icon(
                            Icons.chat,
                            color:
                                _currentIndex == 3 ? Colors.white : Colors.grey,
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
              backgroundColor: Colors.black,
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
              color: Color(0xFF373737),
              shape: CircularNotchedRectangle(),
              notchMargin: 10,
              child: Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MaterialButton(
                          // minWidth: 40,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 0;
                            });
                          },
                          child: Icon(
                            Icons.menu,
                            color:
                                _currentIndex == 0 ? Colors.white : Colors.grey,
                          ),
                        ),
                        MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 1;
                            });
                          },
                          child: Icon(
                            Icons.chat,
                            color:
                                _currentIndex == 1 ? Colors.white : Colors.grey,
                          ),
                        )
                      ],
                    ),
                    // Right Tab bar icons
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 2;
                            });
                          },
                          child: Icon(
                            Icons.new_releases,
                            color:
                                _currentIndex == 2 ? Colors.white : Colors.grey,
                          ),
                        ),
                        MaterialButton(
                          // minWidth: 40,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 3;
                            });
                          },
                          child: Icon(
                            Icons.portrait,
                            color:
                                _currentIndex == 3 ? Colors.white : Colors.grey,
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
