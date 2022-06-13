import 'package:formz/formz.dart';

enum PhoneValidationError { invalid }

class PhoneInput extends FormzInput<String, PhoneValidationError> {
  const PhoneInput.pure() : super.pure('');

  const PhoneInput.dirty([String value = '']) : super.dirty(value);

  @override
  PhoneValidationError? validator(String? value) {
    if (value == null) {
      return PhoneValidationError.invalid;
    }

    final phone = int.tryParse(value);

    return phone == null || phone < 0 || value.length != 10
        ? PhoneValidationError.invalid
        : null;
  }

  @override
  String toString() {
    return 'phone';
  }
}
