import 'package:bloc/bloc.dart';
import 'package:demo/core/response/paginated_response.dart';
import 'package:demo/features/product/data/entities/product_entity.dart';
import 'package:demo/features/product/domain/repo/product_repository.dart';
import 'package:equatable/equatable.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repository;
  ProductBloc(this._repository) : super(ProductState.initial()) {
    on<ProductEvent>((event, emit) {
      return switch (event) {
        _Init() => _init(event, emit),
        _LoadMore() => _loadMore(event, emit),
        _AddFavorite() => _addFavorite(event, emit),
        _RemoveFavorite() => _removeFavorite(event, emit),
      };
    });
  }

  Future<void> _init(_Init event, Emitter<ProductState> emit) async {
    final products = await _repository.fetchProducts();
    final favoriteProducts = await _repository.getFavoriteProducts();
    emit(
      state.copyWith(products: products, favoriteProducts: favoriteProducts),
    );
  }

  Future<void> _loadMore(_LoadMore event, Emitter<ProductState> emit) async {
    final products = state.products;
    if (products == null) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true));
    final newProducts = await _repository.fetchProducts(
      limit: products.limit,
      skip: products.limit + products.skip,
    );

    emit(
      state.copyWith(
        products: PaginatedResponse(
          data: [...products.data, ...newProducts.data],
          total: newProducts.total,
          skip: newProducts.skip,
          limit: newProducts.limit,
        ),
        isLoadingMore: false,
      ),
    );
  }

  Future<void> _addFavorite(
    _AddFavorite event,
    Emitter<ProductState> emit,
  ) async {
    final success = await _repository.addFavorite(event.id);
    if (success) {
      final favoriteProducts = await _repository.getFavoriteProducts();
      emit(state.copyWith(favoriteProducts: [...favoriteProducts]));
    }
  }

  Future<void> _removeFavorite(
    _RemoveFavorite event,
    Emitter<ProductState> emit,
  ) async {
    final success = await _repository.removeFavorite(event.id);
    if (success) {
      final favoriteProducts = await _repository.getFavoriteProducts();
      emit(state.copyWith(favoriteProducts: [...favoriteProducts]));
    }
  }
}
