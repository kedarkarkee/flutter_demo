part of 'product_bloc.dart';

class ProductState extends Equatable {
  final PaginatedResponse<ProductEntity>? products;
  final List<int> favoriteProducts;
  final bool isLoadingMore;

  const ProductState({
    this.products,
    required this.favoriteProducts,
    required this.isLoadingMore,
  });

  const ProductState.initial()
    : this(favoriteProducts: const [], isLoadingMore: false);

  ProductState copyWith({
    PaginatedResponse<ProductEntity>? products,
    bool? isLoadingMore,
    List<int>? favoriteProducts,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
    );
  }

  @override
  List<Object?> get props => [products, isLoadingMore, favoriteProducts];
}
