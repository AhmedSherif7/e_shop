part of 'login_cubit.dart';

@immutable
class LoginState extends Equatable {
  const LoginState({
    this.email = const EmailInput.pure(),
    this.password = const LoginPassword.pure(),
    this.errorMessage,
    this.isPasswordHidden = true,
    this.status = FormzStatus.pure,
  });

  final EmailInput email;
  final LoginPassword password;
  final String? errorMessage;
  final bool isPasswordHidden;
  final FormzStatus status;

  @override
  List<Object?> get props => [
        email,
        password,
        status,
        isPasswordHidden,
      ];

  LoginState copyWith({
    EmailInput? email,
    LoginPassword? password,
    String? errorMessage,
    bool? isPasswordHidden,
    FormzStatus? status,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
