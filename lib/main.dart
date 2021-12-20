import 'package:flutter/material.dart';
import 'package:listapp/DataManaging/db_handler.dart';
import 'package:listapp/DataManaging/esense_handler.dart';
import 'package:listapp/DataManaging/tts_handler.dart';
import 'package:listapp/widgets/homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  TtSHandler.instance;
  ESenseHandler.instance;
  DbHandler.instance;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Flutter Demo',
      home: const HomePage(),
    );
  }
}