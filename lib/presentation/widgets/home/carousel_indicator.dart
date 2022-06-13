import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/home/home_cubit.dart';
import '../../blocs/home_carousel/home_carousel_cubit.dart';
import '../../resources/colors_manager.dart';

class CarouselIndicator extends StatelessWidget {
  const CarouselIndicator(this.controller, {Key? key}) : super(key: key);

  final CarouselController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          context.read<HomeCubit>().state.products.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () {
            controller.animateToPage(
              entry.key,
              curve: Curves.bounceInOut,
              duration: const Duration(milliseconds: 400),
            );
          },
          child: BlocBuilder<HomeCarouselCubit, HomeCarouselState>(
            buildWhen: (previous, current) =>
                previous.childIndex != current.childIndex,
            builder: (context, state) {
              return Container(
                width: 8.5,
                height: 8.5,
                margin: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 4.0,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: state.childIndex == entry.key
                      ? ColorManager.primary
                      : ColorManager.lightGrey350,
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
