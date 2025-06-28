class ApiException implements Exception {
  final String? body;
  final int statusCode;

  const ApiException({this.body, required this.statusCode});
}
