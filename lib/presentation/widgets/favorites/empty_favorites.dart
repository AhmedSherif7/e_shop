import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../blocs/theme/theme_cubit.dart';
import '../../resources/assets_manager.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';

class EmptyFavorites extends StatelessWidget {
  const EmptyFavorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return Text(
                'You have no favorites !!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26.0,
                  color: state.isDarkMode
                      ? ColorManager.white
                      : ColorManager.black,
                  fontWeight: FontWeight.w300,
                  fontFamily: FontFamilyManager.montserrat,
                ),
              );
            },
          ),
          LottieBuilder.asset(
            AssetJsonManager.emptyFavorites,
            repeat: false,
            height: 350.0,
          ),
        ],
      ),
    );
  }
}
