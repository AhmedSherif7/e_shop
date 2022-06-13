import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ionicons/ionicons.dart';

import '../../app/di.dart';
import '../../domain/entities/product.dart';
import '../blocs/theme/theme_cubit.dart';
import '../blocs/user/user_bloc.dart';
import '../resources/colors_manager.dart';
import '../resources/font_manager.dart';
import 'category_screen.dart';
import 'product_images_screen.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen(this.product, {Key? key}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Ionicons.chevron_back),
        ),
        actions: [
          IconButton(
            splashRadius: 24.0,
            tooltip: 'Add to favorites',
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
                  size: 30.0,
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 300.0,
                child: BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    return Swiper(
                      outer: true,
                      indicatorLayout: PageIndicatorLayout.SCALE,
                      layout: SwiperLayout.DEFAULT,
                      loop: false,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            initProductImageModule();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ProductImagesScreen(
                                    product.images[index],
                                    index,
                                    product.name,
                                  );
                                },
                              ),
                            );
                          },
                          child: Hero(
                            tag: product.id,
                            child: Image.network(
                              product.images[index],
                              width: 300.0,
                              height: 300.0,
                            ),
                          ),
                        );
                      },
                      itemCount: product.images.length,
                      pagination: SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                          size: 14.0,
                          activeColor: ColorManager.primary,
                          color: state.isDarkMode
                              ? ColorManager.white
                              : ColorManager.black,
                        ),
                      ),
                      control: null,
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 30.0,
                      fontFamily: FontFamilyManager.nunitoSans,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                        Colors.transparent,
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(0),
                      ),
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(
                          fontSize: 18.0,
                          fontFamily: FontFamilyManager.nunitoSans,
                        ),
                      ),
                    ),
                    onPressed: () {
                      initCategoriesModule();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            return BlocProvider.value(
                              value: context.read<UserBloc>(),
                              child: CategoryScreen(
                                product.category.name,
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      'in ${product.category.name}',
                    ),
                  ),
                ],
              ),
              Text(
                product.description,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontFamily: FontFamilyManager.montserrat,
                  color: ColorManager.grey,
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: RatingBar.builder(
                  initialRating: product.rate,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  ignoreGestures: true,
                  maxRating: 5,
                  unratedColor: ColorManager.grey,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) {
                    return const Icon(
                      Icons.star,
                      color: ColorManager.amber,
                    );
                  },
                  itemSize: 22.0,
                  onRatingUpdate: (double value) {},
                ),
              ),
              Text(
                'only ${product.countInStock} left in stock',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontFamily: FontFamilyManager.nunitoSans,
                  color: ColorManager.secondary,
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return Container(
            color: state.isDarkMode
                ? ColorManager.black
                : ColorManager.lightBackground,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              child: Row(
                children: [
                  if (product.discount > 0)
                    Text(
                      '${product.price + product.discount}',
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: ColorManager.grey,
                        fontFamily: FontFamilyManager.nunitoSans,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  if (product.discount > 0)
                    const SizedBox(
                      width: 6.0,
                    ),
                  Text(
                    '${product.price} EGP',
                    style: const TextStyle(
                      fontSize: 24.0,
                      color: ColorManager.indigo,
                      fontFamily: FontFamilyManager.nunitoSans,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<UserBloc>().add(
                UserProductCartToggled(
                  context.read<UserBloc>().state.user.cartProducts,
                  product,
                ),
              );
        },
        child: Builder(
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
    );
  }
}
