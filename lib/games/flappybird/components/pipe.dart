import 'dart:math';
import 'dart:ui';
import 'package:Wiggle2/games/flappybird/components/game.dart';
import 'package:flame/game.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';

class Pipe {
  Sprite pipeSprite;
  Rect pipeRectUp;
  Rect pipeRectDown;
  Paint pipePaint;
  Offset offset;
  Size size;
  double rangeBetweenPipes = 150;
  final Random _random = Random();

  int next(int min, int max) => min + _random.nextInt(max - min);

  Pipe(BirdGame game, Offset offset) {
    this.offset = offset;
    int upHeight = next(75, 500);
    pipeRectUp = Rect.fromLTWH(offset.dx, 0, 50, upHeight.toDouble());
    pipeRectDown = Rect.fromLTWH(
        offset.dx,
        upHeight.toDouble() + rangeBetweenPipes,
        50,
        game.screenSize.height - (upHeight.toDouble() + rangeBetweenPipes));
    pipePaint = Paint();
    pipePaint.color = Color(0xff576574);
  }

  void render(Canvas canvas) {
    canvas.drawRect(pipeRectUp, pipePaint);
    canvas.drawRect(pipeRectDown, pipePaint);
  }

  void update(double t) {
    pipeRectUp = Rect.fromLTWH(pipeRectUp.left - (t * 100), pipeRectUp.top,
        pipeRectUp.width, pipeRectUp.height);
    pipeRectDown = Rect.fromLTWH(pipeRectDown.left - (t * 100),
        pipeRectDown.top, pipeRectDown.width, pipeRectDown.height);
  }
}
