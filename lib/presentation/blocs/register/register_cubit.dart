import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../data/models/validation_models/confirmed_password_input.dart';
import '../../../data/models/validation_models/email_input.dart';
import '../../../data/models/validation_models/register_password_input.dart';
import '../../../domain/use_cases/register_use_case.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterCubit(this._registerUseCase) : super(const RegisterState());

  void emailChanged(String value) {
    final email = EmailInput.dirty(value);
    emit(
      state.copyWith(
        email: email,
        status: Formz.validate([
          email,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = RegisterPassword.dirty(value);
    emit(
      state.copyWith(
        password: password,
        status: Formz.validate([
          state.email,
          password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword =
        ConfirmedPassword.dirty(value, state.password.value);
    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword,
        status: Formz.validate([
          state.email,
          state.password,
          confirmedPassword,
        ]),
      ),
    );
  }

  void submitRegister() async {
    emit(
      state.copyWith(
        status: FormzStatus.submissionInProgress,
      ),
    );

    final result = await _registerUseCase(
      RegisterUseCaseInput(
        state.email.value,
        state.password.value,
      ),
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
      (userData) {
        emit(
          state.copyWith(
            status: FormzStatus.submissionSuccess,
          ),
        );
      },
    );
  }

  void togglePasswordVisibility() {
    emit(
      state.copyWith(
        isPasswordHidden: !state.isPasswordHidden,
      ),
    );
  }

  void toggleConfirmedPasswordVisibility() {
    emit(
      state.copyWith(
        isConfirmedPasswordHidden: !state.isConfirmedPasswordHidden,
      ),
    );
  }
}
