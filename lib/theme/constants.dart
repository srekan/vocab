import 'package:flutter/material.dart';

abstract class ThemeConstants {
  static final backgroundColor1 = Colors.amber[600]; // old: Color(0xFF00695C);
  static final backgroundColor2 = Colors.amber[200]; // old: Color(0xFF009688);
  static final highlightColor = Color(0xfff65aa3);
  static final foregroundColor = Colors.white;
  static final logo = AssetImage("images/logo.png");
  static final backgroundGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight, // 10% of the width, so there are ten blinds.
    colors: [
      ThemeConstants.backgroundColor1,
      ThemeConstants.backgroundColor2
    ], // whitish to gray
    tileMode: TileMode.repeated, // repeats the gradient over the canvas
  );
  static final backgroundGradientRadial = RadialGradient(
    colors: [
      ThemeConstants.backgroundColor2,
      ThemeConstants.backgroundColor1,
    ], // whitish to gray
    tileMode: TileMode.clamp, // repeats the gradient over the canvas
  );
}
