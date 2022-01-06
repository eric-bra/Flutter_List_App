import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:listapp/palette.dart';

class CustomTheme {
  static final dark = ThemeData(
      brightness: Brightness.dark,
      fontFamily: Platform.isIOS ? 'SF-Pro-Rounded' : null);
  static final light = ThemeData(
      primarySwatch: Palette.kToDark,
      fontFamily: Platform.isIOS ? 'SF-Pro-Rounded' : null);

  static ThemeData current(context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark
        ? dark
        : light;
  }

  static Color borderColor(context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark
        ? dark.cardColor
        : Colors.white;
  }
}
