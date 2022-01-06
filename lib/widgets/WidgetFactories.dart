import 'package:flutter/material.dart';

class ButtonFactory {
  static Widget button(Widget child, void Function() onPressed) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: OutlinedButton(
            child: child,
            onPressed: onPressed,
          )),
    );
  }
}