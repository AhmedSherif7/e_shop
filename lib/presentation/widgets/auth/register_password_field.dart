import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../blocs/register/register_cubit.dart';
import '../../resources/colors_manager.dart';
import 'auth_custom_text_field.dart';

class RegisterPasswordField extends StatelessWidget {
  const RegisterPasswordField(
    this._controller,
    this._passwordFocusNode,
    this._confirmedPasswordFocusNode, {
    Key? key,
  }) : super(key: key);

  final TextEditingController _controller;
  final FocusNode _passwordFocusNode;
  final FocusNode _confirmedPasswordFocusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.isPasswordHidden != current.isPasswordHidden ||
          previous.status != current.status,
      builder: (context, state) {
        return AuthCustomTextField(
          enabled: !state.status.isSubmissionInProgress,
          controller: _controller,
          textInputType: TextInputType.visiblePassword,
          labelText: 'Password',
          obscureText: state.isPasswordHidden,
          prefixIcon: Icons.lock,
          errorText: state.password.invalid ? 'password is too week' : null,
          focusNode: _passwordFocusNode,
          onChanged: (password) {
            context.read<RegisterCubit>().passwordChanged(password!);
            context
                .read<RegisterCubit>()
                .confirmedPasswordChanged(state.confirmedPassword.value);
          },
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(_confirmedPasswordFocusNode);
          },
          suffixWidget: IconButton(
            icon: Icon(
              state.isPasswordHidden
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: state.isPasswordHidden
                  ? ColorManager.grey
                  : ColorManager.black,
            ),
            onPressed: () {
              context.read<RegisterCubit>().togglePasswordVisibility();
            },
          ),
        );
      },
    );
  }
}
