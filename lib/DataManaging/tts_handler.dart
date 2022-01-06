import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

/// Wraps the functionality provided by the TextToSpeech-Flutter-Library.
class TtSHandler {
  ///Instance of the handler class. This should always be used.
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

  /// Returns a instance of the FlutterTts class.
  /// It guarantees that the instance is initialized.
  Future<FlutterTts> get tts async {
    if (_tts != null) return _tts!;

    _tts = await initTts();
    return _tts!;
  }

  ///Initializes a FlutterTts-Instance.
  Future<FlutterTts> initTts() async {
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
    await flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        ],
        IosTextToSpeechAudioMode.voicePrompt);
    return flutterTts;
  }

  Future _getDefaultEngine() async {
    var ttS = await tts;
    var engine = await ttS.getDefaultEngine;
    if (engine != null) {}
  }

  /// Reads out loud the given string.
  Future speak(String text) async {
    print("trying to speak");
    var ttS = await tts;
    await ttS.setVolume(_volume);
    await ttS.setSpeechRate(_rate);
    await ttS.setPitch(_pitch);

    if (text.isNotEmpty) {
      await ttS.awaitSpeakCompletion(true);
      print("speaking");
      await ttS.speak(text);
      print("finished speaking");
    }
  }

  /// Stops and discards the currently played TextToSpeech output.
  Future stop() async {
    var ttS = await tts;
    var result = await ttS.stop();
    if (result == 1) ttsState = TtsState.stopped;
  }

  /// Pauses the currently played TextToSpeech output.
  Future pause() async {
    var ttS = await tts;
    var result = await ttS.pause();
    if (result == 1) ttsState = TtsState.paused;
  }
}
