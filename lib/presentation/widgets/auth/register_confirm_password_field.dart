import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../blocs/register/register_cubit.dart';
import '../../resources/colors_manager.dart';
import 'auth_custom_text_field.dart';

class RegisterConfirmPasswordField extends StatelessWidget {
  const RegisterConfirmPasswordField(this._controller, this._focusNode,
      {Key? key})
      : super(key: key);

  final TextEditingController _controller;
  final FocusNode _focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) =>
          previous.confirmedPassword != current.confirmedPassword ||
          previous.isConfirmedPasswordHidden !=
              current.isConfirmedPasswordHidden ||
          previous.status != current.status,
      builder: (context, state) {
        return AuthCustomTextField(
          enabled: !state.status.isSubmissionInProgress,
          controller: _controller,
          textInputType: TextInputType.visiblePassword,
          labelText: 'Confirm Password',
          obscureText: state.isConfirmedPasswordHidden,
          prefixIcon: Icons.lock,
          focusNode: _focusNode,
          errorText: state.confirmedPassword.invalid
              ? 'password does not match'
              : null,
          onChanged: (confirmedPassword) => context
              .read<RegisterCubit>()
              .confirmedPasswordChanged(confirmedPassword!),
          onSubmitted: (value) {
            FocusScope.of(context).unfocus();
            if (state.status.isValid) {
              context.read<RegisterCubit>().submitRegister();
            }
          },
          suffixWidget: IconButton(
            icon: Icon(
              state.isConfirmedPasswordHidden
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: state.isConfirmedPasswordHidden
                  ? ColorManager.grey
                  : ColorManager.black,
            ),
            onPressed: () {
              context.read<RegisterCubit>().toggleConfirmedPasswordVisibility();
            },
          ),
        );
      },
    );
  }
}
