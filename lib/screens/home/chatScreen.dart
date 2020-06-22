import 'dart:io';

import 'package:Wiggle2/screens/authenticate/intro/introPage1.dart';
import 'package:Wiggle2/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:Wiggle2/screens/home/searchScreen.dart';
import 'package:Wiggle2/shared/constants.dart';
import 'package:Wiggle2/screens/authenticate/helper.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/screens/home/conversationScreen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/models/wiggle.dart';

import 'notificationsPage.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

final f = new DateFormat('h:mm a');
String email;
Wiggle currentwiggle;
String roomid;
String email1;
String email2;

class _ChatsScreenState extends State<ChatScreen> {
  //snapshots returns a stream
  Stream chatsScreenStream;
  int noOfTiles;

  Widget chatRoomList(List<Wiggle> wiggles) {
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

                    return chatScreenTile(
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
    DatabaseService().getChatRooms(Constants.myEmail).then((val) {
      setState(() {
        chatsScreenStream = val;
      });
    });
    DatabaseService().getNoOfChatRooms(Constants.myEmail).then((val) {
      print(val.documents.length);
      noOfTiles = val.documents.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wiggles = Provider.of<List<Wiggle>>(context) ?? [];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text("C H A T",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100)),
        actions: <Widget>[
          IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                FadeRoute(page: SearchScreen(wiggles: wiggles)),
                ModalRoute.withName('SearchScreen'),
              );
            },
          ),
        ],
      ),
      body: noOfTiles == 0
          ? Center(
              child: Text(
                'Talk to a friend by clicking the + icon',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
            )
          : chatRoomList(wiggles),
    );
  }
}

class chatScreenTile extends StatelessWidget {
  final String email;
  final String chatRoomId;
  final Wiggle currentWiggle;
  final List<Wiggle> wiggles;
  Stream chatMessagesStream;
  final f = new DateFormat('h:mm a');
  String latestMsg;
  String latestTime;

  chatScreenTile({
    this.wiggles,
    this.email,
    this.chatRoomId,
    this.currentWiggle,
  });

  Widget getLatestMsg() {
    DatabaseService().getConversationMessages(chatRoomId).then((val) {
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
    DatabaseService().getConversationMessages(chatRoomId).then((val) {
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
                  page: ConversationScreen(
                    wiggles: wiggles,
                    wiggle: currentWiggle,
                    chatRoomId: chatRoomId,
                    userData: userData,
                  ),
                ),
                ModalRoute.withName('ConversationScreen'),
              );
            },
            menuItems: <FocusedMenuItem>[
              FocusedMenuItem(
                  title: Text(
                    "Delete Chat",
                    style: TextStyle(color: Colors.black),
                  ),
                  trailingIcon: Icon(Icons.delete),
                  onPressed: () {
                    DatabaseService()
                        .chatReference
                        .document(chatRoomId)
                        .collection('chats')
                        .getDocuments()
                        .then((doc) {
                      if (doc.documents[0].exists) {
                        doc.documents[0].reference.delete();
                      }
                    });

                    DatabaseService()
                        .chatReference
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
                      Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(30)),
                        child: ClipOval(
                          child: new SizedBox(
                            width: 180,
                            height: 180,
                            child: Image.network(
                                  currentWiggle.dp,
                                  fit: BoxFit.fill,
                                ) ??
                                Image.asset('assets/images/profile1.png',
                                    fit: BoxFit.fill),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            currentWiggle.name,
                            style: TextStyle(color: Colors.black),
                          ),
                          getLatestMsg()
                        ],
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
