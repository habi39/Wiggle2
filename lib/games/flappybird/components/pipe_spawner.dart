import 'dart:ui';

import 'package:Wiggle2/games/flappybird/components/pipe.dart';

import 'Bird.dart';
import 'game.dart';

class PipeSpawner {
  double pipeNumber = 10;
  List<Pipe> pipes = List();
  double speed = 100;
  BirdGame _birdGame;
  double distanceBetweenPipes = 100;
  double time = 0;

  PipeSpawner(BirdGame game) {
    _birdGame = game;
  }

  void create() {
    if (pipes.length == 0) {
      pipes.add(Pipe(_birdGame,
          Offset(_birdGame.screenSize.width + 100 + distanceBetweenPipes, 0)));
    } else
      pipes.add(Pipe(
          _birdGame, Offset(pipes.last.offset.dx + distanceBetweenPipes, 0)));
  }

  void render(Canvas canvas) {
    pipes.forEach((p) {
      p.render(canvas);
    });
  }

  void update(double t) {
    time = time + t * 1000;
    //print(time);
    if (time > 1000) {
      create();
      time = time - 1000;
    }
    pipes.forEach((p) {
      p.update(t);
    });
  }
}
