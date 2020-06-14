import 'dart:ui';
import 'package:Wiggle2/games/flappybird/components/game.dart';
import 'package:Wiggle2/games/flappybird/components/pipe_spawner.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

import 'Bird.dart';

class Score {
  Paragraph paragraph;
  ParagraphBuilder paragraphBuilder;
  final ParagraphStyle paragraphStyle =
      ParagraphStyle(textAlign: TextAlign.center, maxLines: 1);
  final TextStyle textStyle = TextStyle(color: Color(0xff114174), fontSize: 75);
  Offset offset;
  int score = 0;
  Bird bird;
  BirdGame birdGame;

  Score(BirdGame game) {
    birdGame = game;
    //offset = Offset(game.tileSize * 5, game.tileSize * 2);
  }

  void render(Canvas canvas) {
    paragraphBuilder = ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText(score.toString());
    paragraph = paragraphBuilder.build()
      ..layout(ParagraphConstraints(width: 100));
    offset = Offset(birdGame.screenSize.width / 2 - paragraph.width / 2,
        birdGame.tileSize * 2);
    canvas.drawParagraph(paragraph, offset);
  }

  void update(double t, Bird bird, PipeSpawner pipeSpawner) {
    score = 0;
    pipeSpawner.pipes.forEach((pipe) {
      if (pipe.pipeRectUp.right < bird.birdRect.left) score++;
    });
  }
}
