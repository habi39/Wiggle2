import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'fly.dart';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flame/gestures.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   Util flameUtil = Util();
//   await Flame.util.fullScreen();
//   await Flame.util.setOrientation(DeviceOrientation.portraitUp);
//   LangawGame game = LangawGame();
//   runApp(game.widget);

//   TapGestureRecognizer tapper = TapGestureRecognizer();
//   tapper.onTapDown = game.onTapDown;
// }

class LangawGame extends Game with TapDetector {
  Size screenSize;
  double tileSize;
  List<Fly> flies;
  Random rnd;

  LangawGame() {
    initialize();
  }

  void initialize() async {
    flies = List<Fly>();
    rnd = Random();
    resize(await Flame.util.initialDimensions());
    spanFly();
  }

  void spanFly() {
    double x = rnd.nextDouble() * (screenSize.width - tileSize);
    double y = rnd.nextDouble() * (screenSize.width - tileSize);
    flies.add(Fly(this, x, y));
  }

  @override
  void render(Canvas canvas) {
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xff576574);
    canvas.drawRect(bgRect, bgPaint);

    flies.forEach((Fly fly) => fly.render(canvas));

    String text = flies.length.toString(); // text to render
    ParagraphBuilder paragraph = new ParagraphBuilder(new ParagraphStyle());
    // paragraph
    //     .pushStyle(TextStyle(color: Color(0xFFFFFFFF), fontSize: 48.0));
    paragraph.addText(text);
    var p = paragraph.build()..layout(new ParagraphConstraints(width: 180.0));
    canvas.drawParagraph(
        p,
        new Offset(screenSize.width - p.width - 20,
            screenSize.height - p.height - 700));
  }

  @override
  void update(double t) {
    flies.forEach((Fly fly) => fly.update(t));
    // flies.removeWhere((Fly fly) => fly.isOffScreen == true);
  }

  @override
  void resize(Size size) {
    super.resize(size);
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  void onTapDown(TapDownDetails d) {
    print(flies.length);
    flies.forEach((Fly fly) {
      if (fly.flyRect.contains(d.globalPosition)) {
        fly.onTapDown();
      }
    });
  }
}
