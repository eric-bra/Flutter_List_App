import 'package:flutter/material.dart';
import 'package:listapp/DataManaging/tts_handler.dart';
import 'package:listapp/model/todo_list.dart';

class SpeechController extends StatefulWidget {
  const SpeechController({Key? key, required this.list}) : super(key: key);
  final List<ToDoList> list;
  @override
  _SpeechControllerState createState() => _SpeechControllerState();
}

class _SpeechControllerState extends State<SpeechController> {
  int counter = 0;
  bool last = false;

  void _setLast(bool val) {
    setState(() {
      last = val;
    });
  }

  final _tts = TtSHandler.instance;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Row(
          children: !last
              ? [
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                            child: const Icon(
                              Icons.dangerous_rounded,
                            ),
                            onPressed: () {
                              _tts.stop();
                              Navigator.of(context).pop();
                            })),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                            child: const Text("Nächste"),
                            onPressed: () {
                              counter++;
                              bool val = (counter == widget.list.length - 1);
                              _setLast(val);
                              if (counter < widget.list.length) {
                                _tts.speak(widget.list[counter].name);
                              } else {
                                Navigator.of(context).pop();
                              }
                            })),
                  ),
                ]
              : [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                          child: const Icon(
                            Icons.dangerous_rounded,
                          ),
                          onPressed: () {
                            _tts.stop();
                            Navigator.of(context).pop();
                          })),
                ],
        ));
  }
}
