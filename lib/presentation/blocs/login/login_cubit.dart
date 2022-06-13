import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';

import '../../../data/models/validation_models/email_input.dart';
import '../../../data/models/validation_models/login_password_input.dart';
import '../../../domain/use_cases/login_use_case.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(const LoginState());

  void emailChanged(String value) {
    final email = EmailInput.dirty(value);

    emit(
      state.copyWith(
        email: email,
        status: Formz.validate([
          email,
          state.password,
        ]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = LoginPassword.dirty(value);

    emit(
      state.copyWith(
        password: password,
        status: Formz.validate([
          state.email,
          password,
        ]),
      ),
    );
  }

  void togglePasswordVisibility() {
    emit(
      state.copyWith(
        isPasswordHidden: !state.isPasswordHidden,
      ),
    );
  }

  void submitLogin() async {
    emit(
      state.copyWith(
        status: FormzStatus.submissionInProgress,
      ),
    );

    final result = await loginUseCase(
      LoginUseCaseInput(state.email.value, state.password.value),
    );

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: FormzStatus.submissionFailure,
            errorMessage: error.message,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            status: FormzStatus.submissionSuccess,
          ),
        );
      },
    );
  }
}
