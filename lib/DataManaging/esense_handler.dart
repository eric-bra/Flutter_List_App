import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Describes the different Events that can occur when reading the sensor values of the Headphones.
enum EventType { front, right, left, nothing, error }

/// Wraps the functionality provided by the eSense-Flutter library.
class ESenseHandler {
  static final ESenseHandler instance = ESenseHandler._init();
  static final ESenseManager _eSenseManager = ESenseManager();

  ESenseHandler._init();

  ///Returns the name of the Headphones the app is supposed to work with.
  get eSenseName async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("esense_name") ?? "eSense-0151";
  }

  Future<void> setESenseName(String nName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("esense_name", nName);
  }

  ///Returns whether the headphones are paired with the device right now.
  Future<bool> get liveConnected async {
    connected = await _eSenseManager.isConnected();
    connectionNotifier.value = connected;
    return connected;
  }

  /// Returns a Stream that contains the Connection Events occuring in Relation with the given headphones.
  get connectionEvents {
    return _eSenseManager.connectionEvents;
  }

  /// Returns a Stream that contains the SensorEvents occuring in Relation with the given headphones.
  get sensorEvents {
    return _eSenseManager.sensorEvents;
  }

  /// Describes the current state of connection to the given headphones.
  /// This should only be used in a context where no asynchronous are possible.
  /// The value is dependent on the last call of the liveConnected getter.
  var connected = false;

  /// Value notifier that broadcast the connection state to listeners.
  /// The given value is dependent on the last call of liveConnected.
  ValueNotifier<bool> connectionNotifier = ValueNotifier(false);

  /// Starts the search process for the headphones with the given name.
  /// The search process does not time out and therefore only one search at a time is necessary.
  Future<void> connectToESense() async {
    await _eSenseManager.disconnect();
    var stream = _eSenseManager.connectionEvents.listen((event) {});
    String name = await eSenseName;
    await _eSenseManager.connect(name);
    stream.cancel();
  }

  /// When connected to the headphones the methods taps into the SensorEvents stream
  /// and determines what kind of event occurred since the calling of the method.
  Future<EventType> determineEventType() async {
    EventType event_ = EventType.nothing;
    if (!await liveConnected) {
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
