import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../repositories/auth_repository.dart';
import 'base_use_case.dart';

class RegisterUseCase implements BaseUseCase<RegisterUseCaseInput, NoOutput> {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, NoOutput>> call(RegisterUseCaseInput input) async {
    return await _repository.register(
      input.email,
      input.password,
    );
  }
}

class RegisterUseCaseInput {
  final String email;
  final String password;

  const RegisterUseCaseInput(this.email, this.password);
}
