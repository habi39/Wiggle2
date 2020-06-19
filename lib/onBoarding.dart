import 'package:Wiggle2/screens/home/home.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:Wiggle2/screens/authenticate/intro/introPage1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/screens/authenticate/helper.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/shared/constants.dart';
import 'package:Wiggle2/shared/loading.dart';
import 'screens/wrapper/wrapper.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final pageDecoration = PageDecoration(
    titleTextStyle:
        PageDecoration().titleTextStyle.copyWith(color: Colors.white),
    bodyTextStyle: PageDecoration().bodyTextStyle.copyWith(color: Colors.white),
    contentPadding: const EdgeInsets.all(10),
  );

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        image: Image.asset("assets/images/community.png"),
        title: "Welcome to Wiggle",
        body: "Meet all your friends in your community",
        // footer: Text(
        //   "MTECHVIRAL",
        //   style: TextStyle(color: Colors.black),
        // ),

        decoration: PageDecoration(
          titleTextStyle:
              PageDecoration().titleTextStyle.copyWith(color: Colors.white),
          bodyTextStyle:
              PageDecoration().bodyTextStyle.copyWith(color: Colors.white),
          contentPadding: const EdgeInsets.all(10),
        ),
      ),
      PageViewModel(
        image: Image.asset("assets/images/cuteghost.png"),
        title: "Stay Anonymous",
        body: "Make friends daily and start a conversation with Trivia",
        // footer: Container(
        //   width: 300,
        //   child: AutoSizeText(
        //     "Make friends daily and start a conversation with Trivia",
        //     style: TextStyle(
        //       color: Colors.white,
        //     ),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        decoration: PageDecoration(
          titleTextStyle:
              PageDecoration().titleTextStyle.copyWith(color: Colors.white),
          bodyTextStyle:
              PageDecoration().bodyTextStyle.copyWith(color: Colors.white),
          contentPadding: const EdgeInsets.all(10),
        ),
      ),
      PageViewModel(
        image: Image.asset("assets/images/converse.png"),
        title: "Send Messages",
        body: "Connect with friends & exchange stories",
        // footer: Text(
        //   "MTECHVIRAL",
        //   style: TextStyle(color: Colors.black),
        // ),
        decoration: PageDecoration(
          titleTextStyle:
              PageDecoration().titleTextStyle.copyWith(color: Colors.white),
          bodyTextStyle:
              PageDecoration().bodyTextStyle.copyWith(color: Colors.white),
          contentPadding: const EdgeInsets.all(10),
        ),
      ),
      PageViewModel(
          image: Image.asset("assets/images/gaming.png"),
          title: "Play Games",
          body: "What better way to know your friends than through games",
          // footer: Text(
          //   "MTECHVIRAL",
          //   style: TextStyle(color: Colors.black),
          // ),
          decoration: pageDecoration),
    ];
  }

 createAlertDialog() {
    final user = Provider.of<User>(context);
    final wiggles = Provider.of<List<Wiggle>>(context) ?? [];
    return showDialog(
        context: context,
        builder: (context) {
          return StreamBuilder<UserData>(
              stream: DatabaseService(uid: user.uid).userData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserData userData = snapshot.data;
                  if (userData != null) {
                    return AlertDialog(
                      title: Text('Meet a Friend'),
                      content: const Text('Who will you meet today?'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Leggoooo'),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => IntroPage1(
                                    userData: userData, wiggles: wiggles),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }
                } else {
                  Loading();
                }
              });
        });
  }
  @override
  void initState() {

    initializing();
    super.initState();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  void initializing() async {
    androidInitializationSettings =
        AndroidInitializationSettings('mipmap/ic_launcher');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void _showNotifications() async {
    await notification();
  }

  void _showNotificationsAfterSecond() async {
    await notificationAfterSec();
  }

  Future<void> notification() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'Channel ID', 'Channel title', 'channel body',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'Hello there', 'please subscribe my channel', notificationDetails);
    createAlertDialog();
  }

  Future<void> notificationAfterSec() async {
    // var timeDelayed = DateTime.now().add(Duration(seconds: 5));
    var time = new Time(21, 30, 0);
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'second channel ID', 'second Channel title', 'second channel body',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    // await flutterLocalNotificationsPlugin.schedule(1, 'Hello there',
    //     'please subscribe my channel', timeDelayed, notificationDetails);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        1, "Hello Mag", "yozza", time, notificationDetails);
  }

  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print(payLoad);
      createAlertDialog();
    }
    // we can set navigator to navigate another screen
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: IntroductionScreen(
        // globalBackgroundColor: Colors.white,
        showSkipButton: true,
        skip: Text("Skip"),
        pages: getPages(),
        done: Text(
          "Let's Wiggle",
          style: TextStyle(color: Colors.white),
        ),
        onDone: () {
          _showNotifications();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Wrapper(),
            ),
          );
        },
      ),
    );
  }
}
