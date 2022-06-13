import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../blocs/login/login_cubit.dart';
import '../custom_button.dart';
import 'auth_loading_widget.dart';
import 'login_email_field.dart';
import 'login_password_field.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.passwordFocusNode,
  }) : super(key: key);

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          primary: false,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 8.0,
              bottom: 16.0,
            ),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.8),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LoginEmailField(
                  emailController,
                  passwordFocusNode,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                LoginPasswordField(
                  passwordController,
                  passwordFocusNode,
                ),
                const SizedBox(
                  height: 22.0,
                ),
                BlocBuilder<LoginCubit, LoginState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status,
                  builder: (context, state) {
                    if (state.status.isSubmissionInProgress) {
                      return const AuthLoadingWidget();
                    }
                    return CustomButton(
                      onTap: state.status.isValid ||
                              state.status.isSubmissionFailure
                          ? () {
                              FocusScope.of(context).unfocus();
                              context.read<LoginCubit>().submitLogin();
                            }
                          : null,
                      title: 'Login',
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
