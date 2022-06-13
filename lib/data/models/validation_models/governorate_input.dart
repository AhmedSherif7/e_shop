import 'package:formz/formz.dart';

enum GovernorateValidationError { invalid }

class GovernorateInput extends FormzInput<String, GovernorateValidationError> {
  const GovernorateInput.pure() : super.pure('');

  const GovernorateInput.dirty([String value = '']) : super.dirty(value);

  @override
  GovernorateValidationError? validator(String? value) {
    return value == null || value.isEmpty
        ? GovernorateValidationError.invalid
        : null;
  }

  @override
  String toString() {
    return 'governorate';
  }
}
