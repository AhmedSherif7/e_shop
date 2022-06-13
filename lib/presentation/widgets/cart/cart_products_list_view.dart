import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/theme/theme_cubit.dart';
import '../../resources/colors_manager.dart';
import 'cart_product_list_item.dart';

class CartProductsListView extends StatelessWidget {
  const CartProductsListView(this.cartProducts, {Key? key}) : super(key: key);

  final List<Map<String, dynamic>> cartProducts;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          shrinkWrap: true,
          primary: false,
          itemCount: cartProducts.length,
          itemBuilder: (context, index) {
            return CartProductsListItem(
              product: cartProducts[index]['product'],
              count: cartProducts[index]['count'],
            );
          },
          separatorBuilder: (context, index) {
            return BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return Container(
                  color: state.isDarkMode
                      ? ColorManager.lightGrey100
                      : ColorManager.grey,
                  height: 1.0,
                  width: double.infinity,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
