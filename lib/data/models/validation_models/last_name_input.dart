import 'package:formz/formz.dart';

enum NameValidationError { invalid }

class LastNameInput extends FormzInput<String, NameValidationError> {
  const LastNameInput.pure([String value = '']) : super.pure(value);

  const LastNameInput.dirty([String value = '']) : super.dirty(value);

  @override
  NameValidationError? validator(String? value) {
    return value == null || value.isEmpty ? NameValidationError.invalid : null;
  }

  @override
  String toString() {
    return 'lastName';
  }
}
