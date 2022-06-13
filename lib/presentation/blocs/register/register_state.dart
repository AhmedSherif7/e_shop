part of 'register_cubit.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.email = const EmailInput.pure(),
    this.password = const RegisterPassword.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
    this.isPasswordHidden = true,
    this.isConfirmedPasswordHidden = true,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        confirmedPassword,
        status,
        isPasswordHidden,
        isConfirmedPasswordHidden,
      ];

  final EmailInput email;
  final RegisterPassword password;
  final ConfirmedPassword confirmedPassword;
  final FormzStatus status;
  final String? errorMessage;
  final bool isPasswordHidden;
  final bool isConfirmedPasswordHidden;

  RegisterState copyWith({
    EmailInput? email,
    RegisterPassword? password,
    ConfirmedPassword? confirmedPassword,
    FormzStatus? status,
    String? errorMessage,
    bool? isPasswordHidden,
    bool? isConfirmedPasswordHidden,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      isConfirmedPasswordHidden:
          isConfirmedPasswordHidden ?? this.isConfirmedPasswordHidden,
    );
  }
}
