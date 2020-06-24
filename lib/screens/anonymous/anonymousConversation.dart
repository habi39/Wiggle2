import 'package:Wiggle2/screens/wrapper/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:Wiggle2/games/compatibility.dart/compatibilityStart.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/screens/anonymous/anonothersProfile.dart';
import 'package:Wiggle2/screens/home/othersProfile.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/shared/constants.dart';
import 'package:Wiggle2/shared/loading.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:Wiggle2/screens/home/home.dart';

class AnonymousConversation extends StatefulWidget {
  final bool friendAnon;
  final String chatRoomId;
  final Wiggle wiggle;
  final List<Wiggle> wiggles;
  final UserData userData;

  AnonymousConversation(
      {this.friendAnon,
      this.wiggles,
      this.chatRoomId,
      this.wiggle,
      this.userData});

  @override
  _AnonymousConversationState createState() => _AnonymousConversationState();
}

final f = new DateFormat('h:mm a');

class _AnonymousConversationState extends State<AnonymousConversation> {
  String message;
  TextEditingController messageTextEditingController =
      new TextEditingController();

  ScrollController scrollController = new ScrollController();

  Stream<QuerySnapshot> chatMessagesStream;

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                controller: scrollController,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      roomId: widget.chatRoomId,
                      type: snapshot.data.documents[index].data["type"],
                      message: snapshot.data.documents[index].data["message"],
                      isSendByMe:
                          snapshot.data.documents[index].data["email"] ==
                              Constants.myEmail,
                      time: f
                          .format(snapshot.data.documents[index].data["time"]
                              .toDate())
                          .toString());
                })
            : Container();
      },
    );
  }

  sendMessage() {
    if (message.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": message,
        "sendBy": Constants.myName,
        "time": Timestamp.now(),
        "email": Constants.myEmail,
        "type": 'message'
      };
      DatabaseService()
          .addAnonymousConversationMessages(widget.chatRoomId, messageMap);
      DatabaseService()
          .feedReference
          .document(widget.wiggle.email)
          .collection('feed')
          .add({
        'type': 'anonmessage',
        'msgInfo': message,
        'ownerID': widget.wiggle.email,
        'ownerName': widget.wiggle.name,
        'timestamp': DateTime.now(),
        'userDp': widget.userData.anonDp,
        'userID': widget.userData.nickname,
      });

      setState(() {
        saveReceivercloud(widget.wiggle);
        message = "";
        messageTextEditingController.clear();
      });
    }
  }

  saveReceivercloud(Wiggle wiggle) async {
    QuerySnapshot query =
        await DatabaseService(uid: wiggle.id).getReceivertoken(wiggle.email);
    String val = query.documents[0].data['token'].toString();
    DatabaseService().cloudReference.document().setData({
      'type': 'anonmessage',
      'ownerID': wiggle.email,
      'ownerName': wiggle.name,
      'timestamp': DateTime.now(),
      'userDp': widget.userData.anonDp,
      'userID': widget.userData.nickname,
      'token': val,
    });
  }

  @override
  void initState() {
    DatabaseService()
        .getAnonymousConversationMessages(widget.chatRoomId)
        .then((val) {
      setState(() {
        chatMessagesStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        UserData userData = snapshot.data;
        if (userData != null) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              resizeToAvoidBottomPadding: true,
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(LineAwesomeIcons.home),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          FadeRoute(page: Wrapper()),
                          ModalRoute.withName('Wrapper'));
                    }),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 23,
                      child: ClipOval(
                        child: SizedBox(
                          width: 180,
                          height: 180,
                          child: widget.friendAnon
                              ? widget.wiggle.anonDp == ''
                                  ? Image.asset('assets/images/profile1.png',
                                      fit: BoxFit.fill)
                                  : Image.network(widget.wiggle.anonDp,
                                      fit: BoxFit.fill)
                              : Image.network(
                                  widget.wiggle.dp,
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      child: Text(
                        widget.friendAnon
                            ? '${widget.wiggle.nickname} *'
                            : widget.wiggle.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            FadeRoute(
                              page: widget.friendAnon
                                  ? AnonOthersProfile(wiggle: widget.wiggle)
                                  : OthersProfile(
                                      wiggles: widget.wiggles,
                                      wiggle: widget.wiggle,
                                      userData: userData,
                                    ),
                            ),
                            ModalRoute.withName('void'));
                      },
                    ),
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.gamepad),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          FadeRoute(
                            page: CompatibilityStart(
                                friendAnon: widget.friendAnon,
                                userData: widget.userData,
                                wiggle: widget.wiggle,
                                wiggles: widget.wiggles),
                          ),
                          ModalRoute.withName('CompatibilityStart'));
                    },
                  ),
                ],
              ),
              body: Stack(
                children: <Widget>[
                  chatMessageList(),
                  // Divider(height: 2),
                  Container(
                    alignment: Alignment.bottomCenter,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Expanded(
                            child: TextFormField(
                              controller: messageTextEditingController,
                              onChanged: (val) {
                                setState(() => message = val);
                                Future.delayed(Duration(milliseconds: 100), () {
                                  scrollController.animateTo(
                                      scrollController.position.maxScrollExtent,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.ease);
                                });
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration.collapsed(
                                  hintText: "Send a message...",
                                  hintStyle: TextStyle(color: Colors.white54),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            sendMessage();
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            padding: EdgeInsets.all(12),
                            child: Image.asset('assets/images/send.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  final String time;
  final String type;
  final String roomId;

  MessageTile(
      {this.message, this.isSendByMe, this.time, this.type, this.roomId});

  //edit msg

  @override
  Widget build(BuildContext context) {
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
      onPressed: () {},
      menuItems: <FocusedMenuItem>[
        FocusedMenuItem(
            title: Text(
              "Delete Post",
              style: TextStyle(color: Colors.black),
            ),
            trailingIcon: Icon(Icons.delete),
            onPressed: () {
              DatabaseService()
                  .anonChatReference
                  .document(roomId)
                  .collection('chats')
                  .where("message", isEqualTo: message)
                  .getDocuments()
                  .then((doc) {
                if (doc.documents[0].exists) {
                  doc.documents[0].reference.delete();
                }
              });
            },
            backgroundColor: Colors.redAccent)
      ],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        onDoubleTap: () => DatabaseService()
            .anonChatReference
            .document(roomId)
            .collection('chats')
            .where("message", isEqualTo: message)
            .getDocuments()
            .then((doc) {
          if (doc.documents[0].exists) {
            doc.documents[0].reference.delete();
          }
        }),
        child: Container(
          padding: EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: isSendByMe ? 0 : 24,
              right: isSendByMe ? 24 : 0),
          alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          child: Container(
            margin: isSendByMe
                ? EdgeInsets.only(left: 30)
                : EdgeInsets.only(right: 30),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: (type == 'message')
                  ? (isSendByMe ? Colors.blueGrey : Colors.indigoAccent)
                  : Colors.red,
              borderRadius: isSendByMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomLeft: Radius.circular(23),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomRight: Radius.circular(23),
                    ),
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: isSendByMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      time,
                      textAlign: TextAlign.end,
                    ),
                  ),
                  Text(
                    message,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
