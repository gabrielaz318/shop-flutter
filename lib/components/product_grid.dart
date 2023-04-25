import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product_grid_item.dart';

import '../models/product.dart';
import '../models/product_list.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoriteOnly;

  const ProductGrid(this.showFavoriteOnly, {super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final List<Product> loadedProducts = showFavoriteOnly ? provider.favoriteItems : provider.items;

    return GridView.builder(
      itemCount: loadedProducts.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: loadedProducts[index],
        child: const ProductGridItem(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8),
    );
  }
}
