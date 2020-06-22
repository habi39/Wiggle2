import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Wiggle2/screens/home/profileNotifier.dart';

class User {
  final String uid;

  User({this.uid});
}

class UserData {
  String email;
  String name;
  String gender;
  String block;
  String bio;
  String dp;
  String nickname;
  bool isAnonymous;
  String anonBio;
  String anonInterest;
  String anonDp;
  int fame;
  String media;
  String course;
  String playlist;
  String accoms;

  UserData(
      {this.email,
      this.name,
      this.nickname,
      this.gender,
      this.block,
      this.bio,
      this.dp,
      this.isAnonymous,
      this.anonBio,
      this.anonInterest,
      this.anonDp,
      this.fame,
      this.media,
      this.course,
      this.playlist,
      this.accoms});

  UserData.fromMap(Map<String, dynamic> data) {
    email = data['email'];
    name = data['name'];
    nickname = data['nickname'];
    gender = data['gender'];
    block = data['block'];
    bio = data['bio'];
    dp = data['dp'];
    isAnonymous = data['isAnonymous'];
    anonBio = data['anonBio'];
    anonInterest = data['anonInterest'];
    anonDp = data['anonDp'];
    fame = data['fame'];
  }
  getUserData(ProfileNotifier profileNotifier) async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection("users").getDocuments();
    List<UserData> _profileList = [];
    snapshot.documents.forEach((doc) {
      UserData data = UserData.fromMap(doc.data);
      _profileList.add(data);
    });

    profileNotifier.profileList = _profileList;
  }
}
