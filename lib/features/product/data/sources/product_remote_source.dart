import 'package:demo/core/api/client/app_client.dart';
import 'package:demo/core/api/endpoints/endpoints.dart';
import 'package:demo/core/response/paginated_response.dart';

class ProductRemoteSource {
  final AppClient client;

  const ProductRemoteSource(this.client);

  Future<PaginatedResponse<Map<String, dynamic>>> fetchProducts({
    required int limit,
    required int skip,
  }) async {
    final response = await client.get<Map<String, dynamic>>(
      ApiEndpoints.products,
      queryParameters: {'limit': '$limit', 'skip': '$skip'},
    );
    return PaginatedResponse(
      data: (response['products'] as List).map(
        (e) => e as Map<String, dynamic>,
      ),
      total: response['total'] as int,
      skip: response['skip'] as int,
      limit: response['limit'] as int,
    );
  }
}
