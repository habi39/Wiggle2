import 'package:Wiggle2/games/smashbros/smash_engine/asset.dart';

class ArenaObject extends PhysicalAsset {
  ArenaObject(String image, double width, double height, double hitboxX,
      double hitboxY, double posX, double posY) {
    // visual properties
    this.imageFile = image;
    this.width = width;
    this.height = height;
    this.posX = posX;
    this.posY = posY;
    // hitbox
    this.hitboxX = hitboxX;
    this.hitboxY = hitboxY;
  }
}

class Background extends Asset {
  Background(String image) {
    // visual propertie
    imageFile = image;
    width = 100;
    height = 100;
    posX = 50;
    posY = 50;
  }
}
