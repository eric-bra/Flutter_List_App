import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';
import 'package:listapp/DataManaging/esense_handler.dart';
import 'package:listapp/DataManaging/tts_handler.dart';
import 'package:listapp/model/readable.dart';
import 'package:listapp/widgets/speech_controllers/speech_controller.dart';

class ListingsMovementSpeechController extends SpeechController {
  const ListingsMovementSpeechController({
    Key? key,
    required void Function(int id) onAction,
    required List<Readable> list,
  }) : super(key: key, onAction: onAction, list: list);

  @override
  _ListingsMovementSpeechControllerState createState() =>
      _ListingsMovementSpeechControllerState();
}

class _ListingsMovementSpeechControllerState
    extends State<ListingsMovementSpeechController> {
  final _tts = TtSHandler.instance;
  final _eSense = ESenseHandler.instance;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    if (widget.list.isEmpty) return;
    _listenToHeadMovement();
  }

  void _endPlaying(BuildContext context) {
    _tts.stop();
    Navigator.of(context).pop();
  }

  void _inc() {
    setState(() {
      counter++;
    });
    _listenToHeadMovement();
  }

  void _dec() {
    if (counter >= 1) {
      setState(() {
        counter--;
      });
      _listenToHeadMovement();
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildBudInterface(context);
  }

  Column buildBudInterface(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: _eSense.connected
              ? const Text("Verbunden")
              : StreamBuilder<ConnectionEvent>(
                  stream: ESenseManager().connectionEvents,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.type) {
                        case ConnectionType.connected:
                          return const Center(child: Text("Verbunden"));
                        case ConnectionType.unknown:
                          return const Center(
                              child: Text("Verbindungsstatus unbekannt"));
                        case ConnectionType.disconnected:
                          return const Center(
                            child: Text("Nicht verbunden"),
                          );
                        case ConnectionType.device_found:
                          return const Center(child: Text("Ger??t gefunden"));
                        case ConnectionType.device_not_found:
                          return Center(
                            child: Text(
                                "Ger??t nicht gefunden- ${_eSense.eSenseName}"),
                          );
                      }
                    } else {
                      return const Center(
                          child: Text("Warten auf Verbindungsdaten..."));
                    }
                  },
                ),
        ),
        const Divider(
          height: 3,
          thickness: 2,
          indent: 7,
          endIndent: 7,
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(widget.list[counter].getText()),
        )
      ],
    );
  }

  void _listenToHeadMovement() async {
    var listLength = widget.list.length;
    if (listLength == 0 || counter < 0 || counter >= listLength) {
      _endPlaying(context);
    }
    String title = widget.list[counter].getText();
    await _tts.speak(title);
    var action = await _eSense.determineEventType();
    switch (action) {
      case EventType.front:
        widget.onAction(widget.list[counter].getId());
        counter < listLength - 1 ? _inc() : _listenToHeadMovement();
        return;
      case EventType.left:
        counter == 0 ? _endPlaying(context) : _dec();
        return;
      case EventType.right:
        counter == listLength - 1 ? _endPlaying(context) : _inc();
        break;
      case EventType.nothing:
        _listenToHeadMovement();
        return;
      case EventType.error:
        _endPlaying(context);
        return;
    }
  }
}
