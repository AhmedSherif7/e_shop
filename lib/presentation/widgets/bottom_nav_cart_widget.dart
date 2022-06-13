import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../blocs/theme/theme_cubit.dart';
import '../blocs/user/user_bloc.dart';
import '../resources/colors_manager.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return Icon(
              Ionicons.cart,
              color: state.isDarkMode
                  ? ColorManager.lightBackground
                  : ColorManager.black,
              size: 32.0,
            );
          },
        ),
        Positioned(
          top: 0.0,
          right: 0.0,
          child: CircleAvatar(
            backgroundColor: ColorManager.secondary,
            radius: 9.0,
            child: Builder(
              builder: (context) {
                return Text(
                  context
                      .select<UserBloc, int>(
                          (value) => value.state.totalCartProducts)
                      .toString(),
                  style: const TextStyle(
                    color: ColorManager.white,
                    fontSize: 11.0,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
