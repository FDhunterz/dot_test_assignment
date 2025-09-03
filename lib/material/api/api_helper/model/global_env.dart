import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

class ENV {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static ENVData? _data;
  static ENVData? get data => _data;
  static ENV? _globalData;
  static ENV? get globalData => _globalData;
  static final config = ENV._init();
  ENV._init();

  save(ENVData data) {
    _data = data;
    _globalData = this;
  }
}

class ENVData {
  bool ignoreBadCertificate;
  bool? debug;
  String? baseUrl;
  Duration? timeoutDuration;
  bool isLoading;
  String? replacementId;
  RequestData? globalData;
  Future<void> Function(int start, int total)? onProgress;
  Future<void> Function(Response error)? onError;
  Future<void> Function(Response success)? onSuccess;
  Future<void> Function(Object exception)? onException;
  Future<void> Function(Object exception)? onTimeout;
  Future<void> Function(BuildContext context)? onAuthError;

  String? getUrl() {
    return (baseUrl ?? '') + (globalData?.url ?? '');
  }

  Future<List<int>> convertUTF8() async {
    globalData?.header!.addAll({'content-type': 'application/json'});
    return utf8.encode(await compute(json.encode, globalData!.body));
  }

  ENVData({
    this.isLoading = false,
    this.onError,
    this.onProgress,
    this.onSuccess,
    this.onException,
    this.baseUrl,
    this.onTimeout,
    this.timeoutDuration,
    this.debug = false,
    this.ignoreBadCertificate = false,
    this.globalData,
    this.onAuthError,
    this.replacementId,
  });
}

class RequestData {
  String? url;
  Map<String, String>? header;
  Map<String, dynamic>? body;
  List<FileData>? file;

  String getParams() {
    if (body == null) return '';
    String param = '?';
    body?.forEach((key, value) {
      param += '$key=${value.toString().replaceAll(' ', '%20')}';
      param += '&';
    });

    return param.substring(0, param.length - 1);
  }

  RequestData({this.body, this.header, this.url, this.file}) {
    file ??= [];
  }
}

class FileData {
  String? path;
  String requestName;
  String? namefile;
  String? sendType;
  Uint8List? bytes;
  String? mimeType;

  FileData({this.path, required this.requestName, this.namefile, this.sendType, this.bytes, this.mimeType});
}

class MultipartRequest {
  final String url;
  final Map<String, String> fields;
  final List<FileData> files;

  MultipartRequest({required this.url, required this.fields, required this.files});
}
