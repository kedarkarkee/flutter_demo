import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class HttpRequestInterceptor {
  Future<http.BaseRequest> onSend(http.BaseRequest request);
}

class AuthInterceptor extends HttpRequestInterceptor {
  // I have kept shared prefs for easyness but
  // on production we use flutter_secure_storage
  // for keeping access and refresh tokens
  final SharedPreferencesWithCache sharedPreferences;
  AuthInterceptor(this.sharedPreferences);

  @override
  Future<http.BaseRequest> onSend(http.BaseRequest request) async {
    final token = sharedPreferences.getString('access_token');
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    return request;
  }
}
