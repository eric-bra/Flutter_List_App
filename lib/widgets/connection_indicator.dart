import 'dart:async';

import 'package:flutter/material.dart';
import 'package:listapp/DataManaging/esense_handler.dart';

class ConnectionIndicator extends StatefulWidget {
  const ConnectionIndicator({Key? key}) : super(key: key);

  @override
  _ConnectionIndicatorState createState() => _ConnectionIndicatorState();
}

class _ConnectionIndicatorState extends State<ConnectionIndicator> {
  final _eSense = ESenseHandler.instance;
  late StreamSubscription connected;
  @override
  void initState() {
    super.initState();
    connected = _eSense.liveConnected.asStream().listen((event) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: _eSense.connectionNotifier,
        builder: (context, value, widget) {
          return Icon(Icons.headphones,
              color: value? Colors.green : Colors.red);
        });
  }
  @override
  void dispose() {
    connected.cancel();
    super.dispose();
  }
}
