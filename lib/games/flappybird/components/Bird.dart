import 'dart:ui';

import 'package:Wiggle2/games/flappybird/components/game.dart';
import 'package:Wiggle2/games/flappybird/components/pipe_spawner.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

enum BirdState { Flying, Falling }

class Bird {
  Sprite birdSprite;
  Rect currentRect;
  Rect birdRect;
  double speed = 5;
  BirdState currentState = BirdState.Falling;
  double canJump = 2000;
  double velocity = 50;
  double gravity = 100;
  bool isDead = false;
  BirdGame game;

  Bird(BirdGame game) {
    this.game = game;
    birdRect =
        Rect.fromLTWH(game.tileSize * 1.5, game.screenSize.height / 2, 50, 50);
    birdSprite = Sprite('bird.png');
    currentRect = birdRect;
  }

  void render(Canvas canvas) {
    birdSprite.renderRect(canvas, birdRect);
  }

  void update(double t, PipeSpawner pipeSpawner) {
    checkBirdIsDead(pipeSpawner, birdRect);
    if (currentState == BirdState.Flying) {
      if (birdRect.top < currentRect.top - canJump) {
        currentState = BirdState.Falling;
      } else {
        birdRect = Rect.fromLTWH(birdRect.left,
            birdRect.top - (velocity * t * 2), birdRect.width, birdRect.height);
        velocity = velocity - 3;
      }
    } else {
      birdRect = Rect.fromLTWH(birdRect.left, birdRect.top + (gravity * t * 2),
          birdRect.width, birdRect.height);
      gravity++;
    }
  }

  void onTap(TapDownDetails evt) {
    velocity = 100;
    gravity = 100;
    currentRect = birdRect;
    currentState = BirdState.Flying;
  }

  checkBirdIsDead(PipeSpawner pipeSpawner, Rect brect) {
    //print("pipeSpawner " + pipeSpawner.pipes.length.toString());
    if (brect.top >= game.screenSize.height || brect.top <= -5) {
      isDead = true;
      return;
    }
    pipeSpawner.pipes.forEach((pipe) {
      //print("brect x " + brect.right.toString());
      //print("pipe.offset.dx " + pipe.offset.dx.toString());
      if (pipe.pipeRectUp.left > 0) {
        //print("pipe.offset.dx " + pipe.offset.dx.toString());
        Rect up = brect.intersect(pipe.pipeRectUp);
        Rect down = brect.intersect(pipe.pipeRectDown);
        if ((up.width > 10 && up.height > 10) ||
            (down.width > 10 && down.height > 10)) {
          isDead = true;
        }
      }
    });
  }
}
