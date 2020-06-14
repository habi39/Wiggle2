import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Wiggle2/games/smashbros/smash_engine/screen_util.dart';

abstract class Asset {
  // visual properties
  String imageFile = '';
  double width = 0;
  double height = 0;
  double posX = 0;
  double posY = 0;
  // animations
  int _counter = 0;
  bool _animRepeat = false;
  Map<int, String> _framesMap;
  Map<String, Map<int, String>> _animationsMap;

  Asset() {
    this._animationsMap = animationsFactory();
  }

  int get counter => _counter;

  Map<String, Map<int, String>> animationsFactory() {
    return null;
  }

  void startAnimation(String animationId, {bool repeat}) {
    if (_animationsMap != null) {
      _counter = 0;
      if (repeat != null)
        _animRepeat = repeat;
      else
        _animRepeat = false;
      _framesMap = _animationsMap[animationId];
    }
  }

  void animationCallback(int counter, bool animationEnd) {}

  Widget toWidget() {
    // animation
    if (_framesMap != null) {
      // get next frame
      String frame = _framesMap[_counter];
      if (frame != null) imageFile = frame;
      _counter++;
      // check end of animation
      if (_counter > _framesMap.keys.reduce(max)) {
        if (_animRepeat)
          _counter = 0;
        else
          _framesMap = null;
      }
      // animation callback
      animationCallback(_counter, (_framesMap == null));
    }
    // build widget
    if (imageFile != '') {
      return Positioned(
        bottom:
            ScreenUtil.unitHeight * posY - (ScreenUtil.unitHeight * height) / 2,
        left: ScreenUtil.unitWidth * posX - (ScreenUtil.unitWidth * width) / 2,
        child: Container(
          height: ScreenUtil.unitHeight * height,
          width: ScreenUtil.unitWidth * width,
          child: FittedBox(
            child: Image.asset(imageFile),
            fit: BoxFit.fill,
          ),
        ),
      );
    } else
      return Container();
  }
}

abstract class PhysicalAsset extends Asset {
  // physical properties
  static const STATIC = 0;
  static const DYNAMIC = 1;
  int type = STATIC;
  bool projectile = false;
  bool gravity = false;
  // velocities
  double velX = 0;
  double velY = 0;
  // hitboxe
  double hitboxX = 0;
  double hitboxY = 0;
  double get hitboxLeft => (posX - hitboxX / 2);
  double get hitboxRight => (posX + hitboxX / 2);
  double get hitboxTop => (posY + hitboxY / 2);
  double get hitboxBottom => (posY - hitboxY / 2);
  // airborne state
  bool isOnGround = false;

  Asset drawHitbox() {
    return Box(
        posX: posX,
        posY: posY,
        width: hitboxX,
        height: hitboxY,
        color: Colors.redAccent);
  }
}

class Box extends Asset {
  MaterialAccentColor color;

  Box(
      {@required double posX,
      @required double posY,
      @required double width,
      @required double height,
      @required MaterialAccentColor color}) {
    this.posX = ScreenUtil.unitWidth * posX;
    this.posY = ScreenUtil.unitHeight * posY;
    this.width = ScreenUtil.unitWidth * width;
    this.height = ScreenUtil.unitHeight * height;
    this.color = color;
  }

  @override
  Widget toWidget() {
    return Positioned(
      left: posX - width / 2,
      bottom: posY - height / 2,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(border: Border.all(color: color)),
      ),
    );
  }
}

abstract class GameAssets {
  List<Asset> toAssetList();
  List<PhysicalAsset> get physicalAssets;
}
