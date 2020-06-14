import 'package:flutter/material.dart';

class CompatibilityCard extends StatefulWidget {
  final String question;
  final String answer1;
  final String answer2;

  CompatibilityCard(this.question, this.answer1, this.answer2);
  @override
  _CompatibilityCardState createState() => _CompatibilityCardState();
}

class _CompatibilityCardState extends State<CompatibilityCard> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
