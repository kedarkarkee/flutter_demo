part of 'product_bloc.dart';

sealed class ProductEvent {
  const ProductEvent();
  factory ProductEvent.init() = _Init;
  factory ProductEvent.loadMore() = _LoadMore;
  factory ProductEvent.addFavorite(int id) = _AddFavorite;
  factory ProductEvent.removeFavorite(int id) = _RemoveFavorite;
}

class _Init extends ProductEvent {}

class _LoadMore extends ProductEvent {}

class _AddFavorite extends ProductEvent {
  final int id;

  _AddFavorite(this.id);
}

class _RemoveFavorite extends ProductEvent {
  final int id;

  _RemoveFavorite(this.id);
}
