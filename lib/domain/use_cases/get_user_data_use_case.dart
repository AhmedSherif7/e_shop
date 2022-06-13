import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';
import 'base_use_case.dart';

class GetUserDataUseCase extends BaseUseCase<NoParams, UserData> {
  final UserRepository repository;

  GetUserDataUseCase(this.repository);

  @override
  Future<Either<Failure, UserData>> call(NoParams input) async {
    return await repository.getUserData();
  }
}
