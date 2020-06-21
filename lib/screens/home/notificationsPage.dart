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
                centerTitle: true,
                elevation: 0,
                title: Text("N O T I F I C A T I O N S",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w100)),
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
    codeUnit(String a) {
      int count = 0;
      for (int i = 0; i < a.length; i++) {
        count += a.codeUnitAt(i);
      }
      return count;
    }

    if (a.length < b.length) {
      return "$a\_$b";
    } else if (a.length > b.length) {
      return "$b\_$a";
    } else {
      print(codeUnit(a) + codeUnit(b));
      return (codeUnit(a) + codeUnit(b)).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.configureMediaPreview(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 1.0),
      child: Container(
        color: Color(0xFF212121),
        child: ListTile(
          title: GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: TextStyle(fontSize: 10.0, color: Colors.black),
                    children: [
                      TextSpan(
                          text: widget.userID,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: Colors.white)),
                      TextSpan(
                          text: ' $notificationItemText',
                          style: (TextStyle(color: Colors.white))),
                    ],
                  ),
                ),
                widget.type == 'request'
                    ? accepted || declined
                        ? accepted
                            ? InkWell(
                                child: Text('Accepted',
                                    style: TextStyle(fontSize: 10)),
                                onTap: () {
                                  print('pressed');
                                })
                            : InkWell(
                                child: Text('Declined',
                                    style: TextStyle(fontSize: 10.0)),
                                onTap: () {
                                  print('pressed');
                                })
                        : Row(
                            children: <Widget>[
                              InkWell(
                                  child: Text('Accept',
                                      style: TextStyle(fontSize: 10.0)),
                                  onTap: () {
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 13,
                              ),
                              InkWell(
                                child: Text('Decline',
                                    style: TextStyle(fontSize: 10)),
                                onTap: () {
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
                child: widget.userDp != ""
                    ? Image.network(
                        widget.userDp,
                        fit: BoxFit.cover,
                      )
                    : Image.asset('assets/images/profile1.png',
                        fit: BoxFit.cover),

                // Image.network(
                //       widget.userDp,
                //       fit: BoxFit.fill,
                //     ) ??
                //     Image.asset('assets/images/profile1.png', fit: BoxFit.fill),
              ),
            ),
          ),
          subtitle: Text(tAgo.format(widget.timestamp.toDate()),
              overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12)),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}
