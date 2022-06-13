import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../repositories/auth_repository.dart';
import 'base_use_case.dart';

class LoginUseCase implements BaseUseCase<LoginUseCaseInput, NoOutput> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, NoOutput>> call(LoginUseCaseInput input) async {
    return await _repository.login(
      input.email,
      input.password,
    );
  }
}

class LoginUseCaseInput {
  final String email;
  final String password;

  LoginUseCaseInput(
    this.email,
    this.password,
  );
}
