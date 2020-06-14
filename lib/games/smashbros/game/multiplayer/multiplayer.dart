import 'dart:async';
import 'dart:collection';
import 'package:Wiggle2/games/smashbros/game/multiplayer/bluetooth.dart';

class Multiplayer {
  static const int CONTINUE = 1;
  static const int CONNECTION_LOST = 2;
  static const int NONE = 3;
  static const int LEFT_START = 4;
  static const int LEFT_END = 5;
  static const int RIGHT_START = 6;
  static const int RIGHT_END = 7;
  static const int UP = 8;
  static const int A = 9;
  static const int LONG_A = 10;
  static const int B_START = 11;
  static const int B_END = 12;
  static const int FIREBALL = 13;

  Bluetooth bluetooth = Bluetooth();

  bool _isServer = false;
  int mapId = 0, firstPlayerId = 0;

  static final Multiplayer _inst = Multiplayer._internal();
  Multiplayer._internal();

  Future<bool> get isConnected {
    return bluetooth.isConnected;
  }

  factory Multiplayer() {
    return _inst;
  }

  Future<bool> host() {
    _isServer = true;
    return bluetooth.waitConnection();
  }

  Future<List<String>> getServers() {
    return bluetooth.pairedNames;
  }

  Future<bool> join(String deviceName) {
    _isServer = false;
    return bluetooth.connectToPaired(deviceName);
  }

  Future<bool> disconnect() {
    return bluetooth.disconnect();
  }

  Future<void> start() async {
    if (_isServer) {
      await bluetooth.write([mapId.toDouble(), firstPlayerId.toDouble()]);
    } else {
      List<double> values = await bluetooth.read(2);
      mapId = values[0].toInt();
      firstPlayerId = values[1].toInt();
    }
    // reset
    _nbRead = 0;
    inputBuffer = Queue();
  }

  Future<bool> send(List<double> value) {
    return bluetooth.write(value);
  }

  int _nbRead = 0;
  Queue<List<double>> inputBuffer = Queue();

  List<double> receive() {
    // check max number of reading
    if (_nbRead < 3) {
      _nbRead++;
      bluetooth.read(5).then((onValue) {
        inputBuffer.add(onValue);
        _nbRead--;
      });
    }
    // read input buffer
    if (inputBuffer.isNotEmpty)
      return inputBuffer.removeFirst();
    else
      return List();
  }
}
