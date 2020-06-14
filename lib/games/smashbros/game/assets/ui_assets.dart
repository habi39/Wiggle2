import 'package:flutter/material.dart';
import 'package:Wiggle2/games/smashbros/game/assets/fighters_assets.dart';
import 'package:Wiggle2/games/smashbros/smash_engine/asset.dart';
import 'package:Wiggle2/games/smashbros/smash_engine/screen_util.dart';

class DamageIndicator extends Asset {
  Fighter _fighter;

  DamageIndicator(Fighter fighter, double posX, double posY) {
    this._fighter = fighter;
    this.posX = posX;
    this.posY = posY;
  }

  @override
  Widget toWidget() {
    MaterialAccentColor color;
    if (_fighter.id == Fighter.PLAYER)
      color = Colors.cyanAccent;
    else
      color = Colors.redAccent;

    return Positioned(
      left: ScreenUtil.unitWidth * posX,
      bottom: ScreenUtil.unitHeight * posY,
      child: Text(
        "P" +
            _fighter.id.toString() +
            ": " +
            _fighter.damage.toStringAsFixed(1) +
            "%",
        style: TextStyle(color: color),
      ),
    );
  }
}

class LifeIndicator extends Asset {
  Fighter _fighter;

  LifeIndicator(Fighter fighter, double posX, double posY) {
    this._fighter = fighter;
    this.posX = posX;
    this.posY = posY;
  }

  @override
  Widget toWidget() {
    MaterialAccentColor color;
    if (_fighter.id == Fighter.PLAYER)
      color = Colors.cyanAccent;
    else
      color = Colors.redAccent;

    return Positioned(
      left: ScreenUtil.unitWidth * posX,
      bottom: ScreenUtil.unitHeight * posY,
      child: Text(
        "Lifes: " + _fighter.lifes.toStringAsFixed(1),
        style: TextStyle(color: color),
      ),
    );
  }
}
