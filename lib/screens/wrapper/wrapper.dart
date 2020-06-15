import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wiggle2/screens/authenticate/authenticate.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/services/database.dart';
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
    
    

    
     

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
