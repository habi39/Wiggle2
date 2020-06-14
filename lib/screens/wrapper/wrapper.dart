import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wiggle2/screens/authenticate/authenticate.dart';
import 'package:Wiggle2/screens/authenticate/intro/introPage1.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/shared/constants.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  DatabaseService databaseService = DatabaseService();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  FirebaseMessaging fcm = FirebaseMessaging();
  bool firstlog = true;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final wiggles = Provider.of<List<Wiggle>>(context) ?? [];
    
    _saveDeviceToken() async {
      String fcmToken = await fcm.getToken();
      if (fcmToken != null) {
        var tokenRef = Firestore.instance
            .collection('users')
            .document(Constants.myEmail)
            .collection('tokens')
            .document(Constants.myEmail);

        await tokenRef.setData({
          'token': fcmToken,
          'createdAt': FieldValue.serverTimestamp(),
          'platform': Platform.operatingSystem
        });
      }
    }

    // _saveDeviceToken();

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
