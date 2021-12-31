import 'package:flutter/material.dart';
import 'package:listapp/model/readable.dart';

abstract class SpeechController extends StatefulWidget {
  const SpeechController({
    Key? key,
    required this.onAction,
    required this.list,
  }) : super(key: key);

  /// Function that should be called when the user nods.
  final void Function(int id) onAction;
  final List<Readable> list;
}
