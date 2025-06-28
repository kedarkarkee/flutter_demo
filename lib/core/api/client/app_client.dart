import 'dart:convert';

import 'package:demo/core/api/client/base_app_client.dart';
import 'package:demo/core/api/exception/api_exception.dart';
import 'package:demo/core/api/http_logger/http_logger.dart';

class AppClient {
  final BaseHttpClient _client;
  final HttpLogger _logger;

  AppClient(this._client, this._logger);

  static const String _baseUrl = 'dummyjson.com';

  Future<T> get<T>(String path, {Map<String, String>? queryParameters}) async {
    final uri = Uri.https(_baseUrl, path, queryParameters);
    final response = await _client.get(uri);
    final resBody = json.decode(response.body);
    _logger.logResponse(resBody);
    if (response.statusCode >= 300) {
      throw ApiException(statusCode: response.statusCode, body: response.body);
    }
    return resBody as T;
  }
}
