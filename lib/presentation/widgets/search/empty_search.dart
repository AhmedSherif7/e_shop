import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../blocs/theme/theme_cubit.dart';
import '../../resources/assets_manager.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';

class EmptySearch extends StatelessWidget {
  const EmptySearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400.0,
      child: Column(
        children: [
          const SizedBox(
            height: 60.0,
          ),
          BlocBuilder<ThemeCubit, ThemeState>(builder: (context, state) {
            return Text(
              'No results found !!',
              style: TextStyle(
                fontSize: 26.0,
                fontFamily: FontFamilyManager.montserrat,
                fontWeight: FontWeight.w600,
                color:
                    state.isDarkMode ? ColorManager.white : ColorManager.black,
              ),
            );
          }),
          const SizedBox(
            height: 40.0,
          ),
          Lottie.asset(
            AssetJsonManager.emptySearch,
            repeat: true,
          ),
        ],
      ),
    );
  }
}
