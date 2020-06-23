import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Comments extends StatefulWidget {
  final String title;
  final String description;
  final String authorName;
  final UserData userData;

  Comments({this.title, this.description, this.authorName, this.userData});

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  String message;
  TextEditingController messageTextEditingController =
      new TextEditingController();
  final f = new DateFormat('h:mm a');

  ScrollController scrollController = new ScrollController();

  Stream<QuerySnapshot> chatMessagesStream;

  Widget forumList() {
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                controller: scrollController,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return CommentsTile(
                      description: widget.description,
                      message: snapshot.data.documents[index].data["message"],
                      author: snapshot.data.documents[index].data["author"],
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
        "author": widget.userData.nickname,
        "time": Timestamp.now(),
      };
      DatabaseService().addForumMessages(widget.description, messageMap);

      setState(() {
        message = "";
        messageTextEditingController.clear();
      });
    }
  }

  @override
  void initState() {
    DatabaseService().getForumMessages(widget.description).then((val) {
      setState(() {
        chatMessagesStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${widget.title}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),
          ),
          // backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: <Widget>[
            forumList(),
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
                            hintText: "Add a comment...",
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  
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
  }
}

class CommentsTile extends StatelessWidget {
  final String message;
  final String time;
  final String description;
  final String author;

  CommentsTile({this.message, this.time, this.description, this.author});

  //edit msg

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => DatabaseService()
          .blogReference
          .document(description)
          .collection('blogs')
          .where("message", isEqualTo: message)
          .getDocuments()
          .then((doc) {
        if (doc.documents[0].exists) {
          doc.documents[0].reference.delete();
        }
      }),
      child:
          // Text('$description')

          Container(
        padding: EdgeInsets.all(6),
       // width: MediaQuery.of(context).size.width,
        child: Container(
          
          child: Container(
            decoration: BoxDecoration(
            color: Color(0xFF373737),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23),
              bottomLeft: Radius.circular(23)
            ),
          ),
          padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '$author: ',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w300),
                    ),
                    Container(
                  child: Text(
                    time,
                    textAlign: TextAlign.end,
                  ),
                ),
                    
                  ],
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
    );
  }
}
