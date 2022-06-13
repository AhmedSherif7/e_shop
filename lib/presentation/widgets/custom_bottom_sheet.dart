import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/theme/theme_cubit.dart';
import '../resources/colors_manager.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Container(
          color: state.isDarkMode ? ColorManager.black38 : ColorManager.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 25.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: state.isDarkMode
                        ? ColorManager.white
                        : ColorManager.grey,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                Expanded(
                  child: child,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
