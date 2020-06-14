import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Wiggle2/screens/home/searchScreen.dart';
import 'package:Wiggle2/screens/home/secretAnonChat.dart/susConversationScreen.dart';
import 'package:Wiggle2/shared/constants.dart';
import 'package:Wiggle2/screens/authenticate/helper.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/screens/home/conversationScreen.dart';
import 'package:provider/provider.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/models/wiggle.dart';

class SusChat extends StatefulWidget {
  @override
  _SusChatState createState() => _SusChatState();
}

final f = new DateFormat('h:mm a');
String email;
Wiggle currentwiggle;
String roomid;

class _SusChatState extends State<SusChat> {
  Stream chatsScreenStream;

  Widget chatRoomList(List<Wiggle> wiggles) {
    return StreamBuilder(
        stream: chatsScreenStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    email = snapshot.data.documents[index].data["chatRoomId"]
                        .toString()
                        .replaceAll("_", "")
                        .replaceFirst(Constants.myEmail, "");

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
    Constants.myEmail = await Helper.getUserEmailSharedPreference();
    Constants.myName = await Helper.getUserNameSharedPreference();
    DatabaseService().getSusChatRooms(Constants.myEmail).then((val) {
      setState(() {
        chatsScreenStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final wiggles = Provider.of<List<Wiggle>>(context) ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: Text("Sus Chat",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.add),
        //     onPressed: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => SearchScreen(wiggles: wiggles)));
        //     },
        //   ),
        // ],
      ),
      body: chatRoomList(wiggles),
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
    DatabaseService().getSusConversationMessages(chatRoomId).then((val) {
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
    DatabaseService().getSusConversationMessages(chatRoomId).then((val) {
      chatMessagesStream = val;
    });
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.documents.length - 1 < 0) {
            return Text('');
          } else {
            return Text(f
                .format(snapshot.data
                    .documents[snapshot.data.documents.length - 1].data["time"]
                    .toDate())
                .toString());
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
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SusConversationScreen(
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
                      Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: ClipOval(
                          child: new SizedBox(
                            width: 180,
                            height: 180,
                            child: Image.asset('assets/images/profile1.png',
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            currentWiggle.nickname,
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
