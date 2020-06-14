import 'package:flutter/material.dart';
import 'package:Wiggle2/games/smashbros/smash_engine/gesture.dart';
import 'package:Wiggle2/games/smashbros/smash_engine/screen_util.dart';

class InputGesturesFactory {
  static List<InputGesture> build(int inputGesturesId) {
    switch (inputGesturesId) {
      case 0:
        return inputs();
      default:
        return List();
    }
  }

  static List<InputGesture> inputs() {
    List<InputGesture> inputGestures = List();
    inputGestures.add(ButtonLeft());
    inputGestures.add(ButtonRight());
    inputGestures.add(ButtonUp());
    inputGestures.add(ButtonA());
    inputGestures.add(ButtonB());
    inputGestures.add(ButtonFireball());
    return inputGestures;
  }
}

class CircularButton extends StatelessWidget {
  final IconData iconData;
  final String text;

  CircularButton({this.iconData, @required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.unitHeight * 14,
      height: ScreenUtil.unitHeight * 14,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment(0.0, 0.0),
        children: [
          Icon(
            iconData,
            color: Colors.white,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ButtonLeft extends InputGesture {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: ScreenUtil.unitHeight * 7,
      left: ScreenUtil.unitWidth * 7,
      child: GestureDetector(
        onTapDown: (details) {
          this.pushInput(context, "press_left_start");
        },
        onTapCancel: () {
          this.pushInput(context, "press_left_end");
        },
        onTapUp: (details) {
          this.pushInput(context, "press_left_end");
        },
        child: Container(
          height: ScreenUtil.unitHeight * 13,
          width: ScreenUtil.unitWidth * 9,
          child: FittedBox(
            child: Image.asset('assets/images/buttons/leftbutton.png'),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class ButtonRight extends InputGesture {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: ScreenUtil.unitHeight * 7,
        left: ScreenUtil.unitWidth * 19,
        child: GestureDetector(
          onTapDown: (details) {
            this.pushInput(context, "press_right_start");
          },
          onTapCancel: () {
            this.pushInput(context, "press_right_end");
          },
          onTapUp: (details) {
            this.pushInput(context, "press_right_end");
          },
          child: Container(
            height: ScreenUtil.unitHeight * 13,
            width: ScreenUtil.unitWidth * 9,
            child: FittedBox(
              child: Image.asset('assets/images/buttons/rightbutton.png'),
              fit: BoxFit.fill,
            ),
          ),
        ));
  }
}

class ButtonUp extends InputGesture {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: ScreenUtil.unitHeight * 24,
        left: ScreenUtil.unitWidth * 86,
        child: GestureDetector(
          onTapDown: (details) {
            this.pushInput(context, "press_up");
          },
          child: Container(
            height: ScreenUtil.unitHeight * 13,
            width: ScreenUtil.unitWidth * 9,
            child: FittedBox(
              child: Image.asset('assets/images/buttons/jumpbutton.png'),
              fit: BoxFit.fill,
            ),
          ),
        ));
  }
}

class ButtonA extends InputGesture {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: ScreenUtil.unitHeight * 7,
      left: ScreenUtil.unitWidth * 62,
      child: GestureDetector(
        onTapDown: (details) {
          this.pushInput(context, "press_a");
        },
        /*onLongPress: () {
          this.pushInput(context, "long_press_a");
        },*/
        child: Container(
          height: ScreenUtil.unitHeight * 13,
          width: ScreenUtil.unitWidth * 9,
          child: FittedBox(
            child: Image.asset('assets/images/buttons/abutton.png'),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class ButtonB extends InputGesture {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: ScreenUtil.unitHeight * 7,
      left: ScreenUtil.unitWidth * 74,
      child: GestureDetector(
        onTapDown: (details) {
          this.pushInput(context, "long_press_a");
        },
        /*onTapDown: (details) {
          this.pushInput(context, "press_b_start");
        },
        onTapCancel: () {
          this.pushInput(context, "press_b_end");
        },
        onTapUp: (details) {
          this.pushInput(context, "press_b_end");
        },*/
        child: Container(
          height: ScreenUtil.unitHeight * 13,
          width: ScreenUtil.unitWidth * 9,
          child: FittedBox(
            child: Image.asset('assets/images/buttons/bbutton.png'),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class ButtonFireball extends InputGesture {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: ScreenUtil.unitHeight * 7,
      left: ScreenUtil.unitWidth * 86,
      child: GestureDetector(
        onTapDown: (details) {
          this.pushInput(context, "press_fireball");
        },
        child: Container(
          height: ScreenUtil.unitHeight * 13,
          width: ScreenUtil.unitWidth * 9,
          child: FittedBox(
            child: Image.asset('assets/images/buttons/fireballbutton.png'),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
