import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../repositories/user_repository.dart';
import 'base_use_case.dart';

class UpdateUserDataUseCase extends BaseUseCase<Map<String, String>, String> {
  final UserRepository repository;

  UpdateUserDataUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(Map<String, String> input) async {
    return await repository.updateUserData(input);
  }
}
