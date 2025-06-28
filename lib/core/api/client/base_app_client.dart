import 'package:http/http.dart' as http;

class BaseHttpClient extends http.BaseClient {
  final http.Client _inner;

  BaseHttpClient(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
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
