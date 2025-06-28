import 'package:demo/core/locator/locator.dart';
import 'package:demo/features/product/domain/repo/product_repository.dart';
import 'package:demo/features/product/presentation/pages/bloc/product_bloc.dart';
import 'package:demo/features/product/presentation/widgets/lazy_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductBloc>(
      create: (context) =>
          ProductBloc(locator<ProductRepository>())..add(ProductEvent.init()),
      child: Scaffold(
        appBar: AppBar(title: Text('Product Page')),
        body: BlocBuilder<ProductBloc, ProductState>(
          buildWhen: (previousState, currentState) {
            return previousState.products != currentState.products ||
                previousState.isLoadingMore != currentState.isLoadingMore ||
                previousState.favoriteProducts != currentState.favoriteProducts;
          },
          builder: (context, state) {
            final products = state.products?.data;
            if (products == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return LazyLoader(
              onLazyLoad: () {
                context.read<ProductBloc>().add(ProductEvent.loadMore());
              },
              child: ListView.separated(
                padding: EdgeInsets.all(8),
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemCount: state.isLoadingMore
                    ? products.length + 1
                    : products.length,
                itemBuilder: (context, index) {
                  if (state.isLoadingMore && index == products.length) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final product = products.elementAt(index);
                  final isFavorite = state.favoriteProducts.contains(
                    product.id,
                  );

                  return ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    leading: SizedBox(
                      width: 60,
                      height: 60,
                      child: FittedBox(
                        child: CachedNetworkImage(imageUrl: product.image),
                      ),
                    ),
                    title: Text(product.title),
                    subtitle: Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: isFavorite
                          ? Icon(Icons.favorite, color: Colors.red)
                          : Icon(Icons.favorite_border),
                      onPressed: () {
                        if (isFavorite) {
                          context.read<ProductBloc>().add(
                            ProductEvent.removeFavorite(product.id),
                          );
                        } else {
                          context.read<ProductBloc>().add(
                            ProductEvent.addFavorite(product.id),
                          );
                        }
                      },
                    ),
                    onTap: () {
                      context.go('/product/detail');
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
