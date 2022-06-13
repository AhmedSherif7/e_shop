import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/theme/theme_cubit.dart';
import '../../resources/colors_manager.dart';

class UserInfoCustomTextField extends StatelessWidget {
  const UserInfoCustomTextField({
    Key? key,
    this.controller,
    this.focusNode,
    required this.label,
    this.enabled = true,
    this.onChanged,
    this.onFieldSubmitted,
    this.errorText,
    this.textInputType,
    this.maxLength,
    this.initialValue,
  }) : super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String label;
  final bool enabled;
  final Function(String?)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? errorText;
  final TextInputType? textInputType;
  final int? maxLength;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return TextFormField(
            controller: controller,
            initialValue: initialValue,
            focusNode: focusNode,
            enabled: enabled,
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
            keyboardType: textInputType,
            maxLength: maxLength,
            style: TextStyle(
              color:
              state.isDarkMode ? ColorManager.white : ColorManager.black,
            ),
            decoration: InputDecoration(
              label: Text(label),
              labelStyle: TextStyle(
                color: state.isDarkMode
                    ? ColorManager.white
                    : ColorManager.black38,
              ),
              floatingLabelStyle: TextStyle(
                color:
                    state.isDarkMode ? ColorManager.white : ColorManager.black,
              ),
              counterText: '',
              errorText: errorText,
              errorMaxLines: 2,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(
                  color: state.isDarkMode
                      ? ColorManager.white
                      : ColorManager.black,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(
                  color: state.isDarkMode
                      ? ColorManager.white
                      : ColorManager.black,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(
                  color: state.isDarkMode
                      ? ColorManager.white
                      : ColorManager.black38,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  color: ColorManager.lightGrey350,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  color: ColorManager.red,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  color: ColorManager.red,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
