import 'package:formz/formz.dart';

enum ConfirmedPasswordValidationError { invalid }

class ConfirmedPassword
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  final String password;

  const ConfirmedPassword.pure([this.password = '']) : super.pure('');

  const ConfirmedPassword.dirty([String value = '', this.password = ''])
      : super.dirty(value);

  @override
  ConfirmedPasswordValidationError? validator(String? value) {
    return value == null || value != password
        ? ConfirmedPasswordValidationError.invalid
        : null;
  }
}
