import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PathProvider {
  static bool request = false;
  static String? defaultPath;

  static Future<void> init() async {
    defaultPath = await directory();
  }

  static Future<String> directory({String? path, bool isRaw = false}) async {
    // var status = await Permission.storage.status;
    // print('status: $status');
    // if (!status.isGranted && !request) {
    //   request = true;
    //   await Permission.storage.request().then((value) {
    //     request = false;
    //   });
    // }
    if (Platform.isAndroid) {
      path ??= '/Download/RenovDulu/';
      final temp = await getExternalStorageDirectory();
      final base = isRaw
          ? temp?.path ?? (temp?.path ?? '') + path
          : (temp?.path ?? '').replaceAll('/Android/data/com.renovdulu.app/files', '') + path;
      await _savePath('', base);
      return base;
    } else if (Platform.isIOS) {
      path ??= '';
      final temp = await getApplicationDocumentsDirectory();
      await _savePath(path, temp.path);

      return '${temp.path}$path';
    }
    return '';
  }

  static Future _savePath(String path, String base) async {
    final slice = (base + path).split('/');
    String dirs = '';
    for (int i = 0; i < slice.length; i++) {
      dirs += slice[i];

      if (i < slice.length - 1) {
        dirs += '/';
      }
      if (await Directory(dirs).exists()) {
      } else {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }
        try {
          await Directory(dirs).create();
        } catch (_) {}
      }
    }
  }
}
