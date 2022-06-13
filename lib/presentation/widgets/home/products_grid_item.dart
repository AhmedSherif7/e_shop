import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ionicons/ionicons.dart';

import '../../../domain/entities/product.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../blocs/user/user_bloc.dart';
import '../../resources/assets_manager.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';
import '../../screens/product_screen.dart';
import '../image_load_error.dart';

class ProductsGridItem extends StatelessWidget {
  const ProductsGridItem(this.product, this.index, {Key? key})
      : super(key: key);

  final Product product;
  final int index;

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
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return Container(
            color: state.isDarkMode
                ? ColorManager.black
                : ColorManager.lightBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Card(
                      color: Theme.of(context).cardColor,
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Hero(
                          tag: product.id,
                          child: FadeInImage.assetNetwork(
                            image: product.images[0],
                            width: 200.0,
                            height: 220.0,
                            placeholder: AssetImageManager.productPlaceHolder,
                            imageErrorBuilder: (context, object, stack) {
                              return const ImageLoadError();
                            },
                          ),
                        ),
                      ),
                    ),
                    if (product.discount > 0)
                      Positioned.fill(
                        child: Align(
                          alignment: const Alignment(-0.82, -0.88),
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              '${((product.discount / product.price) * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: ColorManager.white,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: ColorManager.secondary,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                    Positioned.fill(
                      child: Align(
                        alignment: const Alignment(0.95, 1.1),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorManager.lightGrey350,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: IconButton(
                              splashRadius: 24.0,
                              tooltip: 'Add to favorites',
                              onPressed: () {
                                context.read<UserBloc>().add(
                                      UserProductFavoriteToggled(
                                        context
                                            .read<UserBloc>()
                                            .state
                                            .user
                                            .favorites,
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
                                    size: 26.0,
                                  );
                                },
                              ),
                              splashColor: ColorManager.lightGrey100,
                              highlightColor: ColorManager.lightGrey100,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 4.0,
                    bottom: 4.0,
                    top: 2.0,
                  ),
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
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    product.category.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ColorManager.grey,
                      fontSize: 16.0,
                      fontFamily: FontFamilyManager.nunitoSans,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    product.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: state.isDarkMode
                          ? ColorManager.white
                          : ColorManager.black,
                      fontSize: 20.0,
                      fontFamily: FontFamilyManager.montserrat,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 4.0,
                    top: 6.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (product.discount > 0)
                        Text(
                          '${product.price + product.discount}',
                          style: const TextStyle(
                            color: ColorManager.grey,
                            fontSize: 14.0,
                            decoration: TextDecoration.lineThrough,
                            decorationThickness: 2.0,
                          ),
                        ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'EGP ${product.price}',
                        style: const TextStyle(
                          color: ColorManager.blue,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
