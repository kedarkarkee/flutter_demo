import 'package:demo/core/response/paginated_response.dart';
import 'package:demo/features/product/data/entities/product_entity.dart';
import 'package:demo/features/product/data/sources/product_local_source.dart';
import 'package:demo/features/product/data/sources/product_remote_source.dart';

class ProductRepository {
  final ProductLocalSource _localSource;
  final ProductRemoteSource _remoteSource;

  ProductRepository(this._localSource, this._remoteSource);

  Future<PaginatedResponse<ProductEntity>> fetchProducts({
    int limit = 15,
    int skip = 0,
  }) async {
    final res = await _remoteSource.fetchProducts(limit: limit, skip: skip);
    return PaginatedResponse(
      data: res.data.map((e) => ProductEntity.fromJson(e)),
      total: res.total,
      skip: res.skip,
      limit: res.limit,
    );
  }

  Future<List<int>> getFavoriteProducts() async {
    try {
      final res = await _localSource.getFavoriteProducts();
      return res.map((e) => e['id'] as int).toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> addFavorite(int id) async {
    try {
      await _localSource.addFavorite(id);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> removeFavorite(int id) async {
    try {
      return await _localSource.removeFavorite(id);
    } catch (_) {
      return false;
    }
  }
}
