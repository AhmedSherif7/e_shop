import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../repositories/auth_repository.dart';
import 'base_use_case.dart';

class LogoutUseCase extends BaseUseCase<NoParams, NoOutput> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, NoOutput>> call(NoParams input) async {
    return await repository.logout();
  }
}
