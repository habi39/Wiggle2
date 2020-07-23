import 'package:Wiggle2/screens/authenticate/intro/introPage1.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/screens/authenticate/helper.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/shared/constants.dart';
import 'package:Wiggle2/shared/loading.dart';

import '../../onBoarding.dart';
import '../../shared/constants.dart';
import 'anonymousConversation.dart';
import 'anonymousSearch.dart';

class AnonymousChatScreen extends StatefulWidget {
  @override
  _AnonymousChatScreenState createState() => _AnonymousChatScreenState();
}

final f = new DateFormat('h:mm a');
Wiggle currentwiggle;
String roomid;
String email1;
String email2;
String email;
String nickname;

class _AnonymousChatScreenState extends State<AnonymousChatScreen> {
  Stream chatsScreenStream;

  int noOfTiles;

  Widget chatRoomList(
    List<Wiggle> wiggles,
  )
  //  String mynickname)
  {
    return StreamBuilder(
        stream: chatsScreenStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    email1 = snapshot.data.documents[index].data["users"][0];
                    email2 = snapshot.data.documents[index].data["users"][1];
                    if (email1 == Constants.myEmail) {
                      email = email2;
                    } else {
                      email = email1;
                    }
                    roomid = snapshot.data.documents[index].data["chatRoomId"];

                    for (int i = 0; i < wiggles.length; i++) {
                      if (wiggles[i].email == email) {
                        currentwiggle = wiggles[i];
                      }
                    }

                    print(email);

                    return ChatScreenTile(
                      wiggles: wiggles,
                      chatRoomId: roomid,
                      currentWiggle: currentwiggle,
                    );
                  },
                )
              : Container();
        });
  }

  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  createAlertDialog() {
    final user = Provider.of<User>(context);
    final wiggles = Provider.of<List<Wiggle>>(context) ?? [];
    return showDialog(
        context: context,
        builder: (context) {
          return StreamBuilder<UserData>(
              stream: DatabaseService(uid: user.uid).userData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserData userData = snapshot.data;
                  if (userData != null) {
                    return CustomDialog(
                      title: 'Meet a Friend',
                      description: 'Who will you meet today?',
                    );
                  }
                } else {
                  return Loading();
                }
              });
        });
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  void initializing() async {
    androidInitializationSettings =
        AndroidInitializationSettings('mipmap/ic_launcher');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void _showNotifications() async {
    await notification();
  }

  void _showNotificationsAfterSecond() async {
    await notificationAfterSec();
  }

  Future<void> notification() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'Channel ID', 'Channel title', 'channel body',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'Hello there', 'please subscribe my channel', notificationDetails);
    createAlertDialog();
  }

  Future<void> notificationAfterSec() async {
    var timeDelayed = DateTime.now().add(Duration(seconds: 5));
    // var time = new Time(16, 15, 0);
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'second channel ID', 'second Channel title', 'second channel body',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.schedule(1, 'Hello there',
        'please subscribe my channel', timeDelayed, notificationDetails);
    // await flutterLocalNotificationsPlugin.showDailyAtTime(
    //     1, "Hello Mag", "yozza", time, notificationDetails);
  }

  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print(payLoad);
      createAlertDialog();
    }
    // we can set navigator to navigate another screen
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }

  @override
  void initState() {
    getUserInfo();

    initializing();
    super.initState();
  }

  getUserInfo() async {
    // final user = Provider.of<UserData>(context);
    Constants.myEmail = await Helper.getUserEmailSharedPreference();
    Constants.myName = await Helper.getUserNameSharedPreference();

    DatabaseService().getAnonymousChatRooms(Constants.myEmail).then((val) {
      setState(() {
        chatsScreenStream = val;
        // print(val);
      });
    });
    DatabaseService().getNoOfAnonChatRooms(Constants.myEmail).then((val) {
      print(val.documents.length);
      noOfTiles = val.documents.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wiggles = Provider.of<List<Wiggle>>(context) ?? [];
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;
          if (userData != null) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(LineAwesomeIcons.napster),
                    onPressed: _showNotifications),
                elevation: 0,
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "A N O N Y M O U S    C H A T",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w100),
                    ),
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        FadeRoute(page: AnonymousSearch(wiggles: wiggles)),
                        ModalRoute.withName('AnonymousSearch'),
                      );
                    },
                  ),
                ],
              ),
              body: noOfTiles == 0
                  ? Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          AutoSizeText(
                            '* Slide into DMs by clicking the + sign and be anonymous while doing so',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w300),
                          ),
                          SizedBox(height: 15),
                          AutoSizeText(
                            '** Meet a new friend daily at 9.00pm and both of you will be anonymous',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    )
                  : chatRoomList(
                      wiggles,
                      //  userData.nickname
                    ),
            );
          } else {
            return Loading();
          }
        });
  }
}

class ChatScreenTile extends StatelessWidget {
  // final String email;
  final String chatRoomId;
  final Wiggle currentWiggle;
  final List<Wiggle> wiggles;
  Stream chatMessagesStream;
  final f = new DateFormat('h:mm a');
  String latestMsg;
  String latestTime;
  bool friendAnon;
  bool myAnon;

  ChatScreenTile({
    this.wiggles,
    // this.email,
    this.chatRoomId,
    this.currentWiggle,
  });

  Widget getLatestMsg() {
    DatabaseService().getAnonymousConversationMessages(chatRoomId).then((val) {
      chatMessagesStream = val;
    });
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.documents.length - 1 < 0) {
            return Text('');
          } else {
            String msg = snapshot.data
                .documents[snapshot.data.documents.length - 1].data["message"];
            return Text(msg.length >= 20 ? '...' : msg,
                style: TextStyle(color: Colors.grey));
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget getLatestTime() {
    DatabaseService().getAnonymousConversationMessages(chatRoomId).then((val) {
      chatMessagesStream = val;
    });
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.documents.length - 1 < 0) {
            return Text('');
          } else {
            return Text(
                f
                    .format(snapshot
                        .data
                        .documents[snapshot.data.documents.length - 1]
                        .data["time"]
                        .toDate())
                    .toString(),
                style: TextStyle(color: Colors.black));
          }
        } else {
          return Container();
        }
      },
    );
  }

  Stream chatName;
  Widget getName() {
    DatabaseService().getBond(chatRoomId).then((val) {
      chatName = val;
    });
    return StreamBuilder(
      stream: chatName,
      builder: (context, snapshot) {
        // print(snapshot.data);
        if (snapshot.hasData) {
          if (currentWiggle != null) {
            friendAnon = snapshot.data['${currentWiggle.name} Anon'];
            myAnon = snapshot.data['${Constants.myName} Anon'];
            return Text(
              // friendAnon
              //     ? '${currentWiggle.nickname} *'
              //     : '${currentWiggle.name}',
              friendAnon
                  ? myAnon
                      ? '${currentWiggle.nickname} **'
                      : '${currentWiggle.nickname} *'
                  : currentWiggle.name,
              style: TextStyle(color: Colors.black),
            );
          } else {
            return Loading();
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget getDp() {
    DatabaseService().getBond(chatRoomId).then((val) {
      chatName = val;
    });
    return StreamBuilder(
      stream: chatName,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // print(chatRoomId);
          friendAnon = snapshot.data['${currentWiggle.name} Anon'];
          myAnon = snapshot.data['${Constants.myName} Anon'];
          return Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: ClipOval(
              child: new SizedBox(
                width: 180,
                height: 180,
                child: friendAnon
                    ? currentWiggle.anonDp == ''
                        ? Image.asset('assets/images/profile1.png',
                            fit: BoxFit.fill)
                        : Image.network(currentWiggle.anonDp, fit: BoxFit.fill)
                    : Image.network(
                        currentWiggle.dp,
                        fit: BoxFit.fill,
                      ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;

          return FocusedMenuHolder(
            menuWidth: MediaQuery.of(context).size.width,
            menuBoxDecoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                FadeRoute(
                  page: AnonymousConversation(
                    friendAnon: friendAnon,
                    wiggles: wiggles,
                    wiggle: currentWiggle,
                    chatRoomId: chatRoomId,
                    userData: userData,
                  ),
                ),
                ModalRoute.withName('AnonymousConversation'),
              );
            },
            menuItems: <FocusedMenuItem>[
              FocusedMenuItem(
                  title: Text(
                    "Delete Post",
                    style: TextStyle(color: Colors.black),
                  ),
                  trailingIcon: Icon(Icons.delete),
                  onPressed: () {
                    // DatabaseService()
                    //     .blogReference
                    //     .document(description)
                    //     .collection('chats')
                    //     .getDocuments()
                    //     .then((doc) {
                    //   if (doc.documents[0].exists) {
                    //     doc.documents[0].reference.delete();
                    //   }
                    // });

                    DatabaseService()
                        .anonChatReference
                        .document(chatRoomId)
                        .get()
                        .then((doc) {
                      if (doc.exists) {
                        doc.reference.delete();
                      }
                    });
                  },
                  backgroundColor: Colors.redAccent)
            ],
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  FadeRoute(
                    page: AnonymousConversation(
                      friendAnon: friendAnon,
                      wiggles: wiggles,
                      wiggle: currentWiggle,
                      chatRoomId: chatRoomId,
                      userData: userData,
                    ),
                  ),
                  ModalRoute.withName('AnonymousConversation'),
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        getDp(),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[getName(), getLatestMsg()],
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        getLatestTime(),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
