import 'package:flutter/material.dart';

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white);
}

InputDecoration textFieldInputDecoration(String input) {
  return InputDecoration(
      hintText: input,
      hintStyle: TextStyle(color: Colors.white54),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}
