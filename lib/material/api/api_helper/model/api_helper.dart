import 'dart:convert';

import 'package:dot_test/controllers/auth/auth_controller.dart';
import 'package:handlerz/core/log_base.dart';
import 'package:handlerz/handlerz.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
// import 'package:dot_test/controller/auth/auth_controller.dart';
import 'package:dot_test/controllers/main_controller.dart';
import 'package:dot_test/material/api/api_helper/model/global_env.dart';

extension ApiHelperExtension on http.Response {
  convertToJson() {
    if (body.isNotEmpty) {
      return json.decode(body);
    }
    return body;
  }

  catchTimeout() {}
}

class ApiHelper {
  static String? _baseUrl;
  static final Map<String, String> _baseHeaders = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Accept': 'application/json',
  };

  static bool is200(http.Response response) {
    return response.statusCode == 200 || response.statusCode == 201;
  }

  static bool is401(http.Response response) {
    return response.statusCode == 401;
  }

  static bool isErrorPlatform(http.Response response) {
    return response.statusCode == 408;
  }

  static bool isTimeout(http.Response response) {
    return response.statusCode == 408;
  }

  static bool error(http.Response response) {
    return response.statusCode != 200;
  }

  static Map<String, String> getFileHeaders({String? token}) {
    final header = {'Content-Type': 'multipart/form-data', 'Accept': 'application/json'};
    if (token != null) {
      header.addAll({'Authorization': token});
    }
    return header;
  }

  static Map<String, String> getFormHeaders({String? token}) {
    final header = {'Content-Type': 'application/x-www-form-urlencoded', 'Accept': 'application/json'};
    if (token != null) {
      header.addAll({'Authorization': token});
    }
    return header;
  }

  static Map<String, String> getHeaders(Map<String, String>? headers, {String? token}) {
    final token = MainController.state.profile.token;
    if (headers == null) {
      if (token != null) {
        _baseHeaders.addAll({'Authorization': token});
      }
      return _baseHeaders;
    }
    return headers;
  }

  static String? get getUrl => _baseUrl;

  static setUrl(String url) {
    _baseUrl = url;
  }

  static void errorHandler(http.Response response) {
    LogBase.state.sendNotification(
      Handlerz.fc!.targetToken,
      LogBase.state.buildData(response.body.toString(), function: response.request?.url.path),
    );
  }

  static Future<http.MultipartRequest> _addFile(http.MultipartRequest request, List<FileData>? files) async {
    for (var file in files ?? []) {
      if (file.sendType == 'path') {
        request.files.add(await http.MultipartFile.fromPath(file.requestName, file.path, filename: file.namefile));
      } else if (file.sendType == 'string') {
        request.files.add(http.MultipartFile.fromString(file.requestName, file.path, filename: file.namefile));
      } else if (file.sendType == 'bytes') {
        request.files.add(
          http.MultipartFile.fromBytes(
            file.requestName,
            file.bytes!,
            filename: file.namefile,
            contentType: MediaType.parse(file.mimeType!),
          ),
        );
      }
    }
    return request;
  }

  static Future<http.Response> _catchTimeout(Future<http.Response> response) async {
    try {
      return await response;
    } catch (e) {
      return http.Response(e.toString(), 408);
    }
  }

  static Future<http.StreamedResponse> _catchTimeoutStream(Future<http.StreamedResponse> response) async {
    return await response;
  }

  static Future<http.Response> get(
    String url, {
    Map<String, String>? headers,
    int timeout = 60,
    bool autoSignOut = true,
    bool disableRedirect = false,
  }) async {
    final response = await _catchTimeout(
      http.get(Uri.parse('$_baseUrl$url'), headers: getHeaders(headers)).timeout(Duration(seconds: timeout)),
    );
    if (is401(response) && autoSignOut) {
      await MainController.state.logout();

      Future.delayed(Duration(milliseconds: 1100), () {
        if (!disableRedirect) {
          AuthController.state.route();
        }
      });
    }
    return response;
  }

  static Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? body,
    List<FileData>? files,
    int timeout = 60,
    bool autoSignOut = true,
    bool disableRedirect = false,
  }) async {
    try {
      final contentType = headers?['Content-Type'] ?? '';
      if (contentType.contains('multipart/form-data')) {
        var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl$url'));
        request.headers.addAll(getHeaders(headers));
        body?.forEach((key, value) {
          request.fields[key] = value;
        });
        if (files != null) {
          request = await _addFile(request, files);
        }
        // Tambahkan file jika ada, misal: request.files.add(...)
        var streamedResponse = await _catchTimeoutStream(request.send().timeout(Duration(seconds: timeout)));
        final response = await http.Response.fromStream(streamedResponse);

        if (is401(response) && autoSignOut) {
          await MainController.state.logout();
          Future.delayed(Duration(milliseconds: 1100), () {
            if (!disableRedirect) {
              AuthController.state.route();
            }
          });
        }
        return response;
      } else {
        final response = await _catchTimeout(
          http
              .post(Uri.parse('$_baseUrl$url'), headers: getHeaders(headers), body: body)
              .timeout(Duration(seconds: timeout)),
        );
        if (is401(response) && autoSignOut) {
          await MainController.state.logout();

          Future.delayed(Duration(milliseconds: 1100), () {
            if (!disableRedirect) {
              AuthController.state.route();
            }
          });
        }
        return response;
      }
    } catch (e) {
      return http.Response(e.toString(), 408);
    }
  }

  static Future<http.Response> put(
    String url, {
    String? baseUrl,
    Map<String, String>? headers,
    Map<String, String>? body,
    List<FileData>? files,
    int timeout = 60,
    bool autoSignOut = true,
    bool disableRedirect = false,
  }) async {
    try {
      final contentType = headers?['Content-Type'] ?? '';
      if (contentType.contains('multipart/form-data')) {
        var request = http.MultipartRequest('PUT', Uri.parse('${baseUrl ?? _baseUrl}$url'));
        request.headers.addAll(getHeaders(headers));
        body?.forEach((key, value) {
          request.fields[key] = value;
        });
        if (files != null && files.isNotEmpty) {
          request = await _addFile(request, files);
        }
        // Tambahkan file jika ada, misal: request.files.add(...)
        var streamedResponse = await _catchTimeoutStream(request.send().timeout(Duration(seconds: timeout)));
        final response = await http.Response.fromStream(streamedResponse);
        if (is401(response) && autoSignOut) {
          await MainController.state.logout();

          Future.delayed(Duration(milliseconds: 1100), () {
            if (!disableRedirect) {
              AuthController.state.route();
            }
          });
        }
        return response;
      } else {
        final response = await _catchTimeout(
          http
              .put(Uri.parse('${baseUrl ?? _baseUrl}$url'), headers: getHeaders(headers), body: body)
              .timeout(Duration(seconds: timeout)),
        );
        return response;
      }
    } catch (e) {
      return http.Response(e.toString(), 408);
    }
  }

  static Future<http.Response> delete(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? body,
    int timeout = 60,
    bool autoSignOut = true,
    bool disableRedirect = false,
  }) async {
    try {
      final response = await _catchTimeout(
        http
            .delete(Uri.parse('$_baseUrl$url'), headers: getHeaders(headers), body: body)
            .timeout(Duration(seconds: timeout)),
      );
      if (is401(response) && autoSignOut) {
        await MainController.state.logout();

        Future.delayed(Duration(milliseconds: 1100), () {
          if (!disableRedirect) {
            AuthController.state.route();
          }
        });
      }
      return response;
    } catch (e) {
      return http.Response(e.toString(), 408);
    }
  }

  static Future<http.Response> patch(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? body,
    int timeout = 60,
    bool autoSignOut = true,
    bool disableRedirect = false,
  }) async {
    try {
      final response = await _catchTimeout(
        http
            .patch(Uri.parse('$_baseUrl$url'), headers: getHeaders(headers), body: body)
            .timeout(Duration(seconds: timeout)),
      );
      if (is401(response) && autoSignOut) {
        await MainController.state.logout();

        Future.delayed(Duration(milliseconds: 1100), () {
          if (!disableRedirect) {
            AuthController.state.route();
          }
        });
      }
      return response;
    } catch (e) {
      return http.Response(e.toString(), 408);
    }
  }
}
