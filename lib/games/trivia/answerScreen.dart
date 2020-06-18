import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/models/widget.dart';
import 'package:Wiggle2/services/database.dart';

import '../../models/wiggle.dart';
import '../../screens/home/conversationScreen.dart';
import '../../screens/home/home.dart';

class AnswerScreen extends StatefulWidget {
  String triviaRoomID;
  String question;
  UserData userData;
  Wiggle wiggle;
  List<Wiggle> wiggles;

  AnswerScreen(
      {this.wiggles,
      this.userData,
      this.wiggle,
      this.triviaRoomID,
      this.question});
  @override
  _AnswerScreenState createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  String player1Text;
  String player2Text;
  String message;
  TextEditingController messageTextEditingController =
      new TextEditingController();

  getChatRoomID(String a, String b) {
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

  createChatRoomAndStartConversation(UserData userData, Wiggle wiggle) {
    String chatRoomID = getChatRoomID(userData.nickname, wiggle.nickname);
    List<String> users = [userData.email, wiggle.email];

    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatRoomId": chatRoomID
    };
    DatabaseService().createAnonymousChatRoom(chatRoomID, chatRoomMap);
  }

  sendMessage() {
    if (message.isNotEmpty) {
      createChatRoomAndStartConversation(widget.userData, widget.wiggle);

      Map<String, dynamic> questionMap = {
        "message": widget.question,
        "sendBy": widget.userData.name,
        "time": Timestamp.now(),
        "email": widget.userData.email,
        "type": 'question'
      };
      Map<String, dynamic> messageMap = {
        "message": message,
        "sendBy": widget.userData.name,
        "time": Timestamp.now(),
        "email": widget.userData.email,
        "type": 'message'
      };

      DatabaseService().addAnonymousConversationMessages(
          getChatRoomID(widget.userData.nickname, widget.wiggle.nickname),
          questionMap);
      DatabaseService().addAnonymousConversationMessages(
          getChatRoomID(widget.userData.nickname, widget.wiggle.nickname),
          messageMap);

      DatabaseService()
          .feedReference
          .document(widget.wiggle.email)
          .collection('feed')
          .add({
        'type': 'question',
        'msgInfo': widget.question,
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
        await DatabaseService(uid:wiggle.id).getReceivertoken(wiggle.email);
    String val = query.documents[0].data['token'].toString();
    DatabaseService().cloudReference.document().setData({
      'type': 'question',
      'ownerID': wiggle.email,
      'ownerName': wiggle.name,
      'timestamp': DateTime.now(),
      'userDp': widget.userData.anonDp,
      'userID': widget.userData.nickname,
      'token': val,
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Now I do"),
          elevation: 0.0,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: AutoSizeText(
                  widget.question,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: TextFormField(
                // initialValue: userData.name,
                // validator: (val) {
                //   return val.isEmpty ? 'Please provide some' : null;
                // },
                controller: messageTextEditingController,
                onChanged: (val) {
                  setState(() {
                    message = val;
                    player1Text = val;
                  });
                },
                style: TextStyle(color: Colors.white),
                decoration: textFieldInputDecoration('Your answer'),
                maxLines: 3,
              ),
            ),
            FlatButton(
              color: Colors.amber,
              child: Text(
                'Submit',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                // print(widget.userData.name);
                // print(widget.wiggle);
                sendMessage();
                DatabaseService().updateTrivia(
                    triviaRoomID: widget.triviaRoomID,
                    question: widget.question,
                    answer1: player1Text ?? null,
                    answer2: player2Text ?? null);
                // return Home(widget.userData, widget.wiggles);
                Navigator.of(context).pop(
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
