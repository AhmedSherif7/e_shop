import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/theme/theme_cubit.dart';
import '../resources/colors_manager.dart';
import '../resources/font_manager.dart';

class FilterOption extends StatelessWidget {
  const FilterOption({
    required this.title,
    required this.options,
    required this.clearFunction,
    Key? key,
  }) : super(key: key);

  final String title;
  final Widget options;
  final VoidCallback clearFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: Row(
              children: [
                BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    return Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: FontFamilyManager.montserrat,
                        color: state.isDarkMode
                            ? ColorManager.white
                            : ColorManager.black,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Card(
              color: ColorManager.lightGrey100,
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: [
                    options,
                    TextButton(
                      onPressed: clearFunction,
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          color: ColorManager.indigo,
                        ),
                      ),
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                          Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
