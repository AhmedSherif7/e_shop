import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../blocs/theme/theme_cubit.dart';
import '../../resources/assets_manager.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';

class EmptyOrderScreenBody extends StatelessWidget {
  const EmptyOrderScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BlocBuilder<ThemeCubit, ThemeState>(builder: (context, state) {
            return Text(
              'No orders found !!',
              style: TextStyle(
                fontSize: 24.0,
                fontFamily: FontFamilyManager.nunitoSans,
                color:
                    state.isDarkMode ? ColorManager.white : ColorManager.black,
              ),
            );
          }),
          Lottie.asset(
            AssetJsonManager.emptyOrders,
            repeat: false,
          ),
        ],
      ),
    );
  }
}
