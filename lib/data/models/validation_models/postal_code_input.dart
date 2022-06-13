import 'package:formz/formz.dart';

enum PostalCodeValidationError { invalid }

class PostalCodeInput extends FormzInput<String, PostalCodeValidationError> {
  const PostalCodeInput.pure() : super.pure('');

  const PostalCodeInput.dirty([String value = '']) : super.dirty(value);

  @override
  PostalCodeValidationError? validator(String? value) {
    if (value == null) {
      return PostalCodeValidationError.invalid;
    }
    final code = int.tryParse(value);
    return code == null || code < 0 || value.isEmpty
        ? PostalCodeValidationError.invalid
        : null;
  }

  @override
  String toString() {
    return 'postalCode';
  }
}
