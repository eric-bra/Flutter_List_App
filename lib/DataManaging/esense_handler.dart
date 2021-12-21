import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/cupertino.dart';

enum EventType { front, right, left, nothing, error}

class ESenseHandler {
  get eSenseName {
    return "eSense-0151";
  }

  static final ESenseHandler instance = ESenseHandler._init();
  static final ESenseManager _eSenseManager = ESenseManager();

  ESenseHandler._init();

  Future<bool> get liveConnected async {
    connected = await _eSenseManager.isConnected();
    connectionNotifier.value = connected;
    return connected;
  }
  get connectionEvents {
    return _eSenseManager.connectionEvents;
  }

  get sensorEvents {
    return _eSenseManager.sensorEvents;
  }

  var connected = false;
  ValueNotifier<bool> connectionNotifier = ValueNotifier(false);

  Future<void> connectToESense() async {
    await _eSenseManager.disconnect();
    var stream = _eSenseManager.connectionEvents.listen((event) {
      });
    await _eSenseManager.connect(eSenseName);
    stream.cancel();
  }

  Future<EventType> determineEventType() async {
    EventType event_ = EventType.nothing;
    if (! await liveConnected) {
        return EventType.error;
    }
    await Future.delayed(const Duration(milliseconds: 600));
    await for (final event in _eSenseManager.sensorEvents) {
      if (event.gyro == null) {
        event_ = EventType.nothing;
      } else if (event.gyro![2] > 6000 && event.gyro![1] > 3000) {
        event_ = EventType.front;
        break;
      } else if (event.gyro![0] > 2000) {
        event_ = EventType.right;
        break;
      } else if (event.gyro![0] < -2000) {
        event_ = EventType.left;
        break;
      } else {
        event_ = EventType.nothing;
      }
    }
    return event_;
  }
}
