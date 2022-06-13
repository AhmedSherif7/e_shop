import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/theme/theme_cubit.dart';
import '../../resources/colors_manager.dart';

class CheckoutAddressField extends StatelessWidget {
  const CheckoutAddressField({
    required this.controller,
    required this.label,
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            style: TextStyle(
              color: state.isDarkMode ? ColorManager.white : ColorManager.black,
            ),
            controller: controller,
            enabled: false,
            decoration: InputDecoration(
              label: Text(label),
              labelStyle: const TextStyle(
                color: ColorManager.black38,
              ),
              floatingLabelStyle: TextStyle(
                color:
                    state.isDarkMode ? ColorManager.white : ColorManager.black,
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  color: ColorManager.lightGrey350,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
