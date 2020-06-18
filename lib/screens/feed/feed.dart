import 'dart:io';

import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/screens/feed/uploadImage.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/shared/constants.dart';
import 'package:Wiggle2/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'commentsPage.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  Stream<QuerySnapshot> postsStream;
  final timelineReference = Firestore.instance.collection('posts');
  ScrollController scrollController = new ScrollController();
  Wiggle currentWiggle;

  retrieveTimeline() async {
    DatabaseService().getPosts().then((val) {
      setState(() {
        postsStream = val;
      });
    });
  }

  Widget feedList(List<Wiggle> wiggles) {
    return StreamBuilder(
      stream: postsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                controller: scrollController,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  String email = snapshot.data.documents[index]['email'];
                  String description =
                      snapshot.data.documents[index]['description'];
                  Timestamp timestamp =
                      snapshot.data.documents[index]['timestamp'];
                  String url = snapshot.data.documents[index]['url'];
                  String postId = snapshot.data.documents[index]['postId'];

                  print(email);
                  for (int i = 0; i < wiggles.length; i++) {
                    if (wiggles[i].email == email) {
                      currentWiggle = wiggles[i];
                    }
                  }

                  return FeedTile(
                    wiggle: currentWiggle,
                    wiggles: wiggles,
                    description: description,
                    timestamp: timestamp,
                    url: url,
                    postId: postId,
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    retrieveTimeline();
    super.initState();
  }

  circularProgress() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 12),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.redAccent),
      ),
    );
  }

  pickImageFromGallery(context, userData) async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadImage(file: imageFile, userData: userData),
      ),
    );
  }

  captureImageWithCamera(context, userData) async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680, maxWidth: 970);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadImage(file: imageFile, userData: userData),
      ),
    );
  }

  takeImage(nContext, userData) {
    return showDialog(
        context: nContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("New Post"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  "Capture Image with Camera",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => captureImageWithCamera(nContext, userData),
              ),
              SimpleDialogOption(
                child: Text(
                  "Select Image from Gallery",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => pickImageFromGallery(nContext, userData),
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: 869, width: 414, allowFontScaling: true);
    final wiggles = Provider.of<List<Wiggle>>(context) ?? [];
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text("F E E D",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100)),
              actions: <Widget>[
                IconButton(
                  highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                    icon: Icon(Icons.image),
                    onPressed: () {
                      takeImage(context, userData);
                    }),
              ],
            ),
            body: feedList(wiggles),
          );
          // RefreshIndicator(
          //     child: createTimeLine(), onRefresh: () => retrieveTimeline()));
        });
  }
}

class FeedTile extends StatelessWidget {
  final Wiggle wiggle;
  final List<Wiggle> wiggles;
  final f = new DateFormat('h:mm a');
  final Timestamp timestamp;
  final String description;
  final String url;
  final String postId;
  bool check;

  FeedTile({
    this.wiggles,
    this.wiggle,
    this.timestamp,
    this.description,
    this.url,
    this.postId,
  });

  createPostHead(context, UserData userData) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          CircleAvatar(
            radius: 18,
            child: ClipOval(
              child: SizedBox(
                width: 180,
                height: 180,
                child: Image.network(
                  wiggle.dp,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 5),
          Text(
            '${wiggle.name}',
            style: kTitleTextStyle,
          ),
          Spacer(),
          check
              ? IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: () => createAlertDialog(context),
                )
              : Text('')
        ],
      ),
    );
  }

  createAlertDialog(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Are you sure you want to delete post?'),
            actions: <Widget>[
              FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    DatabaseService()
                        .postReference
                        .document(postId)
                        .get()
                        .then((doc) {
                      if (doc.exists) {
                        doc.reference.delete();

                        Navigator.pop(context);
                      }
                    });
                  }),
            ],
          );
        });
  }

  createPostPicture() {
    return GestureDetector(
      onDoubleTap: () => print('like'),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[Image.network(url)],
      ),
    );
  }

  createPostFooter(context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        CircleAvatar(
          radius: 18,
          child: ClipOval(
            child: SizedBox(
              width: 180,
              height: 180,
              child: Image.network(
                wiggle.dp,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(width: 5),
        Text(
          '${wiggle.name}',
          style: kTitleTextStyle,
        ),
        SizedBox(width: 5),
        description.length <= 18
            ? Text('$description')
            : FlatButton(
                child: Text('more...'),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      FadeRoute(
                        page: CommentsPage(
                            wiggle: wiggle, description: description),
                      ),
                      ModalRoute.withName('CommentsPage'));
                },
              ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Text('${f.format(timestamp.toDate())}'),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;
          check = Constants.myEmail == wiggle.email;
          return GestureDetector(
            onTap: () {
              // Navigator.of(context).pushAndRemoveUntil(
              //     FadeRoute(
              //       page: ConversationScreen(
              //         wiggles: wiggles,
              //         wiggle: wiggle,
              //         userData: userData,
              //       ),
              //     ),
              //     ModalRoute.withName('ConversationScreen'));
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  createPostHead(context, userData),
                  createPostPicture(),
                  SizedBox(
                    height: 10,
                  ),
                  createPostFooter(context),
                ],
              ),
            ),
          );
        });
  }
}
