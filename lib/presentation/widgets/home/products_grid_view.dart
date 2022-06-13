import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/home/home_cubit.dart';
import 'products_grid_item.dart';

class ProductsGridView extends StatelessWidget {
  const ProductsGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 380.0,
        mainAxisSpacing: 1.0,
        crossAxisSpacing: 12.0,
      ),
      primary: false,
      shrinkWrap: true,
      itemCount: context.read<HomeCubit>().state.products.length,
      itemBuilder: (context, index) {
        final product = context.read<HomeCubit>().state.products[index];
        return ProductsGridItem(product, index);
      },
    );
  }
}
