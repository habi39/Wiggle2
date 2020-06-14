import 'package:flutter/material.dart';
import 'package:Wiggle2/games/smashbros/smash_engine/smash_engine.dart';

class Gesture extends StatelessWidget {
  final List<InputGesture> _inputGestures;

  Gesture({List<InputGesture> inputGestures})
      : this._inputGestures = inputGestures;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _inputGestures,
    );
  }
}

abstract class InputGesture extends StatelessWidget {
  void pushInput(BuildContext context, String input) {
    SmashEngine.of(context).inputs.add(input);
  }
}
