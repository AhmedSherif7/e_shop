import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../blocs/login/login_cubit.dart';
import '../../resources/colors_manager.dart';
import 'auth_custom_text_field.dart';

class LoginPasswordField extends StatelessWidget {
  const LoginPasswordField(
    this._controller,
    this._passwordFocusNode, {
    Key? key,
  }) : super(key: key);

  final TextEditingController _controller;
  final FocusNode _passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) {
        return previous.password != current.password ||
            previous.isPasswordHidden != current.isPasswordHidden ||
            previous.status != current.status;
      },
      builder: (context, state) {
        return AuthCustomTextField(
          enabled: !state.status.isSubmissionInProgress,
          controller: _controller,
          textInputType: TextInputType.visiblePassword,
          labelText: 'Password',
          obscureText: state.isPasswordHidden,
          prefixIcon: Icons.lock,
          errorText: state.password.invalid ? 'password is too short' : null,
          focusNode: _passwordFocusNode,
          onChanged: (password) {
            context.read<LoginCubit>().passwordChanged(password!);
          },
          onSubmitted: (value) {
            FocusScope.of(context).unfocus();
            if (state.status.isValid) {
              context.read<LoginCubit>().submitLogin();
            }
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
              context.read<LoginCubit>().togglePasswordVisibility();
            },
          ),
        );
      },
    );
  }
}
