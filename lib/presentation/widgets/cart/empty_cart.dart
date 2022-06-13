import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../blocs/theme/theme_cubit.dart';
import '../../resources/assets_manager.dart';
import '../../resources/colors_manager.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500.0,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return Text(
                'Your cart is Empty, start adding products',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26.0,
                  color: state.isDarkMode
                      ? ColorManager.white
                      : ColorManager.black,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Montserrat',
                ),
              );
            },
          ),
          LottieBuilder.asset(
            AssetJsonManager.emptyCart,
            repeat: false,
          ),
        ],
      ),
    );
  }
}
