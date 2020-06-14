import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/screens/authenticate/helper.dart';
import 'package:Wiggle2/screens/home/conversationScreen.dart';
import 'package:Wiggle2/screens/home/searchScreen.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/shared/constants.dart';
import 'package:Wiggle2/shared/loading.dart';

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
String email;
String nickname;

class _AnonymousChatScreenState extends State<AnonymousChatScreen> {
  Stream chatsScreenStream;

  Widget chatRoomList(List<Wiggle> wiggles, String mynickname) {
    return StreamBuilder(
        stream: chatsScreenStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    nickname = snapshot.data.documents[index].data["chatRoomId"]
                        .toString()
                        .replaceAll("_", "")
                        .replaceFirst(mynickname, "");

                    roomid = snapshot.data.documents[index].data["chatRoomId"];

                    for (int i = 0; i < wiggles.length; i++) {
                      if (wiggles[i].nickname == nickname) {
                        currentwiggle = wiggles[i];
                      }
                    }

                    return ChatScreenTile(
                      wiggles: wiggles,
                      email: email,
                      chatRoomId: roomid,
                      currentWiggle: currentwiggle,
                    );
                  },
                )
              : Container();
        });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    // final user = Provider.of<UserData>(context);
    Constants.myEmail = await Helper.getUserEmailSharedPreference();
    Constants.myName = await Helper.getUserNameSharedPreference();

    DatabaseService().getAnonymousChatRooms(Constants.myEmail).then((val) {
      setState(() {
        chatsScreenStream = val;
        print(val);
      });
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
                backgroundColor: Colors.grey,
                title: Row(
                  children: <Widget>[
                    Text(
                      "Anonymous Chat",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 4),
                    Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      child: ClipOval(
                        child: Image.asset('assets/images/ghost.png',
                            fit: BoxFit.fill),
                      ),
                    )
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AnonymousSearch(wiggles: wiggles)));
                    },
                  ),
                ],
              ),
              body: chatRoomList(wiggles, userData.nickname),
            );
          } else {
            return Loading();
          }
        });
  }
}

class ChatScreenTile extends StatelessWidget {
  final String email;
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
    this.email,
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
        // print(snapshot.hasData);
        // print(snapshot.data['${Constants.myName} Email']);
        if (snapshot.hasData) {
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
                    ? Image.asset('assets/images/profile1.png',
                        fit: BoxFit.fill)
                    : Image.network(
                          currentWiggle.dp,
                          fit: BoxFit.fill,
                        ) ??
                        Image.asset('assets/images/profile1.png',
                            fit: BoxFit.fill),
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

          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnonymousConversation(
                      friendAnon: friendAnon,
                      wiggles: wiggles,
                      wiggle: currentWiggle,
                      chatRoomId: chatRoomId,
                      userData: userData,
                    ),
                  ));
            },
            child: Container(
              margin: EdgeInsets.only(top: 5, bottom: 5, right: 20),
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
          );
        });
  }
}
