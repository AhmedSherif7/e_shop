import 'package:formz/formz.dart';

enum CityValidationError { invalid }

class CityInput extends FormzInput<String, CityValidationError> {
  const CityInput.pure() : super.pure('');

  const CityInput.dirty([String value = '']) : super.dirty(value);

  @override
  CityValidationError? validator(String? value) {
    return value == null || value.isEmpty ? CityValidationError.invalid : null;
  }

  @override
  String toString() {
    return 'city';
  }
}
