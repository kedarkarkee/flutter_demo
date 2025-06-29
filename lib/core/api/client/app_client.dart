import 'dart:async';
import 'dart:convert';

import 'package:demo/core/api/client/base_app_client.dart';
import 'package:demo/core/api/exception/api_exception.dart';
import 'package:demo/core/api/http_logger/http_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppClient {
  final BaseHttpClient _client;
  final HttpLogger _logger;
  // Here we may use our own custom secure_storage_adapter
  final SharedPreferencesWithCache _prefs;

  AppClient(this._client, this._logger, this._prefs);

  Completer<bool>? _refreshTokenCompleter;

  static const String _baseUrl = 'dummyjson.com';

  Future<T> get<T>(String path, {Map<String, String>? queryParameters}) async {
    final uri = Uri.https(_baseUrl, path, queryParameters);
    final response = await _client.get(uri);
    final resBody = json.decode(response.body);
    _logger.logResponse(resBody);
    if (response.statusCode == 401) {
      // Access Token has expired
      final isRefreshSuccess = await _refreshSynchronized();
      return isRefreshSuccess
          ? get<T>(path, queryParameters: queryParameters)
          : throw ApiException(
              statusCode: response.statusCode,
              body: response.body,
            );
    }
    if (response.statusCode >= 300) {
      throw ApiException(statusCode: response.statusCode, body: response.body);
    }
    return resBody as T;
  }

  /// Prevents refresh from being called from multiple api requests concurrently
  Future<bool> _refreshSynchronized() async {
    if (_refreshTokenCompleter != null) {
      return await _refreshTokenCompleter!.future;
    }
    _refreshTokenCompleter = Completer<bool>();
    try {
      final result = await _refreshAuth();
      _refreshTokenCompleter!.complete(result);
      return result;
    } catch (e) {
      _refreshTokenCompleter!.completeError(e);
      return false;
    } finally {
      _refreshTokenCompleter = null;
    }
  }

  Future<bool> _refreshAuth() async {
    try {
      final uri = Uri.https(_baseUrl, 'refresh_path');
      final response = await _client.post(
        uri,
        body: {'refresh_token': _prefs.getString('refresh_token')},
      );
      if (response.statusCode >= 300) {
        throw ApiException(
          statusCode: response.statusCode,
          body: response.body,
        );
      }
      final resBody = json.decode(response.body) as Map<String, dynamic>;
      final accessToken = resBody['access_token'];
      final refreshToken = resBody['refresh_token'];
      await _prefs.setString('access_token', accessToken);
      await _prefs.setString('refresh_token', refreshToken);
      return true;
    } catch (_) {
      return false;
    }
  }
}
