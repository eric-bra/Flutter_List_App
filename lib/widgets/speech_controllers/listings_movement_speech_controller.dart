import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';
import 'package:listapp/DataManaging/esense_handler.dart';
import 'package:listapp/DataManaging/tts_handler.dart';
import 'package:listapp/model/readable.dart';

class ListingsMovementSpeechController extends StatefulWidget {
  const ListingsMovementSpeechController({
    Key? key,
    required this.onAction,
    required this.list,
  }) : super(key: key);

  final void Function(int id) onAction;
  final List<Readable> list;

  @override
  _ListingsMovementSpeechControllerState createState() =>
      _ListingsMovementSpeechControllerState();
}

class _ListingsMovementSpeechControllerState extends State<ListingsMovementSpeechController> {
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
            ? const Text("Connected")
            : StreamBuilder<ConnectionEvent>(
                stream: ESenseManager().connectionEvents,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.type) {
                      case ConnectionType.connected:
                        return const Center(child: Text("Connected"));
                      case ConnectionType.unknown:
                        return ReconnectButton(
                          child: const Text("Connection: Unknown"),
                          onPressed: _eSense.connectToESense,
                        );
                      case ConnectionType.disconnected:
                        return ReconnectButton(
                          child: const Text("Connection: Disconnected"),
                          onPressed: _eSense.connectToESense,
                        );
                      case ConnectionType.device_found:
                        return const Center(
                            child: Text("Connection: Device found"));
                      case ConnectionType.device_not_found:
                        return ReconnectButton(
                          child: Text(
                              "Connection: Device not found - ${_eSense.eSenseName}"),
                          onPressed: _eSense.connectToESense,
                        );
                    }
                  } else {
                    return const Center(
                        child: Text("Waiting for Connection Data..."));
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
      print("next");
      String title = widget.list[counter].getText();
      await _tts.speak(title);
      print("ready");
      var action = await _eSense.determineEventType();
      switch (action) {
        case EventType.front:
          widget.onAction(widget.list[counter].getId());
          _inc();
          return;
        case EventType.left:
          _endPlaying(context);
          return;
        case EventType.right:
          print("it is right");
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
      print("ready");
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
          print("it is right");
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

class ReconnectButton extends StatelessWidget {
  const ReconnectButton(
      {Key? key, required this.child, required this.onPressed})
      : super(key: key);

  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        child,
        ElevatedButton(
          onPressed: onPressed,
          child: const Text("Connect To eSense"),
        )
      ]),
    );
  }
}
