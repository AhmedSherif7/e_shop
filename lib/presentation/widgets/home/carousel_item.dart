import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../../domain/entities/product.dart';
import '../../blocs/user/user_bloc.dart';
import '../../resources/colors_manager.dart';
import '../../screens/product_screen.dart';

class CarouselItem extends StatelessWidget {
  const CarouselItem(this.product, {Key? key}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
      child: ClipRRect(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: ColorManager.primary,
                borderRadius: BorderRadius.circular(
                  30.0,
                ),
              ),
            ),
            Positioned(
              top: 22.0,
              right: 22.0,
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: IconButton(
                  tooltip: 'Add to Favorites',
                  splashColor: ColorManager.lightGrey350,
                  highlightColor: ColorManager.lightGrey350,
                  onPressed: () {
                    context.read<UserBloc>().add(
                          UserProductFavoriteToggled(
                            context.read<UserBloc>().state.user.favorites,
                            product,
                          ),
                        );
                  },
                  icon: Builder(
                    builder: (context) {
                      return Icon(
                        context.select<UserBloc, bool>(
                          (bloc) => bloc.isFavorite(product.id),
                        )
                            ? Ionicons.heart
                            : Ionicons.heart_outline,
                        color: ColorManager.red,
                        size: 36.0,
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: 70.0,
              right: 22.0,
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: IconButton(
                  tooltip: 'Add to cart',
                  splashColor: ColorManager.lightGrey350,
                  highlightColor: ColorManager.lightGrey350,
                  onPressed: () {
                    context.read<UserBloc>().add(
                          UserProductCartToggled(
                            context.read<UserBloc>().state.user.cartProducts,
                            product,
                          ),
                        );
                  },
                  icon: Builder(
                    builder: (context) {
                      return Icon(
                        context.select<UserBloc, bool>(
                          (bloc) => bloc.isInCart(product.id),
                        )
                            ? Ionicons.cart
                            : Ionicons.cart_outline,
                        color: ColorManager.black,
                        size: 36.0,
                      );
                    },
                  ),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(-0.5, -0.8),
              child: Image(
                image: NetworkImage(product.images[0]),
                height: 135.0,
                width: 135.0,
              ),
            ),
            Align(
              alignment: const Alignment(-1.35, -0.85),
              child: RotationTransition(
                turns: const AlwaysStoppedAnimation(-45 / 360),
                child: Container(
                  height: 20.0,
                  width: 120.0,
                  decoration: const BoxDecoration(
                    color: ColorManager.indigo,
                  ),
                  child: Text(
                    '${((product.discount / product.price) * 100).toStringAsFixed(0)}%',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: ColorManager.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 64.0,
              left: 12.0,
              right: 8.0,
              child: Text(
                product.name,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: ColorManager.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NunitoSans',
                ),
              ),
            ),
            Positioned(
              bottom: 25.0,
              right: 0.0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                height: 42.0,
                decoration: const BoxDecoration(
                  color: ColorManager.secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14.0),
                    bottomLeft: Radius.circular(14.0),
                  ),
                ),
                child: Text(
                  '\$${product.price}',
                  style: const TextStyle(
                    color: ColorManager.white,
                    fontSize: 22.0,
                    fontFamily: 'NunitoSans',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
