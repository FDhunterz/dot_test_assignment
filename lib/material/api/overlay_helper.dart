import 'package:dot_test/material/confirmation/confirmation.dart';
import 'package:flutter/material.dart';

class OverlayHelper {
  static List<dynamic> stacks = [];
  static bool overlayStatus = false;
  static Future<void> showTimeout(dynamic stack) async {
    if (overlayStatus) {
      return;
    }
    stacks.add(stack);

    if (!overlayStatus) {
      overlayStatus = true;
    }

    final d = await confirmationAlert(
      header: 'Timeout',
      title: 'Timeout Request',
      message: 'Mungkin server kami sedang bermasalah, jika koneksi anda tidak bermasalah',
      icon: Image.asset('assets/images/alert_icon_4.png', width: 100),
      accButton: 'Reconnect',
      cancelButton: 'Back',
    );
    if (d == true) {
      reCall();
    } else {
      hideTimeout(stack);
    }
  }

  static void hideTimeout(stack) {
    stacks.clear();
    if (stacks.isEmpty) {
      overlayStatus = false;
    }
  }

  static void reCall() {
    for (var element in stacks) {
      if (element is Function) {
        element();
      }
    }
    stacks.clear();
    if (stacks.isEmpty) {
      overlayStatus = false;
    }
  }

  static void removeAll() {
    stacks.clear();
    overlayStatus = false;
  }
}
