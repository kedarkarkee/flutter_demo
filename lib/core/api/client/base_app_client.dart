import 'package:demo/core/api/interceptor/http_interceptor.dart';
import 'package:http/http.dart' as http;

class BaseHttpClient extends http.BaseClient {
  final http.Client _inner;
  final List<HttpRequestInterceptor> interceptors;

  BaseHttpClient(this._inner, {this.interceptors = const []});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    for (final interceptor in interceptors) {
      request = await interceptor.onSend(request);
    }
    if (request.method == 'POST' || request.method == 'PUT') {
      request.headers.update(
        'Content-Type',
        (_) => 'application/json',
        ifAbsent: () => 'application/json',
      );
    }
    return _inner.send(request);
  }
}
