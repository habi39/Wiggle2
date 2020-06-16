import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/screens/feed/post.dart';
import 'package:Wiggle2/screens/feed/uploadImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  final UserData userData;
  Feed({this.userData});

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  List<Post> posts;
  final timelineReference = Firestore.instance.collection('posts');

  retrieveTimeline() async {
    QuerySnapshot querySnapshot = await timelineReference
        .orderBy("timestamp", descending: true)
        .getDocuments();

    List<Post> allPosts = querySnapshot.documents
        .map((document) => Post.fromDocument(document))
        .toList();

    setState(() {
      posts = allPosts;
    });
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

  createTimeLine() {
    print(posts);
    if (posts == null) {
      return circularProgress();
    } else {
      return ListView(children: posts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("Feed",
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.image),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UploadImage(userData: widget.userData),
                  ),
                );
              }),
        ],
      ),
      body: createTimeLine(),
    );
  }
}
