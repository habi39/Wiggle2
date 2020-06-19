import 'package:flutter/material.dart';
import 'package:Wiggle2/screens/wrapper/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:Wiggle2/services/auth.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/shared/constants.dart';

import 'onBoarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firestore.instance.settings(timestampsInSnapshotsEnabled: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Wiggle>>.value(
      value: DatabaseService().wiggles,
      child: StreamProvider<User>.value(
        value: AuthService().user,
        child: MaterialApp(
          title: 'Wiggle',
          debugShowCheckedModeBanner: false,

          theme: kDarkTheme,

          // theme: ThemeData(
          //   brightness: Brightness.light,
          //   primaryColor: Colors.black,
          //   scaffoldBackgroundColor: Color.fromRGBO(3, 9, 23, 1),
          //   textTheme: TextTheme(
          //     headline4: TextStyle(
          //         color: Colors.white,
          //         fontSize: 40,
          //         fontWeight: FontWeight.bold),
          //     button: TextStyle(color: Colors.blueGrey),
          //     headline5:
          //         TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
          //   ),
          // ),
          home: Wrapper(),
          // Wrapper(),
        ),
      ),
    );
  }
}
