import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ionicons/ionicons.dart';

import '../../../domain/entities/product.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../blocs/user/user_bloc.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';
import '../../screens/product_screen.dart';

class FavoriteProductsListItem extends StatelessWidget {
  const FavoriteProductsListItem(
    this.product,
    this.index, {
    Key? key,
  }) : super(key: key);

  final Product product;
  final int index;

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
                    UserProductFavoriteToggled(
                      context.read<UserBloc>().state.user.favorites,
                      product,
                    ),
                  );
            },
          ),
          children: [
            SlidableAction(
              onPressed: (context) {
                context.read<UserBloc>().add(
                      UserProductFavoriteToggled(
                        context.read<UserBloc>().state.user.favorites,
                        product,
                      ),
                    );
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: ColorManager.white,
              icon: Ionicons.trash,
              label: 'Remove',
            ),
          ],
        ),
        endActionPane: ActionPane(
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
            Builder(
              builder: (context) {
                final inCart = context.select<UserBloc, bool>(
                    (value) => value.isInCart(product.id));

                return SlidableAction(
                  onPressed: (context) {
                    context.read<UserBloc>().add(
                          UserProductCartToggled(
                            context.read<UserBloc>().state.user.cartProducts,
                            product,
                          ),
                        );
                  },
                  backgroundColor: ColorManager.primary,
                  foregroundColor: ColorManager.white,
                  icon: inCart ? Ionicons.cart : Ionicons.cart_outline,
                  label: inCart ? 'Remove' : 'Add',
                );
              },
            ),
          ],
        ),
        child: SizedBox(
          height: 80.0,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '${index + 1}.',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontFamily: FontFamilyManager.nunitoSans,
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  leading: Hero(
                    tag: product.id,
                    child: Image(
                      image: NetworkImage(product.images[0]),
                      width: 60.0,
                      height: 120.0,
                    ),
                  ),
                  title: BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, state) {
                      return Text(
                        product.name,
                        style: TextStyle(
                          color: state.isDarkMode
                              ? ColorManager.white
                              : ColorManager.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: FontFamilyManager.montserrat,
                          fontSize: 20.0,
                        ),
                      );
                    },
                  ),
                  subtitle: Text(
                    'EGP ${product.price}',
                    style: const TextStyle(
                      color: ColorManager.blue,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamilyManager.nunitoSans,
                      fontSize: 16.0,
                    ),
                  ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
