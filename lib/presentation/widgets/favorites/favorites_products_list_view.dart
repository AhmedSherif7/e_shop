import 'package:flutter/material.dart';

import '../../../domain/entities/product.dart';
import 'favorites_product_list_item.dart';

class FavoritesProductsListView extends StatelessWidget {
  const FavoritesProductsListView(this.favorites, {Key? key}) : super(key: key);

  final List<Product> favorites;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return FavoriteProductsListItem(
            favorites[index],
            index,
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 10.0,
          );
        },
      ),
    );
  }
}
