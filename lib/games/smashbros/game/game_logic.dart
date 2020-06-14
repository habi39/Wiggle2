import 'dart:collection';
import 'dart:math';
import 'package:Wiggle2/games/smashbros/game/assets/fighters_assets.dart';
import 'package:Wiggle2/games/smashbros/game/game_assets.dart';
import 'package:Wiggle2/games/smashbros/game/multiplayer/multiplayer.dart';
import 'package:Wiggle2/games/smashbros/menus/endscreen.dart';
import 'package:Wiggle2/games/smashbros/smash_engine/asset.dart';
import 'package:Wiggle2/games/smashbros/smash_engine/smash_engine.dart';

class SmashLikeLogic extends GameLogic {
  Multiplayer multiplayer = Multiplayer();
  bool useMultiplayer = true;

  SmashLikeLogic({this.useMultiplayer});

  @override
  int update(Queue<String> inputs, GameAssets gameAssets) {
    // extract the assets
    SmashLikeAssets assets = gameAssets;
    Fighter player = assets.player;
    Fighter opponent = assets.opponent;
    List<Fireball> fireballs = assets.fireballs;

    // player inputs
    String playerInput = '';
    if (inputs.length > 0) {
      playerInput = inputs.removeFirst(); // one input per frame
      switch (playerInput) {
        case "press_left_start":
          player.move(Fighter.LEFT);
          break;

        case "press_left_end":
          player.stopMove();
          break;

        case "press_right_start":
          player.move(Fighter.RIGHT);
          break;

        case "press_right_end":
          player.stopMove();
          break;

        case "press_up":
          player.jump();
          break;

        case "press_a":
          player.basicAttack();
          break;

        case "long_press_a":
          player.smashAttack();
          break;

        case "press_b_start":
          player.block();
          break;

        case "press_b_end":
          player.stopBlock();
          break;

        case "press_fireball":
          player.fireball();
          break;
      }
    }

    if (useMultiplayer) {
      // synchronize fighters
      if (multiplayerUpdate(playerInput, player, opponent) ==
          Multiplayer.CONNECTION_LOST) {
        endGameScreen = EndScreen(status: EndScreen.CONNECTION_LOST);
        return GameLogic.FINISHED;
      }
    }

    // basic attacks
    if (checkHurtBasic(player, opponent) && (opponent.damage < 300)) {
      opponent.damage += 0.5;
      opponent.hit();
    }
    if (checkHurtBasic(opponent, player) && (player.damage < 300)) {
      player.damage += 0.5;
      player.hit();
    }

    // smash attacks
    bool ejectOpponent = checkHurtSmash(player, opponent);
    bool ejectPlayer = checkHurtSmash(opponent, player);
    if (ejectPlayer) {
      if (player.damage < 300) {
        player.damage += 0.1;
      }
      player.eject();
      ejectFighter(player, opponent.orientation, 3, 8);
    }
    if (ejectOpponent) {
      if (opponent.damage < 300) {
        opponent.damage += 0.1;
      }
      opponent.eject();
      ejectFighter(opponent, player.orientation, 3, 8);
    }

    // remove useless fireballs
    fireballs.removeWhere((fireball) => fireball.velX == 0);
    // check fireballs ready to be launched
    if (player.fireballReady()) fireballs.add(player.launchFireball());
    if (opponent.fireballReady()) fireballs.add(opponent.launchFireball());
    // check fireballs hits
    for (Fireball fireball in fireballs) {
      if (checkHurtFireball(player, fireball)) {
        player.hit();
        if (player.damage < 300) {
          player.damage += 25;
        }
        fireball.velX = 0;
        continue;
      }
      if (checkHurtFireball(opponent, fireball)) {
        opponent.hit();
        if (opponent.damage < 300) {
          opponent.damage += 25;
        }
        fireball.velX = 0;
      }
    }

    if (outOfLimits(player)) {
      player.posX = player.respawnPosX;
      player.posY = player.respawnPosY;
      player.velX = 0;
      player.velY = 0;
      player.damage = 0;
      player.lifes--;
      if (player.lifes == 0) {
        if (useMultiplayer) multiplayer.disconnect();
        endGameScreen = EndScreen(status: EndScreen.DEFEAT);
        return GameLogic.FINISHED;
      }
    }
    if (outOfLimits(opponent)) {
      opponent.posX = opponent.respawnPosX;
      opponent.posY = opponent.respawnPosY;
      opponent.velX = 0;
      opponent.velY = 0;
      opponent.damage = 0;
      opponent.lifes--;
      if (opponent.lifes == 0) {
        if (useMultiplayer) multiplayer.disconnect();
        endGameScreen = EndScreen(status: EndScreen.VICTORY);
        return GameLogic.FINISHED;
      }
    }

    return GameLogic.ON_GOING;
  }

  bool outOfLimits(Fighter fighter) {
    if (fighter.posX < -10 || fighter.posX > 110 || fighter.posY < -8)
      return true;
    return false;
  }

  bool checkHurtBasic(Fighter att, Fighter def) {
    return (max(att.hurtBasicLeft, def.hitboxLeft) <
            min(att.hurtBasicRight, def.hitboxRight) &&
        max(att.hurtBasicBottom, def.hitboxBottom) <
            min(att.hurtBasicTop, def.hitboxTop));
  }

  bool checkHurtSmash(Fighter att, Fighter def) {
    return (max(att.hurtSmashLeft, def.hitboxLeft) <
            min(att.hurtSmashRight, def.hitboxRight) &&
        max(att.hurtSmashBottom, def.hitboxBottom) <
            min(att.hurtSmashTop, def.hitboxTop));
  }

  bool checkHurtFireball(Fighter fighter, Fireball fireball) {
    return ((fireball.id != fighter.id) &&
        (max(fighter.hitboxLeft, fireball.hitboxLeft) <
                min(fighter.hitboxRight, fireball.hitboxRight) &&
            max(fighter.hitboxBottom, fireball.hitboxBottom) <
                min(fighter.hitboxTop, fireball.hitboxTop)));
  }

  void ejectFighter(
      Fighter fighter, int orientation, double intensityX, double intensityY) {
    if (orientation == Fighter.LEFT)
      fighter.velX -= intensityX * (fighter.damage / 100);
    else
      fighter.velX += intensityX * (fighter.damage / 100);
    fighter.velY += intensityY * (fighter.damage / 100);
  }

  int multiplayerUpdate(String playerInput, Fighter player, Fighter opponent) {
    // player
    double pPosX = player.posX;
    double pPosY = player.posY;
    double pDamage = player.damage;
    double pLifes = player.lifes.toDouble();
    switch (playerInput) {
      case "press_left_start":
        multiplayer.send(
            [Multiplayer.LEFT_START.toDouble(), pPosX, pPosY, pDamage, pLifes]);
        break;

      case "press_left_end":
        multiplayer.send(
            [Multiplayer.LEFT_END.toDouble(), pPosX, pPosY, pDamage, pLifes]);
        break;

      case "press_right_start":
        multiplayer.send([
          Multiplayer.RIGHT_START.toDouble(),
          pPosX,
          pPosY,
          pDamage,
          pLifes
        ]);
        break;

      case "press_right_end":
        multiplayer.send(
            [Multiplayer.RIGHT_END.toDouble(), pPosX, pPosY, pDamage, pLifes]);
        break;

      case "press_up":
        multiplayer
            .send([Multiplayer.UP.toDouble(), pPosX, pPosY, pDamage, pLifes]);
        break;

      case "press_a":
        multiplayer
            .send([Multiplayer.A.toDouble(), pPosX, pPosY, pDamage, pLifes]);
        break;

      case "long_press_a":
        multiplayer.send(
            [Multiplayer.LONG_A.toDouble(), pPosX, pPosY, pDamage, pLifes]);
        break;

      case "press_b_start":
        multiplayer.send(
            [Multiplayer.B_START.toDouble(), pPosX, pPosY, pDamage, pLifes]);
        break;

      case "press_b_end":
        multiplayer.send(
            [Multiplayer.B_END.toDouble(), pPosX, pPosY, pDamage, pLifes]);
        break;

      case "press_fireball":
        multiplayer.send(
            [Multiplayer.FIREBALL.toDouble(), pPosX, pPosY, pDamage, pLifes]);
        break;

      default:
        multiplayer
            .send([Multiplayer.NONE.toDouble(), pPosX, pPosY, pDamage, pLifes]);
        break;
    }

    // receive values
    List<double> values = multiplayer.receive();
    if (values.isEmpty) return Multiplayer.CONTINUE;
    if (values[0] == -1) return Multiplayer.CONNECTION_LOST;

    // opponent
    opponent.posX = values[1];
    opponent.posY = values[2];
    opponent.damage = values[3];
    opponent.lifes = values[4].toInt();
    switch (values[0].round()) {
      case Multiplayer.LEFT_START:
        opponent.move(Fighter.LEFT);
        break;

      case Multiplayer.LEFT_END:
        opponent.stopMove();
        break;

      case Multiplayer.RIGHT_START:
        opponent.move(Fighter.RIGHT);
        break;

      case Multiplayer.RIGHT_END:
        opponent.stopMove();
        break;

      case Multiplayer.UP:
        opponent.jump();
        break;

      case Multiplayer.A:
        opponent.basicAttack();
        break;

      case Multiplayer.LONG_A:
        opponent.smashAttack();
        break;

      case Multiplayer.B_START:
        opponent.block();
        break;

      case Multiplayer.B_END:
        opponent.stopBlock();
        break;

      case Multiplayer.FIREBALL:
        opponent.fireball();
        break;
    }
    return Multiplayer.CONTINUE;
  }
}
