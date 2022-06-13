import 'package:formz/formz.dart';

enum PasswordValidationError { invalid }

class LoginPassword extends FormzInput<String, PasswordValidationError> {
  const LoginPassword.pure() : super.pure('');

  const LoginPassword.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError? validator(String? value) {
    return value == null || value.length < 8
        ? PasswordValidationError.invalid
        : null;
  }
}
