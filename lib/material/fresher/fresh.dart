import 'package:flutter/material.dart';

class Fresh<T> extends ChangeNotifier {
  late ValueNotifier<T> listener;

  T get value => listener.value;

  Fresh(T values) {
    listener = ValueNotifier<T>(values);
  }

  refresh([Function(ValueNotifier<T> listener)? function, Function(Object err)? error]) async {
    try {
      if (function != null) await function(listener);
      listener.notifyListeners();
    } catch (e) {
      if (error != null) {
        error(e);
      }
    }
  }
}
