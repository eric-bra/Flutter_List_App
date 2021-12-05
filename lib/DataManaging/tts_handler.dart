import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

class TtSHandler {
  static final TtSHandler instance = TtSHandler._init();
  static FlutterTts? _tts;
  TtSHandler._init();

  String? _language;
  String? _engine;
  double _volume = 0.5;
  double _pitch = 1.0;
  double _rate = 0.5;
  bool _isCurrentLanguageInstalled = false;
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWeb => kIsWeb;

  Future<FlutterTts> get tts async {
    if (_tts != null) return _tts!;

    _tts = initTts();
    print("innitiert");
    return _tts!;
  }

  FlutterTts initTts() {
    var flutterTts = FlutterTts();

    if (isAndroid) {
      _getDefaultEngine();
    }

    flutterTts.setStartHandler(() {
        print("Playing");
        ttsState = TtsState.playing;
    });

    flutterTts.setCompletionHandler(() {
        print("Complete");
        ttsState = TtsState.stopped;
    });

    flutterTts.setCancelHandler(() {
        print("Cancel");
        ttsState = TtsState.stopped;
    });

    if (isWeb || isIOS) {
      flutterTts.setPauseHandler(() {
          print("Paused");
          ttsState = TtsState.paused;
      });

      flutterTts.setContinueHandler(() {
          print("Continued");
          ttsState = TtsState.continued;
      });
    }

    flutterTts.setErrorHandler((msg) {
        print("error: $msg");
        ttsState = TtsState.stopped;
    });
    flutterTts.setLanguage("de-DE");
    return flutterTts;
  }

  Future<dynamic> _getLanguages() async {
    var ttS = await tts;
    ttS.getLanguages;
  }

  Future<dynamic> _getEngines()  async {
    var ttS = await tts;
    ttS.getEngines;
  }

  Future _getDefaultEngine() async {
    var ttS = await tts;
    var engine = await ttS.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future speak(String text) async {
    print(text);
    var ttS = await tts;
    print(text);
    await ttS.setVolume(_volume);
    await ttS.setSpeechRate(_rate);
    await ttS.setPitch(_pitch);

      if (text.isNotEmpty) {
        await ttS.awaitSpeakCompletion(true);
        await ttS.speak(text);
        print(text);
      }
    }

  Future stop() async {
    var ttS = await tts;
    var result = await ttS.stop();
    if (result == 1) ttsState = TtsState.stopped;
  }

  Future pause() async {
    var ttS = await tts;
    var result = await ttS.pause();
    if (result == 1) ttsState = TtsState.paused;
  }

}