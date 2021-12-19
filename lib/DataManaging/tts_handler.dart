import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

class TtSHandler {
  static final TtSHandler instance = TtSHandler._init();
  static FlutterTts? _tts;
  TtSHandler._init();

  final double _volume = 0.5;
  final double _pitch = 1.0;
  final double _rate = 0.5;
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
      ttsState = TtsState.playing;
    });

    flutterTts.setCompletionHandler(() {
      ttsState = TtsState.stopped;
    });

    flutterTts.setCancelHandler(() {
      ttsState = TtsState.stopped;
    });

    if (isWeb || isIOS) {
      flutterTts.setPauseHandler(() {
        ttsState = TtsState.paused;
      });

      flutterTts.setContinueHandler(() {
        ttsState = TtsState.continued;
      });
    }

    flutterTts.setErrorHandler((msg) {
      ttsState = TtsState.stopped;
    });
    flutterTts.setLanguage("de-DE");
    return flutterTts;
  }

  Future _getDefaultEngine() async {
    var ttS = await tts;
    var engine = await ttS.getDefaultEngine;
    if (engine != null) {
    }
  }

  Future speak(String text) async {
    var ttS = await tts;
    await ttS.setVolume(_volume);
    await ttS.setSpeechRate(_rate);
    await ttS.setPitch(_pitch);

    if (text.isNotEmpty) {
      await ttS.awaitSpeakCompletion(true);
      await ttS.speak(text);
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
