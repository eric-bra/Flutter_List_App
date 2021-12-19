import 'dart:async';

import 'package:esense_flutter/esense.dart';

enum EventType { front, right, left, nothing, error}

class ESenseHandler {
  get eSenseName {
    return "eSense-0151";
  }

  static final ESenseHandler instance = ESenseHandler._init();
  static final ESenseManager _eSenseManager = ESenseManager();

  ESenseHandler._init() {
    connectToESense();
  }

  Future<bool> get liveConnected async {
    connected = await _eSenseManager.isConnected();
    return connected;
  }
  get connectionEvents {
    return _eSenseManager.connectionEvents;
  }

  get sensorEvents {
    return _eSenseManager.sensorEvents;
  }

  var connected = false;

  Future<bool> connectToESense() async {
    await _eSenseManager.disconnect();
    var stream = _eSenseManager.connectionEvents.listen((event) {
      });
    await _eSenseManager.connect(eSenseName);
    stream.cancel();
    await Future.delayed(const Duration(seconds: 2));
    connected = await _eSenseManager.isConnected();
    print("Connection is $connected");
    return connected;
  }

  Future<EventType> determineEventType() async {
    var event_;
    if (! await liveConnected) {
      if (!await connectToESense()) {
        return EventType.error;
      }
    }
    print("connected");
    await Future.delayed(const Duration(seconds: 1));
    print("starting scan");
    await for (final event in _eSenseManager.sensorEvents) {
      if (event.gyro == null) {
        event_ = EventType.nothing;
      } else if (event.gyro![2] > 7000 && event.gyro![1] > 3000) {
        event_ = EventType.front;
        break;
      } else if (event.gyro![0] > 3000) {
        event_ = EventType.right;
        break;
      } else if (event.gyro![0] < -3000) {
        event_ = EventType.left;
        break;
      } else {
        event_ = EventType.nothing;
      }
    }
    print(event_);
    return event_;
  }
}
