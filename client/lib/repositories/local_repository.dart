import 'package:shared_preferences/shared_preferences.dart';

class LocalRepository {
  SharedPreferences? _sharedPreferences;

  static const _tokenKey = 'token';

  Future<SharedPreferences> getSharedPreferences() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();

    return _sharedPreferences!;
  }

  Future<String?> getToken() async {
    final sharedPreferences = await getSharedPreferences();

    return sharedPreferences.getString(_tokenKey);
  }

  Future<void> setToken(String? token) async {
    final sharedPreferences = await getSharedPreferences();

    if (token == null) {
      sharedPreferences.remove(_tokenKey);
    } else {
      sharedPreferences.setString(_tokenKey, token);
    }
  }
}
