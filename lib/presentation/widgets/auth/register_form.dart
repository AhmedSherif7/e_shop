import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../blocs/register/register_cubit.dart';
import '../custom_button.dart';
import 'auth_loading_widget.dart';
import 'register_confirm_password_field.dart';
import 'register_email_field.dart';
import 'register_password_field.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.passwordFocusNode,
    required this.confirmedPasswordFocusNode,
  }) : super(key: key);

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final FocusNode passwordFocusNode;
  final FocusNode confirmedPasswordFocusNode;

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
                RegisterEmailField(
                  emailController,
                  passwordFocusNode,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                RegisterPasswordField(
                  passwordController,
                  passwordFocusNode,
                  confirmedPasswordFocusNode,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                RegisterConfirmPasswordField(
                  confirmPasswordController,
                  confirmedPasswordFocusNode,
                ),
                const SizedBox(
                  height: 22.0,
                ),
                BlocBuilder<RegisterCubit, RegisterState>(
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
                              context.read<RegisterCubit>().submitRegister();
                            }
                          : null,
                      title: 'Sign Up',
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
