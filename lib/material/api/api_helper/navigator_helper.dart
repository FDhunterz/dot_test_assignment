import 'package:flutter/material.dart';
import 'model/global_env.dart';
import 'loding.dart';

class Navigate {
  static Route<dynamic> Function({Widget page})? routeSetting;
  static Function()? afterPop;
  static _remove() {
    Loading.stacks.where((element) => element.processOnlyThisPage).map((e) {
      e.stream.cancel();
    }).toList();
  }

  static push<T>(Widget page, {bool removeObserver = true}) async {
    _remove();
    final navigator = await Navigator.push(ENV.navigatorKey.currentContext!, routeSetting!(page: page));

    return navigator;
  }

  static pushAndRemoveUntil<T>(Widget page, {bool removeObserver = true}) async {
    _remove();
    return await Navigator.pushAndRemoveUntil(ENV.navigatorKey.currentContext!, routeSetting!(page: page), (route) => false);
  }

  static void pop<T>([bool removeObserver = true, dynamic data]) async {
    if (ENV.navigatorKey.currentContext == null) {
      return;
    }

    _remove();
    Navigator.pop(ENV.navigatorKey.currentContext!, data);
    if (afterPop != null) {
      afterPop!();
    }
  }
}
