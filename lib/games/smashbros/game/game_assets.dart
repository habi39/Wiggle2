import 'package:flutter/cupertino.dart';
import 'package:Wiggle2/games/smashbros/game/assets/arenas_assets.dart';
import 'package:Wiggle2/games/smashbros/game/assets/fighters_assets.dart';
import 'package:Wiggle2/games/smashbros/game/assets/ui_assets.dart';
import 'package:Wiggle2/games/smashbros/smash_engine/asset.dart';

class GameAssetsFactory {
  static const int LEFT_SIDE = 0;
  static const int RIGHT_SIDE = 1;

  static GameAssets build(
      int mapId, int playerId, int side, bool drawHitboxes) {
    switch (mapId) {
      case 0:
        return debug();
      case 1:
        return map1(playerId, side, drawHitboxes);
      case 2:
        return map2(playerId, side, drawHitboxes);
      default:
        return debug();
    }
  }

  static List<Asset> _buildUI(Fighter player, Fighter opponent) {
    List<Asset> ui = List();
    ui.add(DamageIndicator(player, 28, 90));
    ui.add(DamageIndicator(opponent, 60, 90));
    ui.add(LifeIndicator(player, 12, 90));
    ui.add(LifeIndicator(opponent, 75, 90));
    return ui;
  }

  static GameAssets debug() {
    String arenaPath = 'assets/images/arenas/debug/';
    // background assets
    List<Asset> backgroundAssets = List();
    backgroundAssets.add(Background(arenaPath + 'background.png'));

    // physical assets
    List<PhysicalAsset> physicalAssets = List();
    // invisible walls
    physicalAssets.add(ArenaObject('', 0, 0, 1, 124, 0, 62)); // left
    physicalAssets.add(ArenaObject('', 0, 0, 1, 124, 100, 62)); // right
    physicalAssets.add(ArenaObject('', 0, 0, 130, 1, 50, 124)); // top
    physicalAssets.add(ArenaObject('', 0, 0, 130, 1, 50, 0)); // bottom
    // arena objects
    physicalAssets
        .add(ArenaObject(arenaPath + 'base.png', 100, 30, 100, 30, 50, 15));
    physicalAssets.add(
        ArenaObject(arenaPath + 'air_platform.png', 15, 14, 12, 11, 50, 50));
    physicalAssets
        .add(ArenaObject(arenaPath + 'rock.png', 8, 11, 6, 9, 28, 32));

    // fighters
    Fighter player = GreenSantaClaus(Fighter.PLAYER, 10, 50, Fighter.RIGHT);
    Fighter opponent = RedSantaClaus(Fighter.OPPONENT, 80, 50, Fighter.LEFT);

    return SmashLikeAssets(
        backgroundAssets: backgroundAssets,
        physicalAssets: physicalAssets,
        player: player,
        opponent: opponent,
        ui: _buildUI(player, opponent),
        drawHitboxes: true);
  }

  static GameAssets map1(int playerId, int side, drawHitboxes) {
    String arenaPath = 'assets/images/arenas/map1/';
    // background assets
    List<Asset> backgroundAssets = List();
    backgroundAssets.add(Background(arenaPath + 'background.png'));

    // physical assets
    List<PhysicalAsset> physicalAssets = List();
    // invisible walls
    physicalAssets.add(ArenaObject('', 0, 0, 1, 140, -20, 54)); // left
    physicalAssets.add(ArenaObject('', 0, 0, 1, 140, 120, 54)); // right
    physicalAssets.add(ArenaObject('', 0, 0, 170, 1, 50, 124)); // top
    physicalAssets.add(ArenaObject('', 0, 0, 170, 1, 50, -15)); // bottom

    // arena objects
    physicalAssets
        .add(ArenaObject(arenaPath + 'ground.png', 75, 30, 73, 28, 50, 15));
    physicalAssets
        .add(ArenaObject(arenaPath + 'long_block.png', 18, 11, 16, 9, 30, 55));
    physicalAssets
        .add(ArenaObject(arenaPath + 'small_block.png', 8, 11, 6, 9, 50, 73));
    physicalAssets
        .add(ArenaObject(arenaPath + 'long_block.png', 18, 11, 16, 9, 70, 55));

    // fighters
    Fighter player;
    Fighter opponent;
    double leftPosX = 18;
    double rightPosX = 78;
    double posY = 40;
    if (playerId == 0) {
      if (side == LEFT_SIDE) {
        player = RedSantaClaus(Fighter.PLAYER, leftPosX, posY, Fighter.RIGHT);
        opponent =
            GreenSantaClaus(Fighter.OPPONENT, rightPosX, posY, Fighter.LEFT);
      } else {
        player = RedSantaClaus(Fighter.PLAYER, rightPosX, posY, Fighter.LEFT);
        opponent =
            GreenSantaClaus(Fighter.OPPONENT, leftPosX, posY, Fighter.RIGHT);
      }
    }
    if (playerId == 1) {
      if (side == LEFT_SIDE) {
        player = GreenSantaClaus(Fighter.PLAYER, leftPosX, posY, Fighter.RIGHT);
        opponent =
            RedSantaClaus(Fighter.OPPONENT, rightPosX, posY, Fighter.LEFT);
      } else {
        player = GreenSantaClaus(Fighter.PLAYER, rightPosX, posY, Fighter.LEFT);
        opponent =
            RedSantaClaus(Fighter.OPPONENT, leftPosX, posY, Fighter.RIGHT);
      }
    }

    return SmashLikeAssets(
        backgroundAssets: backgroundAssets,
        physicalAssets: physicalAssets,
        player: player,
        opponent: opponent,
        ui: _buildUI(player, opponent),
        drawHitboxes: drawHitboxes);
  }

  static GameAssets map2(int playerId, int side, bool drawHitboxes) {
    String arenaPath = 'assets/images/arenas/map2/';
    // background assets
    List<Asset> backgroundAssets = List();
    backgroundAssets.add(Background(arenaPath + 'grassy_background.png'));

    // physical assets
    List<PhysicalAsset> physicalAssets = List();
    // invisible walls
    physicalAssets.add(ArenaObject('', 0, 0, 1, 140, -20, 54)); // left
    physicalAssets.add(ArenaObject('', 0, 0, 1, 140, 120, 54)); // right
    physicalAssets.add(ArenaObject('', 0, 0, 170, 1, 50, 124)); // top
    physicalAssets.add(ArenaObject('', 0, 0, 170, 1, 50, -15)); // bottom

    // arena objects
    physicalAssets
        .add(ArenaObject(arenaPath + 'water.png', 12, 15, 0, 0, 6, 7));
    physicalAssets.add(
        ArenaObject(arenaPath + 'big_g_stone.png', 12, 22, 11, 21, 18, 10));
    physicalAssets
        .add(ArenaObject(arenaPath + 'water.png', 12, 15, 0, 0, 30, 7));
    physicalAssets
        .add(ArenaObject(arenaPath + 'g_ground.png', 21, 16, 20, 14, 46, 7));
    physicalAssets
        .add(ArenaObject(arenaPath + 'g_slope.png', 14, 30, 0, 0, 63, 15));
    for (double i = 1; i < 15; i++) {
      physicalAssets.add(
          ArenaObject('', 1, (13 + i), 1, (13 + i), (55.5 + i), (7 + (i / 2))));
    }
    physicalAssets
        .add(ArenaObject(arenaPath + 'long_g_dirt.png', 18, 11, 16, 9, 2, 55));
    physicalAssets
        .add(ArenaObject(arenaPath + 'long_g_dirt.png', 18, 11, 16, 9, 49, 64));
    physicalAssets
        .add(ArenaObject(arenaPath + 'water.png', 14, 15, 0, 0, 93, 7));
    physicalAssets.add(
        ArenaObject(arenaPath + 'bolc_g_ground.png', 17, 30, 16, 28, 78, 14));

    // fighters
    Fighter player;
    Fighter opponent;
    double leftPosX = 18;
    double rightPosX = 78;
    double posY = 40;
    if (playerId == 0) {
      if (side == LEFT_SIDE) {
        player = RedSantaClaus(Fighter.PLAYER, leftPosX, posY, Fighter.RIGHT);
        opponent =
            GreenSantaClaus(Fighter.OPPONENT, rightPosX, posY, Fighter.LEFT);
      } else {
        player = RedSantaClaus(Fighter.PLAYER, rightPosX, posY, Fighter.LEFT);
        opponent =
            GreenSantaClaus(Fighter.OPPONENT, leftPosX, posY, Fighter.RIGHT);
      }
    }
    if (playerId == 1) {
      if (side == LEFT_SIDE) {
        player = GreenSantaClaus(Fighter.PLAYER, leftPosX, posY, Fighter.RIGHT);
        opponent =
            RedSantaClaus(Fighter.OPPONENT, rightPosX, posY, Fighter.LEFT);
      } else {
        player = GreenSantaClaus(Fighter.PLAYER, rightPosX, posY, Fighter.LEFT);
        opponent =
            RedSantaClaus(Fighter.OPPONENT, leftPosX, posY, Fighter.RIGHT);
      }
    }

    return SmashLikeAssets(
        backgroundAssets: backgroundAssets,
        physicalAssets: physicalAssets,
        player: player,
        opponent: opponent,
        ui: _buildUI(player, opponent),
        drawHitboxes: drawHitboxes);
  }
}

class SmashLikeAssets extends GameAssets {
  List<Asset> _backgroundAssets;
  List<PhysicalAsset> _physicalAssets;
  Fighter _player;
  Fighter _opponent;
  List<Fireball> _fireballs;
  List<Asset> _ui;
  bool _drawHitboxes = false;

  SmashLikeAssets({
    @required List<Asset> backgroundAssets,
    @required List<PhysicalAsset> physicalAssets,
    @required Fighter player,
    @required Fighter opponent,
    @required List<Asset> ui,
    bool drawHitboxes,
  }) {
    this._backgroundAssets = backgroundAssets;
    this._physicalAssets = physicalAssets;
    this._player = player;
    this._opponent = opponent;
    this._fireballs = List();
    this._ui = ui;
    if (drawHitboxes != null) _drawHitboxes = drawHitboxes;
  }

  @override
  List<PhysicalAsset> get physicalAssets =>
      _physicalAssets + [_player, _opponent] + _fireballs;

  Fighter get player => _player;

  Fighter get opponent => _opponent;

  List<Fireball> get fireballs => _fireballs;

  set drawHitboxes(bool drawHitboxes) => _drawHitboxes = drawHitboxes;

  @override
  List<Asset> toAssetList() {
    // concatenate the different asset lists
    List<Asset> assets = List();
    assets += _backgroundAssets;
    assets += _physicalAssets;
    assets.add(_player);
    assets.add(_opponent);
    assets += _fireballs;
    assets += _ui;

    // draw hitboxes and hurtboxes
    if (_drawHitboxes) {
      // physical assets
      for (var asset in _physicalAssets) assets.add(asset.drawHitbox());
      // fighters
      assets += [_player.drawHitbox(), _opponent.drawHitbox()];
      assets += _player.drawHurtboxes() + _opponent.drawHurtboxes();
      // fireballs
      for (var fireball in _fireballs) assets.add(fireball.drawHitbox());
    }
    return assets;
  }
}
