import 'package:flutter/material.dart';

import '../../resources/colors_manager.dart';

class AuthCustomTextField extends StatelessWidget {
  const AuthCustomTextField({
    Key? key,
    required this.controller,
    this.obscureText = false,
    required this.textInputType,
    required this.labelText,
    required this.prefixIcon,
    this.suffixWidget,
    this.enabled = true,
    this.onChanged,
    this.errorText,
    this.onSubmitted,
    this.focusNode,
  }) : super(key: key);

  final TextEditingController controller;
  final bool obscureText;
  final TextInputType textInputType;
  final String labelText;
  final IconData prefixIcon;
  final Widget? suffixWidget;
  final bool enabled;
  final Function(String? value)? onChanged;
  final String? errorText;
  final Function(String? value)? onSubmitted;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // initialValue: ,
      onChanged: onChanged,
      enabled: enabled,
      controller: controller,
      keyboardType: textInputType,
      cursorColor: ColorManager.black,
      onFieldSubmitted: onSubmitted,
      focusNode: focusNode,
      decoration: InputDecoration(
        errorText: errorText,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: ColorManager.black,
          ),
        ),
        labelText: labelText,
        labelStyle: const TextStyle(
          color: ColorManager.black,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: ColorManager.grey,
        ),
        suffixIcon: suffixWidget,
      ),
      style: const TextStyle(
        fontSize: 16.0,
      ),
      obscureText: obscureText,
    );
  }
}
