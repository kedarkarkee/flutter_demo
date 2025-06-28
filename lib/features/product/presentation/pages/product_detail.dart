import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Detail Page')),
      body: Center(
        child: Text(
          'This is a product detail page. Used just to test stateful shell navigation',
        ),
      ),
    );
  }
}
