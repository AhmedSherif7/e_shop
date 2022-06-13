import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/home/home_cubit.dart';
import '../blocs/home_carousel/home_carousel_cubit.dart';
import '../resources/colors_manager.dart';
import '../widgets/home/carousel_indicator.dart';
import '../widgets/home/carousel_item.dart';
import '../widgets/home/products_grid_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CarouselController _controller = CarouselController();

    return BlocProvider<HomeCarouselCubit>(
      create: (_) => HomeCarouselCubit(),
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeCubit>().getHomeProducts();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              left: 12.0,
              right: 12.0,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      color: ColorManager.primary,
                      width: 4.0,
                      height: 26.0,
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      'Featured Deals',
                      style: Theme.of(context).textTheme.headline6!,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                FadeInRight(
                  child: SizedBox(
                    height: 240.0,
                    child: BlocBuilder<HomeCarouselCubit, HomeCarouselState>(
                      buildWhen: (previous, current) =>
                          previous.childIndex != current.childIndex,
                      builder: (context, state) {
                        return CarouselSlider.builder(
                          options: CarouselOptions(
                            initialPage: 0,
                            onPageChanged:
                                context.read<HomeCarouselCubit>().changeChild,
                            height: 400.0,
                            clipBehavior: Clip.none,
                            enlargeCenterPage: true,
                            autoPlay: false,
                            pauseAutoPlayOnTouch: true,
                            enableInfiniteScroll: false,
                          ),
                          carouselController: _controller,
                          itemCount:
                              context.read<HomeCubit>().state.offers.length,
                          itemBuilder: (
                            BuildContext context,
                            int itemIndex,
                            int pageViewIndex,
                          ) {
                            return CarouselItem(
                              context.read<HomeCubit>().state.offers[itemIndex],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                CarouselIndicator(_controller),
                Row(
                  children: [
                    Container(
                      color: ColorManager.primary,
                      width: 4.0,
                      height: 26.0,
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      'Popular Products',
                      style: Theme.of(context).textTheme.headline6!,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                FadeInLeft(
                  child: const ProductsGridView(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
