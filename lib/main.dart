import 'dart:async';

import 'package:flutter/material.dart';
import 'package:listapp/DataManaging/db_handler.dart';
import 'package:listapp/DataManaging/esense_handler.dart';
import 'package:listapp/DataManaging/tts_handler.dart';
import 'package:listapp/widgets/homepage.dart';

import 'custom_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  TtSHandler.instance;
  var _eSense = ESenseHandler.instance;
  DbHandler.instance;
  runApp(const MyApp());
  bool mutex = false;
  bool wasConnected = true;
  Timer.periodic(const Duration(seconds: 5), (Timer t) async {
    if (mutex) {
      return;
    } else {
      mutex = true;
    }
    bool connected = await _eSense.liveConnected;
    if (!connected && wasConnected) {
      _eSense.connectToESense();
    }
    wasConnected = connected;
    mutex = false;
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.light,
      darkTheme: CustomTheme.dark,
      themeMode: ThemeMode.system,
      title: 'Flutter Demo',
      home: const HomePage(),
    );
  }
}
