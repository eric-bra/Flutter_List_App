import 'package:flutter/material.dart';
import 'package:listapp/DataManaging/tts_handler.dart';

class SpeechController extends StatefulWidget {
  const SpeechController({Key? key,
    required this.onAction,
    required this.getListLength,
    required this.getString}
    ) : super(key: key);

  final void Function(BuildContext, int counter) onAction;
  final String Function(int counter) getString;
  final int Function() getListLength;


  @override
  _SpeechControllerState createState() => _SpeechControllerState();

}

class _SpeechControllerState extends State<SpeechController> {
  @override
  void initState() {
    super.initState();
    if (widget.getListLength() == 0) return;
    _tts.speak(widget.getString(counter));
  }
  int counter = 0;

  void _endPlaying(BuildContext context) {
    _tts.stop();
    Navigator.of(context).pop();
  }

  final _tts = TtSHandler.instance;

  void _inc(){
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Row(
          children: !(widget.getListLength() - 1 == counter)
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
                          widget.onAction(context, counter);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        child: const Text('Weiter',
                        ),
                        onPressed: () {
                          if (counter < widget.getListLength()) {
                            _inc();
                            _tts.stop();
                            _tts.speak(widget.getString(counter));
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
                          onPressed: () => widget.onAction(context, counter),
                        )),
                  ),
                ],
        ));
  }
}
