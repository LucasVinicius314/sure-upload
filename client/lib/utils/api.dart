import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Response;
import 'package:http_interceptor/http/http.dart';
import 'package:sure_upload/exceptions/http_bad_request_exception.dart';
import 'package:sure_upload/exceptions/http_entity_not_found_exception.dart';
import 'package:sure_upload/exceptions/http_missing_authorization_exception.dart';
import 'package:sure_upload/interceptors/auth_interceptor.dart';

class Api {
  Api({required this.authority});

  final client = InterceptedClient.build(interceptors: [AuthInterceptor()]);

  final String authority;

  Uri getUri(String path) =>
      kDebugMode ? Uri.http(authority, path) : Uri.https(authority, path);

  Future<Map<String, dynamic>> get({
    required String path,
    Map<String, dynamic>? queryParameters,
  }) async {
    final then = DateTime.now().millisecondsSinceEpoch;

    final request = client.get(
      getUri(path),
      params: queryParameters,
    );

    final response = await request;

    await validateResponseCode(request, then);

    final jsonResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    return jsonResponse;
  }

  Future<Map<String, dynamic>> post({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    final then = DateTime.now().millisecondsSinceEpoch;

    final request = client.post(
      getUri(path),
      params: queryParameters,
      body: jsonEncode(body),
    );

    final response = await request;

    await validateResponseCode(request, then);

    final jsonResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    return jsonResponse;
  }

  Future<Map<String, dynamic>> patch({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    final then = DateTime.now().millisecondsSinceEpoch;

    final request = client.patch(
      getUri(path),
      params: queryParameters,
      body: jsonEncode(body),
    );

    final response = await request;

    await validateResponseCode(request, then);

    final jsonResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    return jsonResponse;
  }

  Future<Map<String, dynamic>> put({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    final then = DateTime.now().millisecondsSinceEpoch;

    final request = client.put(
      getUri(path),
      params: queryParameters,
      body: jsonEncode(body),
    );

    final response = await request;

    await validateResponseCode(request, then);

    final jsonResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    return jsonResponse;
  }

  Future<Map<String, dynamic>> delete({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    final then = DateTime.now().millisecondsSinceEpoch;

    final request = client.delete(
      getUri(path),
      params: queryParameters,
      body: jsonEncode(body),
    );

    final response = await request;

    await validateResponseCode(request, then);

    final jsonResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    return jsonResponse;
  }

  Future<void> validateResponseCode(
    FutureOr<Response> request,
    int then,
  ) async {
    final response = await request;

    if (kDebugMode) {
      final now = DateTime.now().millisecondsSinceEpoch;

      print(
        '${now - then} ms ${response.statusCode} ${response.request.toString()}',
      );
      print(response.body);
    }

    String? message;

    try {
      final map = jsonDecode(utf8.decode(response.bodyBytes));

      message = map['message'];
    } catch (e) {
      if (kDebugMode) print(e);
    }

    if ([401, 403].contains(response.statusCode)) {
      throw HttpMissingAuthorizationException(message: message);
    } else if (response.statusCode == 404) {
      throw HttpEntityNotFoundException(message: message);
    } else if (response.statusCode >= 400 && response.statusCode < 600) {
      throw HttpBadRequestException(message: message);
    }
  }
}
