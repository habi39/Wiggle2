import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  final String postId;
  final String name;
  final String timestamp;
  final String email;
  final String description;
  final dynamic likes;
  final String url;

  Post(
      {this.postId,
      this.url,
      this.description,
      this.name,
      this.timestamp,
      this.email,
      this.likes});

  factory Post.fromDocument(DocumentSnapshot documentSnapshot) {
    return Post(
        postId: documentSnapshot['postId'],
        url: documentSnapshot['url'],
        description: documentSnapshot['description'],
        timestamp: documentSnapshot['timestamp'],
        likes: documentSnapshot['likes'],
        name: documentSnapshot['name'],
        email: documentSnapshot['email']);
  }
  int getTotalNoOfLikes(likes) {
    if (likes == null) {
      return 0;
    }

    int counter = 0;
    likes.values.forEach((eachValue) {
      if (eachValue) {
        counter++;
      }
    });
    return counter;
  }

  @override
  _PostState createState() => _PostState(
        postId: postId,
        url: url,
        description: description,
        timestamp: timestamp,
        likes: getTotalNoOfLikes(likes),
        name: name,
        email: email,
      );
}

class _PostState extends State<Post> {
  final String postId;
  final String name;
  final String timestamp;
  final String email;
  final String description;
  final dynamic likes;
  final String url;

  _PostState(
      {this.postId,
      this.url,
      this.description,
      this.name,
      this.timestamp,
      this.email,
      this.likes});

  createPostHead() {
    return Text(name);
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

  createPostFooter() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            createPostHead(),
            createPostPicture(),
            // createPostFooter(),
          ],
        ));
  }
}
