import 'package:flutter/material.dart';
import 'package:listapp/DataManaging/tts_handler.dart';
import 'package:listapp/model/readable.dart';

class TouchSpeechController extends StatefulWidget {
  const TouchSpeechController(
      {Key? key, required this.onAction, required this.list})
      : super(key: key);

  final void Function(int id) onAction;
  final List<Readable> list;

  @override
  _TouchSpeechControllerState createState() => _TouchSpeechControllerState();
}

class _TouchSpeechControllerState extends State<TouchSpeechController> {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Row(
          children: !(widget.list.length - 1 == counter)
              ? [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                          child: const Icon(
                            Icons.dangerous_rounded,
                          ),
                          onPressed: () => _endPlaying(context)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        child: const Icon(Icons.arrow_forward_rounded),
                        onPressed: () {
                          _endPlaying(context);
                          widget.onAction(widget.list[counter].getId());
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        child: const Text(
                          'Weiter',
                        ),
                        onPressed: () {
                          if (counter < widget.list.length) {
                            _tts.stop();
                            _inc();
                          }
                        },
                      ),
                    ),
                  ),
                ]
              : [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        child: const Icon(
                          Icons.dangerous_rounded,
                        ),
                        onPressed: () => _endPlaying(context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          child: const Icon(Icons.arrow_forward_rounded),
                          onPressed: () {
                            widget.onAction(widget.list[counter].getId());
                            Navigator.of(context).pop();
                          },
                        )),
                  ),
                ],
        ));
  }
}
