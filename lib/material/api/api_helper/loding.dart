import 'package:flutter/material.dart';
import 'model/global_env.dart';
import 'dart:async';

class Streams {
  String id;
  bool isLoading, processOnlyThisPage;
  StreamSubscription stream;
  Streams({required this.stream, required this.id, this.isLoading = false, this.processOnlyThisPage = true});
}

class Loading {
  static Timer? timer;
  static List<String> requestStack = [];
  static List<Streams> stacks = [];
  static Widget? widget;
  static bool _isLoading = false;
  static loadingProgress() {
    return stacks.where((element) => element.isLoading).isNotEmpty;
  }

  static start({String? stack}) {
    if (widget == null) return;

    if (stack != null) {
      requestStack.add(stack);
    }
    if (!_isLoading) {
      timer = Timer(const Duration(minutes: 2), () {
        if (_isLoading) {
          requestStack.clear();
          close();
        }
      });
      _isLoading = true;
      showDialog(
        barrierDismissible: false,
        context: ENV.navigatorKey.currentContext!,
        builder: (context) {
          return widget!;
        },
      );
    }
  }

  static close({String? stack}) {
    if (_isLoading) {
      if (stack != null) {
        requestStack.removeWhere((element) => element == stack);
      }
      if (requestStack.isEmpty) {
        _isLoading = false;
        Navigator.pop(ENV.navigatorKey.currentContext!);
      }
    }
  }
}
