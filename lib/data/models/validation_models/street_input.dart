import 'package:formz/formz.dart';

enum StreetValidationError { invalid }

class StreetInput extends FormzInput<String, StreetValidationError> {
  const StreetInput.pure() : super.pure('');

  const StreetInput.dirty([String value = '']) : super.dirty(value);

  @override
  StreetValidationError? validator(String? value) {
    return value == null || value.isEmpty ? StreetValidationError.invalid : null;
  }

  @override
  String toString() {
    return 'street';
  }
}
