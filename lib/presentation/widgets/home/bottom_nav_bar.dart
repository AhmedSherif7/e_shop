import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../blocs/home/home_cubit.dart';
import '../../blocs/nav/nav_cubit.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../resources/colors_manager.dart';
import '../bottom_nav_cart_widget.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NavCubit, NavState>(
      listener: (context, state) {
        if (state.pageIndex == 1) {
          context.read<HomeCubit>().getHomeCategories();
        }
      },
      buildWhen: (previous, current) => previous.pageIndex != current.pageIndex,
      builder: (context, state) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, theme) {
            return CurvedNavigationBar(
              color: theme.isDarkMode
                  ? ColorManager.black
                  : ColorManager.lightBackground,
              animationDuration: const Duration(milliseconds: 400),
              height: 65.0,
              backgroundColor: Theme.of(context).primaryColor,
              index: state.pageIndex,
              items: [
                Icon(
                  Ionicons.home,
                  color: theme.isDarkMode
                      ? ColorManager.lightBackground
                      : ColorManager.black,
                ),
                Icon(
                  Ionicons.library,
                  color: theme.isDarkMode
                      ? ColorManager.lightBackground
                      : ColorManager.black,
                ),
                const CartWidget(),
                BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    return Icon(
                      Ionicons.person,
                      color: state.isDarkMode
                          ? ColorManager.lightBackground
                          : ColorManager.black,
                    );
                  },
                ),
              ],
              onTap: context.read<NavCubit>().changeScreen,
            );
          },
        );
      },
    );
  }
}
