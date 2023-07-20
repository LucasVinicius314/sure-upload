import 'package:sure_upload/models/responses/get_user_response.dart';
import 'package:sure_upload/models/responses/login_response.dart';
import 'package:sure_upload/utils/api.dart';

class UserRepository {
  const UserRepository({
    required this.api,
  });

  final Api api;

  Future<GetUserResponse> get() async {
    final res = await api.get(
      path: 'api/v1/user/',
    );

    return GetUserResponse.fromJson(res);
  }

  Future<LoginResponse> login({
    required String key,
  }) async {
    final res = await api.post(
      path: 'api/v1/auth/login',
      body: {
        'key': key,
      },
    );

    return LoginResponse.fromJson(res);
  }
}
