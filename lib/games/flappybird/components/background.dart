import 'dart:ui';
import 'package:Wiggle2/games/flappybird/components/game.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

class Background {
  Sprite bgSprite;
  Rect bgRect;
  Paint bgPaint;

  Background(BirdGame game) {
    bgRect = Rect.fromLTWH(
      0,
      0,
      game.screenSize.width * 2.5,
      game.screenSize.height,
    );
    bgSprite = Sprite('bg.png');
  }

  void render(Canvas canvas) {
    bgSprite.renderRect(canvas, bgRect);
  }
}
