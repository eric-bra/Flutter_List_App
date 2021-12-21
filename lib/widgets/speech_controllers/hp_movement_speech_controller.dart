import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';
import 'package:listapp/DataManaging/esense_handler.dart';
import 'package:listapp/DataManaging/tts_handler.dart';
import 'package:listapp/model/readable.dart';

class HpMovementSpeechController extends StatefulWidget {
  const HpMovementSpeechController({
    Key? key,
    required this.onAction,
    required this.list,
  }) : super(key: key);

  final void Function(int id) onAction;
  final List<Readable> list;

  @override
  _HpMovementSpeechControllerState createState() =>
      _HpMovementSpeechControllerState();
}

class _HpMovementSpeechControllerState
    extends State<HpMovementSpeechController> {
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

  @override
  Widget build(BuildContext context) {
    return buildBudInterface(context);
  }

  Column buildBudInterface(BuildContext context) {
    return Column(
      children: [
        _eSense.connected
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
                        return const Center(child: Text("Gerät gefunden"));
                      case ConnectionType.device_not_found:
                        return Center(
                          child: Text(
                              "Gerät nicht gefunden- ${_eSense.eSenseName}"),
                        );
                    }
                  } else {
                    return const Center(
                        child: Text("Warten auf Verbindungsdaten..."));
                  }
                },
              ),
        Text(widget.list[counter].getText()),
      ],
    );
  }

  void _listenToHeadMovement() async {
    var listLength = widget.list.length;
    if (counter < listLength - 1) {
      String title = widget.list[counter].getText();
      await _tts.speak(title);
      var action = await _eSense.determineEventType();
      switch (action) {
        case EventType.front:
          _endPlaying(context);
          widget.onAction(widget.list[counter].getId());
          return;
        case EventType.left:
          _endPlaying(context);
          return;
        case EventType.right:
          _inc();
          break;
        case EventType.nothing:
          return;
        case EventType.error:
          _endPlaying(context);
          return;
      }
    } else if (counter == listLength - 1) {
      await _tts.speak(widget.list[counter].getText());
      var action = await _eSense.determineEventType();
      switch (action) {
        case EventType.front:
          _endPlaying(context);
          widget.onAction(widget.list[counter].getId());
          return;
        case EventType.left:
          _endPlaying(context);
          return;
        case EventType.right:
          _endPlaying(context);
          break;
        case EventType.nothing:
          return;
        case EventType.error:
          _endPlaying(context);
          return;
      }
    } else {
      _endPlaying(context);
    }
  }
}
