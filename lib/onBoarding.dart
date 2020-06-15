import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'screens/wrapper/wrapper.dart';

class Onboarding extends StatelessWidget {
  final pageDecoration = PageDecoration(
    pageColor: Colors.blue,
    titleTextStyle:
        PageDecoration().titleTextStyle.copyWith(color: Colors.white),
    bodyTextStyle: PageDecoration().bodyTextStyle.copyWith(color: Colors.white),
    contentPadding: const EdgeInsets.all(10),
  );

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        image: Image.asset("assets/images/ghost.png"),
        title: "Welcome to Wiggle",
        body: "Meet all your friends in your community",
        // footer: Text(
        //   "MTECHVIRAL",
        //   style: TextStyle(color: Colors.black),
        // ),

        decoration: PageDecoration(
          pageColor: Colors.pink[200],
          titleTextStyle:
              PageDecoration().titleTextStyle.copyWith(color: Colors.white),
          bodyTextStyle:
              PageDecoration().bodyTextStyle.copyWith(color: Colors.white),
          contentPadding: const EdgeInsets.all(10),
        ),
      ),
      PageViewModel(
        image: Image.asset("assets/images/ghosty.png"),
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
          pageColor: Colors.deepPurple[900],
          titleTextStyle:
              PageDecoration().titleTextStyle.copyWith(color: Colors.white),
          bodyTextStyle:
              PageDecoration().bodyTextStyle.copyWith(color: Colors.white),
          contentPadding: const EdgeInsets.all(10),
        ),
      ),
      PageViewModel(
        image: Image.asset("assets/images/text.png"),
        title: "Send Messages",
        body: "Connect with friends & exchange stories",
        // footer: Text(
        //   "MTECHVIRAL",
        //   style: TextStyle(color: Colors.black),
        // ),
        decoration: PageDecoration(
          pageColor: Colors.yellow[900],
          titleTextStyle:
              PageDecoration().titleTextStyle.copyWith(color: Colors.white),
          bodyTextStyle:
              PageDecoration().bodyTextStyle.copyWith(color: Colors.white),
          contentPadding: const EdgeInsets.all(10),
        ),
      ),
      PageViewModel(
          image: Image.asset("assets/images/gamer.png"),
          title: "Play Games",
          body: "What better way to know your friends than through games",
          // footer: Text(
          //   "MTECHVIRAL",
          //   style: TextStyle(color: Colors.black),
          // ),
          decoration: pageDecoration),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        // globalBackgroundColor: Colors.white,

        pages: getPages(),
        done: Text(
          "Let's Wiggle",
          style: TextStyle(color: Colors.white),
        ),

        // showSkipButton: true,
        onDone: () {
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
