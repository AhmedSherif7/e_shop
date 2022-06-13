import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../blocs/login/login_cubit.dart';
import 'auth_custom_text_field.dart';

class LoginEmailField extends StatelessWidget {
  const LoginEmailField(this._emailController, this._passwordFocusNode,
      {Key? key})
      : super(key: key);

  final TextEditingController _emailController;
  final FocusNode _passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) {
        return previous.email != current.email ||
            previous.status != current.status;
      },
      builder: (context, state) {
        return AuthCustomTextField(
          enabled: !state.status.isSubmissionInProgress,
          controller: _emailController,
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
          textInputType: TextInputType.emailAddress,
          labelText: 'E-mail',
          prefixIcon: Icons.email,
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email!),
          errorText: state.email.invalid ? 'invalid email' : null,
        );
      },
    );
  }
}
