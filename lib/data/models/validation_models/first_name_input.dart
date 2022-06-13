import 'package:formz/formz.dart';

enum NameValidationError { invalid }

class FirstNameInput extends FormzInput<String, NameValidationError> {
  const FirstNameInput.pure([String value = '']) : super.pure(value);

  const FirstNameInput.dirty([String value = '']) : super.dirty(value);

  @override
  NameValidationError? validator(String? value) {
    return value == null || value.isEmpty ? NameValidationError.invalid : null;
  }

  @override
  String toString() {
    return 'firstName';
  }
}
