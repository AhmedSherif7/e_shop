import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/theme/theme_cubit.dart';
import '../../resources/colors_manager.dart';

class CheckoutContainer extends StatelessWidget {
  const CheckoutContainer({
    required this.title,
    required this.child,
    Key? key,
  }) : super(key: key);

  final List<Widget> title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 4.0,
          ),
          child: SizedBox(
            height: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: title,
            ),
          ),
        ),
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.all(10.0),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                  color: state.isDarkMode
                      ? ColorManager.white
                      : ColorManager.black38,
                ),
              ),
              child: child,
            );
          },
        ),
      ],
    );
  }
}
