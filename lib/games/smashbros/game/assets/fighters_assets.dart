import 'package:flutter/material.dart';
import 'package:Wiggle2/games/smashbros/smash_engine/asset.dart';

abstract class Fighter extends PhysicalAsset {
  // id
  static const int PLAYER = 1;
  static const int OPPONENT = 2;
  int id = 0;

  // physical properties
  int type = PhysicalAsset.DYNAMIC;
  bool gravity = true;

  // motion
  static const int RIGHT = 0;
  static const int LEFT = 1;
  int orientation = RIGHT;
  bool _isMoving = false;
  int _jumpCounter = 0;
  bool _isHit = false;
  bool _isEject = false;
  bool _isBlocking = false;

  // actions
  int _currAction = _A_NONE;
  static const int _A_NONE = 0;
  static const int _A_MOVE = 1;
  static const int _A_JUMP = 2;
  static const int _A_BASIC_ATTACK = 3;
  static const int _A_SMASH_ATTACK = 4;
  static const int _A_BLOCK = 5;
  static const int _A_FIREBALL = 6;
  static const int _A_STUN = 7;

  // respawn
  double respawnPosX = 0;
  double respawnPosY = 0;

  // damage
  double damage = 0;
  int lifes = 3;

  // basic attack
  double _hurtBasicOffsetX = 0;
  double hurtBasicOffsetY = 0;
  double _hurtBasicX = 0;
  double _hurtBasicY = 0;
  int basicAttCounterMin = 0;
  int basicAttCounterMax = 0;

  // smash attack
  double _hurtSmashOffsetX = 0;
  double hurtSmashOffsetY = 0;
  double _hurtSmashX = 0;
  double _hurtSmashY = 0;
  int smashAttCounterMin = 0;
  int smashAttCounterMax = 0;

  // fireball timing
  int fireballCounterValue = 0;

  double get hurtBasicOffsetX {
    if (orientation == LEFT) return -1 * _hurtBasicOffsetX;
    return _hurtBasicOffsetX;
  }

  double get hurtBasicX {
    if (_currAction == _A_BASIC_ATTACK)
      return _hurtBasicX;
    else
      return 0;
  }

  double get hurtBasicY {
    if (_currAction == _A_BASIC_ATTACK)
      return _hurtBasicY;
    else
      return 0;
  }

  double get hurtBasicLeft => (posX + hurtBasicOffsetX - hurtBasicX / 2);
  double get hurtBasicRight => (posX + hurtBasicOffsetX + hurtBasicX / 2);
  double get hurtBasicTop => (posY + hurtBasicOffsetY + hurtBasicY / 2);
  double get hurtBasicBottom => (posY + hurtBasicOffsetY - hurtBasicY / 2);

  double get hurtSmashOffsetX {
    if (orientation == LEFT) return -1 * _hurtSmashOffsetX;
    return _hurtSmashOffsetX;
  }

  double get hurtSmashX {
    if (_currAction == _A_SMASH_ATTACK)
      return _hurtSmashX;
    else
      return 0;
  }

  double get hurtSmashY {
    if (_currAction == _A_SMASH_ATTACK)
      return _hurtSmashY;
    else
      return 0;
  }

  double get hurtSmashLeft => (posX + hurtSmashOffsetX - hurtSmashX / 2);
  double get hurtSmashRight => (posX + hurtSmashOffsetX + hurtSmashX / 2);
  double get hurtSmashTop => (posY + hurtSmashOffsetY + hurtSmashY / 2);
  double get hurtSmashBottom => (posY + hurtSmashOffsetY - hurtSmashY / 2);

  List<Asset> drawHurtboxes() {
    List<Asset> hurtboxes = List();
    // basic attack
    hurtboxes.add(Box(
      posX: posX + hurtBasicOffsetX,
      posY: posY + hurtBasicOffsetY,
      width: hurtBasicX,
      height: hurtBasicY,
      color: Colors.blueAccent,
    ));
    // smash attack
    hurtboxes.add(Box(
      posX: posX + hurtSmashOffsetX,
      posY: posY + hurtSmashOffsetY,
      width: hurtSmashX,
      height: hurtSmashY,
      color: Colors.blueAccent,
    ));
    return hurtboxes;
  }

  @override
  void animationCallback(int counter, bool animationEnd) {
    if ((animationEnd == true)) {
      if (_isHit) _isHit = false;
      if (_isEject) _isEject = false;
      if (_isBlocking) block();
      if (_isMoving && _currAction != _A_BLOCK) {
        _currAction = _A_MOVE;
        move(orientation);
      } else if (_currAction != _A_BLOCK) {
        _currAction = _A_NONE;
        if (orientation == LEFT)
          startAnimation("idle_left");
        else
          startAnimation("idle_right");
      }
    }
  }

  void move(int direction) {
    if (_currAction != _A_BLOCK && _currAction != _A_STUN) {
      // can't move if blocking
      if (_currAction == _A_NONE) _currAction = _A_MOVE;
      _isMoving = true;
      orientation = direction;
      if (orientation == LEFT) {
        velX = -20;
        if (_currAction == _A_MOVE) {
          if (isOnGround)
            startAnimation("move_left");
          else
            startAnimation("jump_left");
        }
      } else {
        velX = 20;
        if (_currAction == _A_MOVE) {
          if (isOnGround)
            startAnimation("move_right");
          else
            startAnimation("jump_right");
        }
      }
    }
  }

  void stopMove() {
    _isMoving = false;
    velX = 0;
    if (_currAction == _A_MOVE) {
      if (orientation == LEFT)
        startAnimation("idle_left");
      else
        startAnimation("idle_right");
    }
  }

  void jump() {
    if (_currAction != _A_BLOCK && _currAction != _A_STUN) {
      // can't jump if blocking
      if (isOnGround) _jumpCounter = 0;
      if (_jumpCounter < 2) {
        // maximum 2 consecutive jumps
        velY += 60;
        if (_currAction != _A_FIREBALL) {
          // avoid interrupting fireball animation
          if (orientation == LEFT)
            startAnimation("jump_left");
          else
            startAnimation("jump_right");
        }
        _jumpCounter++;
      }
    }
  }

  void hit() {
    if (_currAction != _A_BLOCK && _isHit == false && _currAction != _A_STUN) {
      // can't be hit if blocking
      _isHit = true;
      if (orientation == LEFT)
        startAnimation("stun_left");
      else
        startAnimation("stun_right");
    }
  }

  void eject() {
    if (_currAction != _A_BLOCK && _isEject == false) {
      // can't be eject if blocking
      _isEject = true;
      _currAction = _A_STUN;
      if (orientation == LEFT)
        startAnimation("stun_left");
      else
        startAnimation("stun_right");
    }
  }

  void basicAttack() {
    if ((_currAction == _A_NONE) ||
        (_currAction == _A_MOVE) ||
        (_currAction == _A_JUMP)) {
      _currAction = _A_BASIC_ATTACK;
      if (orientation == LEFT)
        startAnimation("attack_left");
      else
        startAnimation("attack_right");
    }
  }

  void smashAttack() {
    if ((_currAction == _A_NONE) ||
        (_currAction == _A_MOVE) ||
        (_currAction == _A_JUMP)) {
      _currAction = _A_SMASH_ATTACK;
      if (orientation == LEFT)
        startAnimation("smash_attack_left");
      else
        startAnimation("smash_attack_right");
    }
  }

  void block() {
    _isBlocking = true;
    if ((_currAction == _A_NONE) ||
        (_currAction == _A_MOVE) ||
        (_currAction == _A_JUMP)) {
      _currAction = _A_BLOCK;
      velX = 0;
      if (orientation == LEFT)
        startAnimation("block_left");
      else
        startAnimation("block_right");
    }
  }

  void stopBlock() {
    if (_currAction == _A_BLOCK) {
      _currAction = _A_NONE;
      _isBlocking = false;
      if (orientation == LEFT)
        startAnimation("idle_left");
      else
        startAnimation("idle_right");
    }
  }

  Fireball _buildFireball();

  Fireball launchFireball() {
    if (orientation == Fighter.LEFT) {
      return _buildFireball().launch(posX - 1, posY, -20);
    } else {
      return _buildFireball().launch(posX + 1, posY, 20);
    }
  }

  bool fireballReady() {
    return (_currAction == _A_FIREBALL) && (counter == fireballCounterValue);
  }

  void fireball() {
    if ((_currAction == _A_NONE) ||
        (_currAction == _A_MOVE) ||
        (_currAction == _A_JUMP)) {
      _currAction = _A_FIREBALL;
      if (orientation == LEFT)
        startAnimation("fireball_left");
      else
        startAnimation("fireball_right");
    }
  }
}

class Fireball extends PhysicalAsset {
  int id = 0; // associated fighter id

  Fireball(int id, String imageFile, double width, double height,
      double hitboxX, double hitboxY) {
    // id
    this.id = id;
    // visual properties
    this.imageFile = imageFile;
    this.width = width;
    this.height = height;
    // physical properties
    type = PhysicalAsset.DYNAMIC;
    projectile = true;
    // hitbox
    this.hitboxX = hitboxX;
    this.hitboxY = hitboxY;
  }

  int get direction {
    if (velX <= 0) return Fighter.LEFT;
    return Fighter.RIGHT;
  }

  Fireball launch(double posX, double posY, double velX) {
    this.posX = posX;
    this.posY = posY;
    this.velX = velX;
    return this;
  }
}

class RedSantaClaus extends Fighter {
  // sprites path
  String spritesPath = 'assets/images/fighters/red_santaclaus/';

  RedSantaClaus(int id, double posX, double posY, int orientation) {
    // id
    this.id = id;
    // visual properties
    this.orientation = orientation;
    if (this.orientation == Fighter.LEFT)
      this.imageFile = spritesPath + 'idle_l_1.png';
    else
      this.imageFile = spritesPath + 'idle_r_1.png';
    width = 8;
    height = 17;
    this.posX = posX;
    this.posY = posY;
    // hitboxe
    hitboxX = 6;
    hitboxY = 11;
    // respawn
    respawnPosX = posX;
    respawnPosY = posY;
    // basic attack
    _hurtBasicOffsetX = 2;
    hurtBasicOffsetY = 0.25;
    _hurtBasicX = 4;
    _hurtBasicY = 4;
    basicAttCounterMin = 5;
    basicAttCounterMax = 20;
    // smash attack
    _hurtSmashOffsetX = 2;
    hurtSmashOffsetY = -2;
    _hurtSmashX = 4;
    _hurtSmashY = 4;
    smashAttCounterMin = 5;
    smashAttCounterMax = 20;
    // fireball timing
    fireballCounterValue = 40;
  }

  @override
  Map<String, Map<int, String>> animationsFactory() {
    Map<String, Map<int, String>> animationsMap = new Map();
    var framesMap;

    // idle left
    framesMap = {0: spritesPath + 'idle_l_1.png'};
    animationsMap["idle_left"] = framesMap;

    // idle right
    framesMap = {0: spritesPath + 'idle_r_1.png'};
    animationsMap["idle_right"] = framesMap;

    // move left
    framesMap = {
      0: spritesPath + 'move_l_1.png',
      5: spritesPath + 'move_l_2.png',
      10: spritesPath + 'move_l_3.png',
      15: spritesPath + 'move_l_4.png',
      20: spritesPath + 'move_l_5.png',
      25: spritesPath + 'move_l_6.png',
      30: spritesPath + 'move_l_7.png',
      35: spritesPath + 'move_l_8.png'
    };
    animationsMap["move_left"] = framesMap;

    // move right
    framesMap = {
      0: spritesPath + 'move_r_1.png',
      5: spritesPath + 'move_r_2.png',
      10: spritesPath + 'move_r_3.png',
      15: spritesPath + 'move_r_4.png',
      20: spritesPath + 'move_r_5.png',
      25: spritesPath + 'move_r_6.png',
      30: spritesPath + 'move_r_7.png',
      35: spritesPath + 'move_r_8.png'
    };
    animationsMap["move_right"] = framesMap;

    // jump left
    framesMap = {
      0: spritesPath + 'jump_l_1.png',
      5: spritesPath + 'jump_l_2.png',
      10: spritesPath + 'jump_l_3.png',
      15: spritesPath + 'jump_l_4.png',
      20: spritesPath + 'jump_l_5.png',
      25: spritesPath + 'jump_l_6.png'
    };
    animationsMap["jump_left"] = framesMap;

    // jump right
    framesMap = {
      0: spritesPath + 'jump_r_1.png',
      5: spritesPath + 'jump_r_2.png',
      10: spritesPath + 'jump_r_3.png',
      15: spritesPath + 'jump_r_4.png',
      20: spritesPath + 'jump_r_5.png',
      25: spritesPath + 'jump_r_6.png'
    };
    animationsMap["jump_right"] = framesMap;

    // stun left
    framesMap = {
      0: spritesPath + 'stun_l_1.png',
      5: spritesPath + 'stun_l_2.png',
      10: spritesPath + 'stun_l_3.png',
      15: spritesPath + 'stun_l_4.png'
    };
    animationsMap["stun_left"] = framesMap;

    // stun right
    framesMap = {
      0: spritesPath + 'stun_r_1.png',
      5: spritesPath + 'stun_r_2.png',
      10: spritesPath + 'stun_r_3.png',
      15: spritesPath + 'stun_r_4.png'
    };
    animationsMap["stun_right"] = framesMap;

    // attack left
    framesMap = {
      0: spritesPath + 'attack_l_1.png',
      5: spritesPath + 'attack_l_2.png',
      10: spritesPath + 'attack_l_3.png',
      15: spritesPath + 'attack_l_4.png',
      20: spritesPath + 'attack_l_5.png'
    };
    animationsMap["attack_left"] = framesMap;

    // attack right
    framesMap = {
      0: spritesPath + 'attack_r_1.png',
      5: spritesPath + 'attack_r_2.png',
      10: spritesPath + 'attack_r_3.png',
      15: spritesPath + 'attack_r_4.png',
      20: spritesPath + 'attack_r_5.png'
    };
    animationsMap["attack_right"] = framesMap;

    // smash attack left
    framesMap = {
      0: spritesPath + 'smash_attack_l_1.png',
      5: spritesPath + 'smash_attack_l_2.png',
      10: spritesPath + 'smash_attack_l_3.png',
      15: spritesPath + 'smash_attack_l_4.png',
      20: spritesPath + 'smash_attack_l_5.png',
      25: spritesPath + 'smash_attack_l_6.png',
      30: spritesPath + 'smash_attack_l_7.png',
      35: spritesPath + 'smash_attack_l_8.png',
      40: spritesPath + 'smash_attack_l_9.png'
    };
    animationsMap["smash_attack_left"] = framesMap;

    // smash attack right
    framesMap = {
      0: spritesPath + 'smash_attack_r_1.png',
      5: spritesPath + 'smash_attack_r_2.png',
      10: spritesPath + 'smash_attack_r_3.png',
      15: spritesPath + 'smash_attack_r_4.png',
      20: spritesPath + 'smash_attack_r_5.png',
      25: spritesPath + 'smash_attack_r_6.png',
      30: spritesPath + 'smash_attack_r_7.png',
      35: spritesPath + 'smash_attack_r_8.png',
      40: spritesPath + 'smash_attack_r_9.png'
    };
    animationsMap["smash_attack_right"] = framesMap;

    // block left
    framesMap = {0: spritesPath + 'block_l_1.png'};
    animationsMap["block_left"] = framesMap;

    // block right
    framesMap = {0: spritesPath + 'block_r_1.png'};
    animationsMap["block_right"] = framesMap;

    // fireball left
    framesMap = {
      0: spritesPath + 'fireball_l_1.png',
      5: spritesPath + 'fireball_l_2.png',
      10: spritesPath + 'fireball_l_3.png',
      15: spritesPath + 'fireball_l_4.png',
      20: spritesPath + 'fireball_l_5.png',
      25: spritesPath + 'fireball_l_6.png',
      30: spritesPath + 'fireball_l_7.png',
      35: spritesPath + 'fireball_l_8.png',
      40: spritesPath + 'fireball_l_9.png',
      45: spritesPath + 'fireball_l_10.png'
    };
    animationsMap["fireball_left"] = framesMap;

    // fireball right
    framesMap = {
      0: spritesPath + 'fireball_r_1.png',
      5: spritesPath + 'fireball_r_2.png',
      10: spritesPath + 'fireball_r_3.png',
      15: spritesPath + 'fireball_r_4.png',
      20: spritesPath + 'fireball_r_5.png',
      25: spritesPath + 'fireball_r_6.png',
      30: spritesPath + 'fireball_r_7.png',
      35: spritesPath + 'fireball_r_8.png',
      40: spritesPath + 'fireball_r_9.png',
      45: spritesPath + 'fireball_r_10.png'
    };
    animationsMap["fireball_right"] = framesMap;

    return animationsMap;
  }

  @override
  Fireball _buildFireball() {
    return Fireball(id, spritesPath + 'fireball.png', 2, 4, 2, 4);
  }
}

class GreenSantaClaus extends Fighter {
  // sprites path
  String spritesPath = 'assets/images/fighters/green_santaclaus/';

  GreenSantaClaus(int id, double posX, double posY, int orientation) {
    // id
    this.id = id;
    // visual properties
    this.orientation = orientation;
    if (this.orientation == Fighter.LEFT)
      this.imageFile = spritesPath + 'idle_l_1.png';
    else
      this.imageFile = spritesPath + 'idle_r_1.png';
    width = 8;
    height = 17;
    this.posX = posX;
    this.posY = posY;
    // hitboxe
    hitboxX = 6;
    hitboxY = 11;
    // respawn
    respawnPosX = posX;
    respawnPosY = posY;
    // basic attack
    _hurtBasicOffsetX = 2;
    hurtBasicOffsetY = 0.25;
    _hurtBasicX = 4;
    _hurtBasicY = 4;
    basicAttCounterMin = 5;
    basicAttCounterMax = 20;
    // smash attack
    _hurtSmashOffsetX = 2;
    hurtSmashOffsetY = -2;
    _hurtSmashX = 4;
    _hurtSmashY = 4;
    smashAttCounterMin = 5;
    smashAttCounterMax = 20;
    // fireball timing
    fireballCounterValue = 40;
  }

  @override
  Map<String, Map<int, String>> animationsFactory() {
    Map<String, Map<int, String>> animationsMap = new Map();
    var framesMap;

    // idle left
    framesMap = {0: spritesPath + 'idle_l_1.png'};
    animationsMap["idle_left"] = framesMap;

    // idle right
    framesMap = {0: spritesPath + 'idle_r_1.png'};
    animationsMap["idle_right"] = framesMap;

    // move left
    framesMap = {
      0: spritesPath + 'move_l_1.png',
      5: spritesPath + 'move_l_2.png',
      10: spritesPath + 'move_l_3.png',
      15: spritesPath + 'move_l_4.png',
      20: spritesPath + 'move_l_5.png',
      25: spritesPath + 'move_l_6.png',
      30: spritesPath + 'move_l_7.png',
      35: spritesPath + 'move_l_8.png'
    };
    animationsMap["move_left"] = framesMap;

    // move right
    framesMap = {
      0: spritesPath + 'move_r_1.png',
      5: spritesPath + 'move_r_2.png',
      10: spritesPath + 'move_r_3.png',
      15: spritesPath + 'move_r_4.png',
      20: spritesPath + 'move_r_5.png',
      25: spritesPath + 'move_r_6.png',
      30: spritesPath + 'move_r_7.png',
      35: spritesPath + 'move_r_8.png'
    };
    animationsMap["move_right"] = framesMap;

    // jump left
    framesMap = {
      0: spritesPath + 'jump_l_1.png',
      5: spritesPath + 'jump_l_2.png',
      10: spritesPath + 'jump_l_3.png',
      15: spritesPath + 'jump_l_4.png',
      20: spritesPath + 'jump_l_5.png',
      25: spritesPath + 'jump_l_6.png'
    };
    animationsMap["jump_left"] = framesMap;

    // jump right
    framesMap = {
      0: spritesPath + 'jump_r_1.png',
      5: spritesPath + 'jump_r_2.png',
      10: spritesPath + 'jump_r_3.png',
      15: spritesPath + 'jump_r_4.png',
      20: spritesPath + 'jump_r_5.png',
      25: spritesPath + 'jump_r_6.png'
    };
    animationsMap["jump_right"] = framesMap;

    // stun left
    framesMap = {
      0: spritesPath + 'stun_l_1.png',
      5: spritesPath + 'stun_l_2.png',
      10: spritesPath + 'stun_l_3.png',
      15: spritesPath + 'stun_l_4.png'
    };
    animationsMap["stun_left"] = framesMap;

    // stun right
    framesMap = {
      0: spritesPath + 'stun_r_1.png',
      5: spritesPath + 'stun_r_2.png',
      10: spritesPath + 'stun_r_3.png',
      15: spritesPath + 'stun_r_4.png'
    };
    animationsMap["stun_right"] = framesMap;

    // attack left
    framesMap = {
      0: spritesPath + 'attack_l_1.png',
      5: spritesPath + 'attack_l_2.png',
      10: spritesPath + 'attack_l_3.png',
      15: spritesPath + 'attack_l_4.png',
      20: spritesPath + 'attack_l_5.png'
    };
    animationsMap["attack_left"] = framesMap;

    // attack right
    framesMap = {
      0: spritesPath + 'attack_r_1.png',
      5: spritesPath + 'attack_r_2.png',
      10: spritesPath + 'attack_r_3.png',
      15: spritesPath + 'attack_r_4.png',
      20: spritesPath + 'attack_r_5.png'
    };
    animationsMap["attack_right"] = framesMap;

    // smash attack left
    framesMap = {
      0: spritesPath + 'smash_attack_l_1.png',
      5: spritesPath + 'smash_attack_l_2.png',
      10: spritesPath + 'smash_attack_l_3.png',
      15: spritesPath + 'smash_attack_l_4.png',
      20: spritesPath + 'smash_attack_l_5.png',
      25: spritesPath + 'smash_attack_l_6.png',
      30: spritesPath + 'smash_attack_l_7.png',
      35: spritesPath + 'smash_attack_l_8.png',
      40: spritesPath + 'smash_attack_l_9.png'
    };
    animationsMap["smash_attack_left"] = framesMap;

    // smash attack right
    framesMap = {
      0: spritesPath + 'smash_attack_r_1.png',
      5: spritesPath + 'smash_attack_r_2.png',
      10: spritesPath + 'smash_attack_r_3.png',
      15: spritesPath + 'smash_attack_r_4.png',
      20: spritesPath + 'smash_attack_r_5.png',
      25: spritesPath + 'smash_attack_r_6.png',
      30: spritesPath + 'smash_attack_r_7.png',
      35: spritesPath + 'smash_attack_r_8.png',
      40: spritesPath + 'smash_attack_r_9.png'
    };
    animationsMap["smash_attack_right"] = framesMap;

    // block left
    framesMap = {0: spritesPath + 'block_l_1.png'};
    animationsMap["block_left"] = framesMap;

    // block right
    framesMap = {0: spritesPath + 'block_r_1.png'};
    animationsMap["block_right"] = framesMap;

    // fireball left
    framesMap = {
      0: spritesPath + 'fireball_l_1.png',
      5: spritesPath + 'fireball_l_2.png',
      10: spritesPath + 'fireball_l_3.png',
      15: spritesPath + 'fireball_l_4.png',
      20: spritesPath + 'fireball_l_5.png',
      25: spritesPath + 'fireball_l_6.png',
      30: spritesPath + 'fireball_l_7.png',
      35: spritesPath + 'fireball_l_8.png',
      40: spritesPath + 'fireball_l_9.png',
      45: spritesPath + 'fireball_l_10.png'
    };
    animationsMap["fireball_left"] = framesMap;

    // fireball right
    framesMap = {
      0: spritesPath + 'fireball_r_1.png',
      5: spritesPath + 'fireball_r_2.png',
      10: spritesPath + 'fireball_r_3.png',
      15: spritesPath + 'fireball_r_4.png',
      20: spritesPath + 'fireball_r_5.png',
      25: spritesPath + 'fireball_r_6.png',
      30: spritesPath + 'fireball_r_7.png',
      35: spritesPath + 'fireball_r_8.png',
      40: spritesPath + 'fireball_r_9.png',
      45: spritesPath + 'fireball_r_10.png'
    };
    animationsMap["fireball_right"] = framesMap;

    return animationsMap;
  }

  @override
  Fireball _buildFireball() {
    return Fireball(id, spritesPath + 'fireball.png', 2, 4, 2, 4);
  }
}
