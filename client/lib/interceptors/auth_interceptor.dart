import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:sure_upload/repositories/local_repository.dart';

class AuthInterceptor implements InterceptorContract {
  final _localRepository = LocalRepository();

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      final token = await _localRepository.getToken();

      if (token != null) {
        final authorization = token;

        data.headers.update(
          'Authorization',
          (value) => authorization,
          ifAbsent: () => authorization,
        );
      }

      if (data.body is String && (data.body as String).startsWith('{')) {
        const contentType = 'application/json; charset=UTF-8';

        data.headers.update(
          'Content-Type',
          (value) => contentType,
          ifAbsent: () => contentType,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async =>
      data;
}
