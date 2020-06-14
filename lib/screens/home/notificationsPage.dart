import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/shared/loading.dart';
import 'package:timeago/timeago.dart' as tAgo;

import '../../services/database.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<User>(context);
    DatabaseService databaseService = new DatabaseService(uid: currentUser.uid);

    retrieveNotifications(String email) async {
      QuerySnapshot querySnapshot = await databaseService.feedReference
          .document(email)
          .collection('feed')
          .orderBy('timestamp', descending: true)
          .limit(60)
          .getDocuments();

      List<NotificationsItem> notificationsItems = [];

      querySnapshot.documents.forEach((document) {
        notificationsItems.add(NotificationsItem.fromDocument(document));
      });
      return notificationsItems;
    }

    return StreamBuilder<UserData>(
        stream: databaseService.userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;
          if (userData != null) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blueGrey,
                title: Text("Notification",
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ),
              body: Container(
                child: FutureBuilder(
                    future: retrieveNotifications(userData.email),
                    builder: (context, dataSnapshot) {
                      if (!dataSnapshot.hasData) {
                        return Loading();
                      }
                      return ListView(children: dataSnapshot.data);
                    }),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}

String notificationItemText;
Widget mediaPreview;

class NotificationsItem extends StatefulWidget {
  final String type;
  final String ownerID;
  final String ownerName;
  final Timestamp timestamp;
  final String userDp;
  final String userID;
  final String msgInfo;
  final String status;
  final String senderEmail;
  final String notifID;

  NotificationsItem(
      {this.type,
      this.ownerID,
      this.ownerName,
      this.timestamp,
      this.userDp,
      this.userID,
      this.msgInfo,
      this.status,
      this.senderEmail,
      this.notifID});

  DatabaseService databaseService = new DatabaseService();

  factory NotificationsItem.fromDocument(DocumentSnapshot documentSnapshot) {
    return NotificationsItem(
        type: documentSnapshot['type'],
        ownerID: documentSnapshot['ownerID'],
        ownerName: documentSnapshot['ownerName'],
        timestamp: documentSnapshot['timestamp'],
        userDp: documentSnapshot['userDp'],
        userID: documentSnapshot['userID'],
        msgInfo: documentSnapshot['msgInfo'],
        status: documentSnapshot['status'],
        senderEmail: documentSnapshot['senderEmail'],
        notifID: documentSnapshot['notifID']);
  }
  configureMediaPreview(context) {
    mediaPreview = Text('');
    if (type == 'follow') {
      notificationItemText = 'is following you';
    } else if (type == 'message') {
      notificationItemText = 'send you a message';
    } else if (type == 'request') {
      notificationItemText = 'requested to follow you';
    } else if (type == 'compatibility') {
      notificationItemText = 'wants to do the compatibility quiz with you';
    } else if (type == 'anonmessage') {
      notificationItemText = 'send you a message (Anonymous)';
    } else if (type == 'question') {
      notificationItemText = 'wants to play trivia with you';
    } else {
      notificationItemText = 'Error, Unknown type = $type';
    }
  }

  @override
  _NotificationsItemState createState() => _NotificationsItemState();
}

class _NotificationsItemState extends State<NotificationsItem> {
  bool accepted = false;
  bool declined = false;

  @override
  void initState() {
    checkAcceptedOrDeclinedforfollow();
    checkAcceptedOrDeclinedfortictactoe();
    super.initState();
  }

  checkAcceptedOrDeclinedforfollow() {
    if (widget.type == 'request') {
      widget.databaseService.feedReference
          .document(widget.ownerID)
          .collection('feed')
          .document(widget.senderEmail)
          .get()
          .then((doc) {
        if (doc.exists) {
          if (doc.data['status'] == 'followed') {
            if (this.mounted) {
              setState(() {
                accepted = true;
              });
            }
          }
        }
      });
    }
  }

  checkAcceptedOrDeclinedfortictactoe() {
    if (widget.type == 'tictactoe') {
      widget.databaseService.feedReference
          .document(widget.ownerID)
          .collection('feed')
          .where('notifID', isEqualTo: widget.notifID)
          .where('type', isEqualTo: 'tictactoe')
          .getDocuments()
          .then((value) {
        if (value.documents[0].data['status'] == 'accepted') {
          if (this.mounted) {
            setState(() {
              accepted = true;
            });
          }
        } else if (value.documents[0].data['status'] == 'declined') {
          if (this.mounted) {
            setState(() {
              declined = true;
            });
          }
        }
      });
    }
  }

  getGameRoomID(String a, String b) {
    print(a);
    print(b);
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.configureMediaPreview(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 1.0),
      child: Container(
        color: Colors.white54,
        child: ListTile(
          title: GestureDetector(
            child: Row(
              children: <Widget>[
                RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: TextStyle(fontSize: 10.0, color: Colors.black),
                    children: [
                      TextSpan(
                          text: widget.userID,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' $notificationItemText'),
                    ],
                  ),
                ),
                SizedBox(width: 0),
                widget.type == 'request'
                    ? accepted || declined
                        ? accepted
                            ? FlatButton(
                                child: Container(
                                    height: 10.0,
                                    width: 50.0,
                                    child: Text('Accepted',
                                        style: TextStyle(fontSize: 10.0))),
                                onPressed: () {
                                  print('pressed');
                                })
                            : FlatButton(
                                child: Container(
                                    height: 10.0,
                                    width: 50.0,
                                    child: Text('Declined',
                                        style: TextStyle(fontSize: 10.0))),
                                onPressed: () {
                                  print('pressed');
                                })
                        : Column(
                            children: <Widget>[
                              FlatButton(
                                  child: Container(
                                      height: 10.0,
                                      width: 32.0,
                                      child: Text('Accept',
                                          style: TextStyle(fontSize: 10.0))),
                                  onPressed: () {
                                    if (this.mounted) {
                                      setState(() {
                                        accepted = true;
                                        notificationItemText =
                                            'is following you';
                                      });
                                    }
                                    widget.databaseService.acceptRequest(
                                        widget.ownerID,
                                        widget.ownerName,
                                        widget.userDp,
                                        widget.userID,
                                        widget.senderEmail);
                                  }),
                              FlatButton(
                                child: Container(
                                    height: 10.0,
                                    width: 35.0,
                                    child: Text('Decline',
                                        style: TextStyle(fontSize: 10.0))),
                                onPressed: () {
                                  widget.databaseService.feedReference
                                      .document(widget.ownerID)
                                      .collection('feed')
                                      .document(widget.senderEmail)
                                      .get()
                                      .then((doc) {
                                    if (doc.exists) {
                                      doc.reference.delete();
                                    }
                                  });
                                  if (this.mounted) {
                                    setState(() {
                                      declined = true;
                                    });
                                  }
                                },
                              ),
                            ],
                          )
                    : widget.type == 'tictactoe'
                        ? accepted || declined
                            ? accepted
                                ? FlatButton(
                                    child: Container(
                                        height: 10.0,
                                        width: 50.0,
                                        child: Text('Accepted',
                                            style: TextStyle(fontSize: 10.0))),
                                    onPressed: () {
                                      print('pressed');
                                    })
                                : FlatButton(
                                    child: Container(
                                        height: 10.0,
                                        width: 50.0,
                                        child: Text('Declined',
                                            style: TextStyle(fontSize: 10.0))),
                                    onPressed: () {
                                      print('pressed');
                                    })
                            : Column(
                                children: <Widget>[
                                  FlatButton(
                                      child: Container(
                                          height: 10.0,
                                          width: 32.0,
                                          child: Text('Accept',
                                              style:
                                                  TextStyle(fontSize: 10.0))),
                                      onPressed: () {
                                        //Make GAME ROOM HERE
                                        DatabaseService().updateGame(
                                            getGameRoomID(widget.ownerID,
                                                widget.senderEmail),
                                            [],
                                            []);
                                        widget.databaseService.feedReference
                                            .document(widget.ownerID)
                                            .collection('feed')
                                            .document(widget.notifID)
                                            .setData({
                                          'type': 'tictactoe',
                                          'ownerID': widget.ownerID,
                                          'ownerName': widget.ownerName,
                                          'timestamp': DateTime.now(),
                                          'userDp': widget.userDp,
                                          'userID': widget.userID,
                                          'status': 'accepted',
                                          'senderEmail': widget.senderEmail,
                                          'notifID': widget.notifID
                                        });
                                        if (this.mounted) {
                                          setState(() {
                                            accepted = true;
                                          });
                                        }
                                      }),
                                  FlatButton(
                                    child: Container(
                                        height: 10.0,
                                        width: 35.0,
                                        child: Text('Decline',
                                            style: TextStyle(fontSize: 10.0))),
                                    onPressed: () {
                                      widget.databaseService.feedReference
                                          .document(widget.ownerID)
                                          .collection('feed')
                                          .document(widget.notifID)
                                          .setData({
                                        'type': 'tictactoe',
                                        'ownerID': widget.ownerID,
                                        'ownerName': widget.ownerName,
                                        'timestamp': DateTime.now(),
                                        'userDp': widget.userDp,
                                        'userID': widget.userID,
                                        'status': 'declined',
                                        'senderEmail': widget.senderEmail,
                                        'notifID': widget.notifID
                                      });
                                      if (this.mounted) {
                                        setState(() {
                                          declined = true;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              )
                        : Container(),
              ],
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 25,
            child: ClipOval(
              child: new SizedBox(
                width: 56,
                height: 56,
                child: Image.network(
                      widget.userDp,
                      fit: BoxFit.fill,
                    ) ??
                    Image.asset('assets/images/profile1.png', fit: BoxFit.fill),
              ),
            ),
          ),
          subtitle: Text(
            tAgo.format(widget.timestamp.toDate()),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}
