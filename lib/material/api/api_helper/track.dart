import 'package:flutter/foundation.dart';

class Track {
  static DateTime? _time;
  static start() {
    if (kDebugMode) {
      _time = DateTime.now();
    }
  }

  static debug(message) {
    if (kDebugMode) {
      if (_time != null) {
        final getMS = DateTime.now().difference(_time!).inMicroseconds;
        if (kDebugMode) {
          print('${getMS}mcs $message');
        }
      }
    }
  }

  static close() {
    _time = null;
  }
}
