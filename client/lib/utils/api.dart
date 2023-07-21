import 'dart:async';
import 'dart:convert';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as base_http;
import 'package:http_interceptor/http/http.dart';
import 'package:sure_upload/exceptions/http_bad_request_exception.dart';
import 'package:sure_upload/exceptions/http_entity_not_found_exception.dart';
import 'package:sure_upload/exceptions/http_missing_authorization_exception.dart';
import 'package:sure_upload/repositories/local_repository.dart';

class Api {
  Api({
    required this.authority,
    required this.client,
    required this.localRepository,
  });

  final String authority;
  final InterceptedClient client;
  final LocalRepository localRepository;

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

  Future<Map<String, dynamic>> postForm({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, XFile>? files,
  }) async {
    final token = await localRepository.getToken();

    final then = DateTime.now().millisecondsSinceEpoch;

    final multipartRequest = base_http.MultipartRequest('POST', getUri(path))
      ..files.addAll(
        await Future.wait((files?.entries ?? []).map((e) async {
          return base_http.MultipartFile.fromBytes(
            e.key,
            await e.value.readAsBytes(),
            filename: e.value.name,
          );
        })),
      )
      ..headers['Authorization'] = token ?? ''
      ..headers['Content-Type'] = 'multipart/form-data';

    final request = client.send(multipartRequest);

    final response = await request;

    final newResponse = await base_http.Response.fromStream(response);

    await validateResponseCode(newResponse, then);

    final jsonResponse =
        jsonDecode(utf8.decode(newResponse.bodyBytes)) as Map<String, dynamic>;

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
    FutureOr<base_http.Response> request,
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
