import 'package:flutter/material.dart';
import 'package:listapp/DataManaging/tts_handler.dart';
import 'package:listapp/model/readable.dart';
import 'package:listapp/widgets/speech_controllers/speech_controller.dart';

import '../WidgetFactories.dart';

class HpTouchSpeechController extends SpeechController {
  const HpTouchSpeechController({
    Key? key,
    required void Function(int id) onAction,
    required List<Readable> list,
  }) : super(key: key, onAction: onAction, list: list);

  @override
  _HpTouchSpeechControllerState createState() =>
      _HpTouchSpeechControllerState();
}

class _HpTouchSpeechControllerState extends State<HpTouchSpeechController> {
  int counter = 0;

  @override
  void initState() {
    super.initState();
    if (widget.list.isEmpty) return;
    _tts.speak(widget.list[counter].getText());
  }

  void _endPlaying(BuildContext context) {
    _tts.stop();
    Navigator.of(context).pop();
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
    var back = ButtonFactory.button(const Icon(Icons.arrow_back_rounded), _dec);
    var check = ButtonFactory.button(const Icon(Icons.check_rounded), () {
      _endPlaying(context);
      widget.onAction(widget.list[counter].getId());
    });
    var next =
        ButtonFactory.button(const Icon(Icons.arrow_forward_rounded), _inc);
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
