import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ionicons/ionicons.dart';

import '../../../domain/entities/product.dart';
import '../../blocs/home/home_cubit.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../blocs/user/user_bloc.dart';
import '../../resources/colors_manager.dart';
import '../../screens/product_screen.dart';

class CartProductsListItem extends StatelessWidget {
  const CartProductsListItem({
    required this.product,
    required this.count,
    Key? key,
  }) : super(key: key);

  final Product product;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Slidable(
        key: ValueKey(product.id),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(
            onDismissed: () {
              context.read<UserBloc>().add(
                    UserProductCartToggled(
                      context.read<UserBloc>().state.user.cartProducts,
                      product,
                    ),
                  );
            },
          ),
          children: [
            SlidableAction(
              onPressed: (context) {
                context.read<UserBloc>().add(
                      UserProductCartToggled(
                        context.read<UserBloc>().state.user.cartProducts,
                        product,
                      ),
                    );
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Ionicons.trash,
              label: 'Remove',
            ),
          ],
        ),
        child: SizedBox(
          height: 80.0,
          child: ListTile(
            leading: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return BlocProvider<UserBloc>.value(
                        value: context.read<UserBloc>(),
                        child: ProductScreen(product),
                      );
                    },
                  ),
                );
              },
              child: Hero(
                tag: product.id,
                child: Image(
                  image: NetworkImage(product.images[0]),
                  width: 60.0,
                  height: 120.0,
                ),
              ),
            ),
            title: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return Text(
                  product.name,
                  maxLines: 2,
                  style: TextStyle(
                    color: state.isDarkMode
                        ? ColorManager.white
                        : ColorManager.black,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            subtitle: SizedBox(
              height: 40.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'EGP ${double.parse((count * product.price).toStringAsFixed(2))}',
                    style: const TextStyle(
                      color: ColorManager.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (count > 1)
                    Text(
                      '($count x ${product.price})',
                      style: const TextStyle(
                        color: ColorManager.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  direction: Axis.horizontal,
                  children: [
                    CircleAvatar(
                      backgroundColor: count > 1
                          ? ColorManager.black26
                          : ColorManager.lightGrey100,
                      radius: 16.0,
                      child: IconButton(
                        splashRadius: 18.0,
                        iconSize: 28.0,
                        tooltip: 'Decrease',
                        padding: const EdgeInsets.all(0.0),
                        onPressed: count > 1
                            ? () {
                                context.read<UserBloc>().add(
                                      UserCartProductCountChanged(
                                        context
                                            .read<UserBloc>()
                                            .state
                                            .user
                                            .cartProducts,
                                        product.id,
                                        false,
                                      ),
                                    );
                              }
                            : null,
                        icon: Icon(
                          Ionicons.remove,
                          color:
                              count > 1 ? ColorManager.red : ColorManager.white,
                        ),
                        splashColor: ColorManager.primary,
                        highlightColor: ColorManager.primary,
                        disabledColor: ColorManager.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: ColorManager.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: count >=
                              context
                                  .read<HomeCubit>()
                                  .getProductCountInStock(product.id)
                          ? ColorManager.lightGrey100
                          : ColorManager.black26,
                      radius: 16.0,
                      child: IconButton(
                        splashRadius: 18.0,
                        iconSize: 28.0,
                        padding: const EdgeInsets.all(0.0),
                        tooltip: 'Increase',
                        onPressed: count >=
                                context
                                    .read<HomeCubit>()
                                    .getProductCountInStock(product.id)
                            ? null
                            : () {
                                context.read<UserBloc>().add(
                                      UserCartProductCountChanged(
                                        context
                                            .read<UserBloc>()
                                            .state
                                            .user
                                            .cartProducts,
                                        product.id,
                                        true,
                                      ),
                                    );
                              },
                        icon: Icon(
                          Ionicons.add,
                          color: count >=
                                  context
                                      .read<HomeCubit>()
                                      .getProductCountInStock(product.id)
                              ? ColorManager.white
                              : ColorManager.green,
                        ),
                        splashColor: ColorManager.primary,
                        highlightColor: ColorManager.primary,
                      ),
                    ),
                  ],
                ),
                Text(
                  '(only ${product.countInStock} left)',
                  style: const TextStyle(
                    color: ColorManager.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
