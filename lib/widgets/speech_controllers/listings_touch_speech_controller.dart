import 'package:flutter/material.dart';
import 'package:listapp/DataManaging/tts_handler.dart';
import 'package:listapp/model/readable.dart';
import 'package:listapp/widgets/speech_controllers/speech_controller.dart';

import '../../palette.dart';
import '../WidgetFactories.dart';

class ListingsTouchSpeechController extends SpeechController {
  const ListingsTouchSpeechController({
    Key? key,
    required void Function(int id) onAction,
    required List<Readable> list,
  }) : super(key: key, onAction: onAction, list: list);

  @override
  _ListingsTouchSpeechControllerState createState() =>
      _ListingsTouchSpeechControllerState();
}

class _ListingsTouchSpeechControllerState
    extends State<ListingsTouchSpeechController> {
  int counter = 0;

  @override
  void initState() {
    super.initState();
    if (widget.list.isEmpty) return;
    _tts.speak(widget.list[counter].getText());
  }

  final _tts = TtSHandler.instance;

  void _inc() {
    setState(() {
      counter++;
    });
    _tts.speak(widget.list[counter].getText());
  }

  void _dec() {
    if (counter <= 0) return;
    setState(() {
      counter--;
    });
    _tts.speak(widget.list[counter].getText());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
        child: Row(
          children: _widgets(),
        ));
  }

  List<Widget> _widgets() {
    List<Widget> list = [];
    final iconColor = Palette.kToDark.shade600;
    var back = ButtonFactory.button(Icon(Icons.arrow_back_rounded, color: iconColor), _dec);
    var check = ButtonFactory.button(Icon(Icons.check_rounded, color: iconColor), () {
      widget.onAction(widget.list[counter].getId());
      if (counter < widget.list.length - 1) _inc();
    });
    var next =
        ButtonFactory.button(Icon(Icons.arrow_forward_rounded, color: iconColor), _inc);
    if (counter > 0) {
      list.add(back);
    }
    if (widget.list.isNotEmpty) {
      list.add(check);
    }
    if (counter < widget.list.length - 1) {
      list.add(next);
    }
    return list;
  }
}
